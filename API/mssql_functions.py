import pyodbc as db
import datetime

# Define MSSQL database connection details
conn_str = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=10.14.255.84;"
    "DATABASE=pruebas;"
    "UID=SA;"
    "PWD=Shakira123.;"
    "TrustServerCertificate=yes"  # Disable certificate validation
)


# Function to establish a database connection
def get_db_connection():
    try:
        conn = db.connect(conn_str)
        return conn
    except Exception as e:
        print(f"Error al conectar a SQL Server {e}")


def obtener_usuarios():
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT ID_USUARIO, ID_RECOLECTOR, USER_NAME, "
                       "HASHED_PASSWORD FROM USUARIOS")
        usuarios = [{'id': row[0], 'idRecolector': row[1], 'username': row[2],
                     'hashed_password': row[3]} for row in cursor.fetchall()]

        cursor.close()
        conn.close()

        return usuarios
    except Exception as e:
        return []


def obtener_recolectores():
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


# Método para obtener los recibos pendientes para el día actual
# y que se encuentran asignados al recolector
def obtener_recibos_pendientes(id_recolector):
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT BP.ID_BITACORA, \
            BP.ID_RECOLECTOR, \
            D.NOMBRE, \
            D.APELLIDO_PATERNO, \
            D.APELLIDO_MATERNO, \
            D.DIRECCION, \
            D.COLONIA, \
            D.MUNICIPIO, \
            D.CP, \
            D.REFERENCIAS, \
            D.TEL_MOVIL, \
            D.TEL_CASA, \
            D.TEL_OFICINA,\
            DON.CANTIDAD, \
            BP.ESTATUS  \
            FROM DONANTES D \
            LEFT JOIN DONATIVOS_DONANTE DON ON DON.ID_DONANTE = D.ID_DONANTE \
            LEFT JOIN BITACORA_PAGOS BP ON BP.ID_DONATIVO = DON.ID_DONATIVO \
            WHERE CAST(FECHA_COBRO AS DATE) = CAST(SYSDATETIME() AS DATE) \
            AND BP.ID_RECOLECTOR = ?", id_recolector)
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


# Método para obtener los recibos cobrados o no cobrados para el día actual
# y que se encuentran asignados al recolector
def obtener_recibos_por_estatus(id_recolector, estatus):
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


def actualizar_recibo(id_bitacora, id_recolector, fecha_pago, estatus,
                      fecha_reprogramacion, usuario_cancelacion, comentarios):
    conn = get_db_connection()

    # Convierte la fecha a un objeto datetime
    fecha_date_pago = datetime.datetime.strptime(fecha_pago, '%d/%m/%Y')
    fecha_date_pago = fecha_date_pago.strftime('%Y-%m-%d')

    if fecha_reprogramacion != "":
        fecha_date_reprogramacion = datetime.datetime.strptime(
            fecha_reprogramacion, '%d/%m/%Y')
        fecha_date_reprogramacion = fecha_date_reprogramacion.strftime('%Y-%m-%d')
    else:
        fecha_date_reprogramacion = None

    cursor = conn.cursor()
    try:
        cursor.execute("UPDATE BITACORA_PAGOS \
            SET FECHA_COBRO = ?, \
            ESTATUS = ?, \
            FECHA_REPROGRAMACION = ?, \
            USUARIO_CANCELACION = ?, \
            COMENTARIOS = ?  \
            WHERE ID_BITACORA = ? AND ID_RECOLECTOR = ?",
                       (fecha_date_pago, estatus, fecha_date_reprogramacion,
                        usuario_cancelacion, comentarios, id_bitacora,
                        id_recolector))

        cursor.commit()
        cursor.close()
        conn.close()

        return True
    except Exception as e:
        return False


if __name__ == "__main__":
    recibos = obtener_recibos_pendientes(1)
    print(recibos)
    usuarios = obtener_usuarios()
    print(usuarios)
