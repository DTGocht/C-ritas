from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.encoders import jsonable_encoder
import mssql_functions as sql

app = FastAPI()


class Recibo(BaseModel):
    id_recolector: int
    fecha_cobro: str
    estatus: str
    fecha_reprogramacion: str
    usuario_cancelacion: int
    comentarios: str


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

    uvicorn.run(app, host='0.0.0.0', port=8082)
