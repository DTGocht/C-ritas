import pyodbc as db
import datetime
from dotenv import load_dotenv
import os

load_dotenv()

# Definir la cadena de conexión a la base de datos
conn_str = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    f"SERVER={os.environ.get('SERVER')};"
    f"DATABASE={os.environ.get('DATABASE')};"
    f"UID={os.environ.get('UID')};"
    f"PWD={os.environ.get('PWD')};"
    "TrustServerCertificate=yes"
)


def get_db_connection():
    """
    Función para establecer la conexión a la base de datos
    :return: Conexión a la base de datos
    """
    try:
        conn = db.connect(conn_str)
        return conn
    except Exception as e:
        print(f"Error al conectar a SQL Server {e}")


def obtener_usuarios():
    """
    Método para obtener los usuarios registrados en la base de datos
    para el sistema de recolección de donativos y utilizarlos para
    la autenticación en el login
    :return: Lista de usuarios registrados en la base de datos
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("{CALL ObtenerUsuarios}")
        usuarios = [{'id': row[0], 'idRecolector': row[1], 'username': row[2],
                     'email': row[3], 'hashed_password': row[4],
                     'disabled': row[5]} for row in cursor.fetchall()]

        cursor.close()
        conn.close()

        return usuarios
    except Exception as e:
        return []


def obtener_recolectores():
    """
    Método para obtener los recolectores registrados en la base de datos
    :return: Lista de recolectores registrados en la base de datos
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT ID_RECOLECTOR, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO FROM RECOLECTORES")
        recolectores = [{'id': row[0], 'NombreRecolector': row[1],
                         'ApellidoPaterno': row[2], 'ApellidoMaterno': row[3]}
                        for row in cursor.fetchall()]

        cursor.close()
        conn.close()

        return recolectores
    except Exception as e:
        return []


def obtener_recibos_pendientes(id_recolector):
    """
    Método para obtener los recibos pendientes para el día actual
    y que se encuentran asignados al recolector
    :param id_recolector:
    :return: Lista de recibos pendientes para el día actual
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("{CALL RecibosPendientesReco(?)}", id_recolector)
        recibos = [
            {'id': row[0], 'idRecolector': row[1], 'NombreDonante': row[2], 'ApellidoPaterno': row[3],
             'ApellidoMaterno': row[4], 'Direccion': row[5], 'Colonia': row[6],
             'Municipio': row[7], 'CP': str(row[8]), 'Referencias': row[9],
             'TelMovil': str(row[10]), 'TelCasa': str(row[11]), 'TelOficina': str(row[12]),
             'Importe': float(row[13]), 'Estatus': row[14]}
            for row in cursor.fetchall()]

        cursor.close()
        conn.close()

        return recibos
    except Exception as e:
        return e


def obtener_recibos_por_estatus(id_recolector, estatus):
    """
    Método para obtener los recibos cobrados o no cobrados para el día actual
    y que se encuentran asignados al recolector
    :param id_recolector:
    :param estatus:
    :return: Lista de recibos cobrados o no cobrados para el día actual
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT BP.ID_BITACORA, "
                       " D.NOMBRE, "
                       " D.APELLIDO_PATERNO, "
                       " D.APELLIDO_MATERNO "
                       " FROM DONANTES D "
                       " LEFT JOIN DONATIVOS_DONANTE DON ON DON.ID_DONANTE = D.ID_DONANTE "
                       " LEFT JOIN BITACORA_PAGOS BP ON BP.ID_DONATIVO = DON.ID_DONATIVO "
                       " WHERE BP.ESTATUS = ? "
                       " AND CAST(FECHA_COBRO AS DATE) = CAST(SYSDATETIME() AS DATE) "
                       " AND BP.ID_RECOLECTOR = ?", estatus, id_recolector)
        recibos_cobrados = [{'id': row[0], 'Nombre': row[1],
                             'ApellidoPaterno': row[2],
                             'ApellidoMaterno': row[3]}
                            for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return recibos_cobrados
    except Exception as e:
        return e


def actualizar_recibo(id_bitacora, id_recolector, estatus, comentarios):
    """
    Método para actualizar el estatus de un recibo en la bitácora de pagos
    :param id_bitacora:
    :param id_recolector:
    :param estatus:
    :param comentarios:
    :return: True si se actualizó correctamente, False en caso contrario
    """
    conn = get_db_connection()

    cursor = conn.cursor()
    try:
        params = (estatus, comentarios, id_bitacora,
                  id_recolector)
        cursor.execute("{CALL ActualizarEstadoRecibo(?, ?, ?, ?)}", params)

        cursor.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        return False


if __name__ == '__main__':
    users = obtener_usuarios()
    print(users)
    recibos = obtener_recibos_pendientes(1)
    print(recibos)
    print(actualizar_recibo(1, 1, 'Cobrado', 'Comentarios'))

