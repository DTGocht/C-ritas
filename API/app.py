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
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# usuarios = sql.obtener_usuarios()

users_db = sql.obtener_usuarios()


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str = None


class User(BaseModel):
    id: int
    idRecolector: int
    username: str
    email: str
    hashed_password: str
    disabled: int = None


class UserInDB(User):
    hashed_password: str


class Recibo(BaseModel):
    id_recolector: int
    fecha_cobro: str
    estatus: str
    fecha_reprogramacion: str
    usuario_cancelacion: int
    comentarios: str


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


app = FastAPI()


def verify_password(plain_password, hashed_password):
    # Verifica que la contraseña sea correcta
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    # Encripta la contraseña
    return pwd_context.hash(password)


def get_user(db, username: str):
    for user in db:
        if user["username"] == username:
            return UserInDB(**user)


def authenticate_user(db, username: str, password: str):
    # Verifica que el usuario exista y que la contraseña sea correcta
    user = get_user(db, username)
    if not user:
        return False
    if not verify_password(password, user.hashed_password):
        return False
    return user


def create_access_token(data: dict, expires_delta: timedelta or None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, key=SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token: str = Depends(oauth2_scheme)):
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
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Usuario inactivo")
    return current_user


@app.post("/token", response_model=Token)
async def login_for_access_token(
        form_data: OAuth2PasswordRequestForm = Depends()):
    # Genera un token de acceso
    user = authenticate_user(users_db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Usuario o contraseña incorrectos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@app.get('/users/me', response_model=User)
async def read_users_me(current_user: User = Depends(get_current_active_user)):
    return current_user


@app.get('/recibosRecolector/{id_recolector}')
async def recibos_recolector(id_recolector: int):
    recibos = sql.obtener_recibos_pendientes(id_recolector)
    return jsonable_encoder(recibos)


@app.get('/recibosEstatusRecolector/{id_recolector}/{estatus}')
async def recibos_estatus_recolector(id_recolector: int, estatus: str):
    recibos = sql.obtener_recibos_por_estatus(id_recolector, estatus)
    return jsonable_encoder(recibos)


@app.put('/actualizarRecibo/{id_bitacora}')
async def actualizar_recibo(id_bitacora: int, recibo: Recibo):
    data = recibo.model_dump()

    id_recolector = data['id_recolector']
    fecha_pago = data['fecha_cobro']
    estatus = data['estatus']
    fecha_reprogramacion = data['fecha_reprogramacion']
    usuario_cancelacion = data['usuario_cancelacion']
    comentarios = data['comentarios']

    if sql.actualizar_recibo(id_bitacora, id_recolector, fecha_pago, estatus,
                             fecha_reprogramacion, usuario_cancelacion,
                             comentarios):
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

