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
    var ApellidoMaterno: String
    var ApellidoPaterno: String
    var CP: String
    var Colonia: String
    var Direccion: String
    var Estatus: String
    var Importe: Float
    var Municipio: String
    var NombreDonante: String
    var Referencias: String
    var TelCasa: String
    var TelMovil: String
    var TelOficina: String
    var id: Int
    var idRecolector: Int
    var Referencia: String
}
