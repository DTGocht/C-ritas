import pyodbc as db
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
        return [e]


def obtener_recolectores():
    """
    Método para obtener los recolectores registrados en la base de datos
    :return: Lista de recolectores registrados en la base de datos
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("{CALL ObtenerRecolectores}")
        recolectores = [{'id': row[0], 'Nombre': row[1],
                         'ApellidoPaterno': row[2], 'ApellidoMaterno': row[3],
                         'EstadoEntrega': row[4]} for row in cursor.fetchall()]
        cursor.close()
        conn.close()

        return recolectores
    except Exception as e:
        return [e]


def obtener_estatus_entrega_recolector(id_recolector):
    """
    Método para obtener el estatus de entrega de un recolector
    :param id_recolector:
    :return: Objeto con el estatus de entrega del recolector
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("{CALL ObtenerEstadoEntregaRecolector(?)}", id_recolector)
        estatus = {'EstatusEntrega': cursor.fetchone()[0]}

        cursor.close()
        conn.close()
        return estatus
    except Exception as e:
        return {e}


def actualizar_estado_recolector(id_recolector, estado):
    """
    Método para actualizar el estado de entrega de un recolector
    :param id_recolector: Identificador del recolector
    :param estado: Estado de entrega del recolector
    :return: True si se actualizó correctamente, False en caso contrario
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("{CALL ActualizarEstadoEntrega(?, ?)}", id_recolector,
                       estado)

        cursor.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        return False


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
        return {'Error': e}


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


def cantidad_recibos_estatus():
    """
    Método para obtener la cantidad de recibos pendientes, cobrados y no cobrados
    :return: Una lista de la cantidad de recibos por estatus
    """
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("{CALL CantidadRecibosEstatus}")
        cantidad_recibos = [{'Estatus': row[0], 'Cantidad': row[1], 'Total': float(row[2])}
                            for row in cursor.fetchall()]
        cursor.close()
        conn.close()
        return cantidad_recibos
    except Exception as e:
        return e
