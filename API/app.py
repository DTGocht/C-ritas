from fastapi import FastAPI, HTTPException, Depends, status
from pydantic import BaseModel
from datetime import timedelta, datetime
from fastapi.encoders import jsonable_encoder
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from passlib.context import CryptContext
from jose import JWTError, jwt
import mssql_functions as sql
from dotenv import load_dotenv
import os

load_dotenv()

SECRET_KEY = os.environ.get("SECRET_KEY")
ALGORITHM = os.environ.get("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = 30


users_db = sql.obtener_usuarios()


class Token(BaseModel):
    access_token: str
    token_type: str
    idRecolector: int


class TokenData(BaseModel):
    username: str = None


class User(BaseModel):
    id: int
    idRecolector: int
    username: str
    email: str
    hashed_password: str
    disabled: int = None


class LogIn(BaseModel):
    username: str
    password: str


class UserInDB(User):
    hashed_password: str


class Recibo(BaseModel):
    id_recolector: int
    estatus: str
    comentarios: str


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app = FastAPI()


def verify_password(plain_password, hashed_password):
    """
    Verifica que la contraseña sea correcta
    :param plain_password:
    :param hashed_password:
    :return: Regresa True si la contraseña es correcta, de lo contrario False
    """
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    """
    Encripta la contraseña
    :param password:
    :return: Regresa la contraseña encriptada
    """
    return pwd_context.hash(password)


def get_user(db, username: str):
    """
    Verifica que el usuario exista en la base de datos
    :param db:
    :param username:
    :return: Regresa el usuario si existe, de lo contrario regresa None
    """
    for user in db:
        if user["username"] == username:
            return UserInDB(**user)


def authenticate_user(db, username: str, password: str):
    """
    Verifica que el usuario y contraseña sean correctos
    :param db:
    :param username:
    :param password:
    :return: Regresa el usuario si existe y la contraseña es correcta, de lo contrario regresa None
    """
    user = get_user(db, username)
    if not user:
        return False
    if not verify_password(password, user.hashed_password):
        return False
    return user


def create_access_token(data: dict, expires_delta: timedelta or None = None):
    """
    Crea el token de acceso
    :param data:
    :param expires_delta:
    :return: Regresa el token de acceso encriptado con el algoritmo HS256
    """
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, key=SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    Verifica que el token de acceso sea correcto
    :param token:
    :return: Regresa el usuario si el token es correcto,
    de lo contrario regresa un error
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No autorizado",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, key=SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user = get_user(users_db, username=token_data.username)
    if user is None:
        raise credentials_exception
    return user


async def get_current_active_user(
        current_user: UserInDB = Depends(get_current_user)):
    """
    Verifica que el usuario no esté deshabilitado
    :param current_user:
    :return: Regresa el usuario si no está deshabilitado,
    de lo contrario regresa un error
    """
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Usuario inactivo")
    return current_user


@app.post("/token", response_model=Token)
async def login_for_access_token(user: LogIn):
    """
    Rutina para obtener el token de acceso y verificar que el usuario exista
    :param user: Modelo LogIn
    :return: Token de acceso, tipo de token y el id del recolector (usuario)
    """
    user = authenticate_user(users_db, user.username, user.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuario o contraseña incorrectos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    # access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}  # , expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer",
            "idRecolector": user.idRecolector}


@app.get('/users/me', response_model=User)
async def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user


@app.get('/recibosRecolector/{id_recolector}')
async def recibos_recolector(id_recolector: int):
    """
    Obtiene los recibos pendientes de un recolector
    :param id_recolector:
    :return: Regresa los recibos pendientes del recolector en formato JSON
    """
    recibos = sql.obtener_recibos_pendientes(id_recolector)
    return jsonable_encoder(recibos)


@app.get('/recibosEstatusRecolector/{id_recolector}/{estatus}')
async def recibos_estatus_recolector(id_recolector: int, estatus: str):
    """
    Obtiene los recibos de un recolector por estatus, cobrado o no cobrado
    :param id_recolector:
    :param estatus: cobrado o no cobrado
    :return: Los recibos del recolector por estatus en formato JSON
    """
    recibos = sql.obtener_recibos_por_estatus(id_recolector, estatus)
    return jsonable_encoder(recibos)


@app.put('/actualizarRecibo/{id_bitacora}')
async def actualizar_recibo(id_bitacora: int, recibo: Recibo):
    """
    Actualiza el estatus de un recibo
    :param id_bitacora: id del recibo a actualizar
    :param recibo: Modelo de recibo
    :return: True si se actualizó correctamente, de lo contrario regresa un error
    """
    data = recibo.model_dump()
    id_recolector = data['id_recolector']
    estatus = data['estatus']
    comentarios = data['comentarios']

    if sql.actualizar_recibo(id_bitacora, id_recolector, estatus, comentarios):
        return {'message': 'Recibo actualizado'}
    else:
        raise HTTPException(status_code=500,
                            detail='Error al actualizar recibo')


@app.get('/recolectores')
async def obtener_recolectores():
    recolectores = sql.obtener_recolectores()
    return jsonable_encoder(recolectores)


if __name__ == '__main__':
    import uvicorn

    uvicorn.run(app, port=8082, host='0.0.0.0')
