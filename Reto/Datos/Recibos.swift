//
//  Recibos.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import Foundation

var listaRecibos = getRecibos()

func getRecibos() -> Array<Recibos>{
    var pendientesList: Array<Recibos> = []
    
    guard let url = URL(string:"http://10.22.199.153:8082/recibosRecolector/1") else {
        print("No pude asignar el URL del API")
        return pendientesList
    }
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        
        let jsonDecoder = JSONDecoder()
        if (data != nil){
            do {
                pendientesList = try jsonDecoder.decode([Recibos].self, from: data!)
            } catch {
                print(error)
            }
            group.leave()
        }
    }
    
    task.resume()
    group.wait()
    print("******** saliendo de la función")
    return pendientesList
}


struct Recibos: Codable, Identifiable{
    var id: Int
    var idRecolector: Int
    var NombreDonante: String
    var ApellidoPaterno: String
    var ApellidoMaterno: String
    var Direccion: String
    var Colonia: String
    var Municipio: String
    var CP: String
    var Referencias: String
    var TelMovil: String
    var TelCasa: String
    var TelOficina: String
    var Importe: Float
    var Estatus: String
}
/*
import Foundation

struct Recibos: Codable, Identifiable{
    var ApellidoMaterno: String
    var ApellidoPaterno: String
    var CP: String
    var Colonia: String
    var Direccion: String
    var Estatus: String
    var Importe: Float
    var Municipio: String
    var NombreDonante: String
    var TelCasa: String
    var TelMovil: String
    var TelOficina: String
    var id: Int
    var Referencia: String
    var idRecolector: Int
}

var listaRecibos = getRecibos()

func getRecibos() -> Array<Recibos>{
    var lista: Array<Recibos> = [
        Recibos(ApellidoMaterno: "Flores", ApellidoPaterno: "Cabrera", CP: "83220", Colonia: "Nueva España", Direccion: "Garza Sada", Estatus: "Pendiente", Importe: 400, Municipio: "Monterrey", NombreDonante: "Jaime", TelCasa: "6623076006", TelMovil: "6623076006", TelOficina: "6623076006", id: 1, Referencia: "Casa Azul", idRecolector: 1),
        Recibos(ApellidoMaterno: "Flores", ApellidoPaterno: "Cabrera", CP: "83220", Colonia: "Nueva España", Direccion: "Garza Sada", Estatus: "Pendiente", Importe: 400, Municipio: "Monterrey", NombreDonante: "Jaime", TelCasa: "", TelMovil: "6623076006", TelOficina: "6623076006", id: 2, Referencia: "Casa Azul", idRecolector: 1),
        Recibos(ApellidoMaterno: "Flores", ApellidoPaterno: "Cabrera", CP: "83220", Colonia: "Nueva España", Direccion: "Garza Sada", Estatus: "Pendiente", Importe: 400, Municipio: "Monterrey", NombreDonante: "Jaime", TelCasa: "", TelMovil: "6623076006", TelOficina: "", id: 3, Referencia: "Casa Azul", idRecolector: 1),
        Recibos(ApellidoMaterno: "Cardenas", ApellidoPaterno: "Gallegos", CP: "83220", Colonia: "Nueva España", Direccion: "Garza Sada", Estatus: "Cobrado", Importe: 400, Municipio: "Monterrey", NombreDonante: "Victor", TelCasa: "", TelMovil: "6623076006", TelOficina: "", id: 3, Referencia: "Casa Azul", idRecolector: 1),
        Recibos(ApellidoMaterno: "Blanco", ApellidoPaterno: "Rongel", CP: "83220", Colonia: "Nueva España", Direccion: "Garza Sada", Estatus: "No Cobrado", Importe: 400, Municipio: "Monterrey", NombreDonante: "America", TelCasa: "", TelMovil: "6623076006", TelOficina: "", id: 3, Referencia: "Casa Azul", idRecolector: 1),
        
        
        
    ]
    
    return lista
}
*/
