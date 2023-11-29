//
//  Recibos.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import Foundation

var listaRecibos = getRecibos(idR: 1, token: "")

// Access Token
func getRecibos(idR: Int, token: String) -> Array<Recibos> {
    var pendientesList: Array<Recibos> = []

    // Crear la URL con el token en el encabezado
    guard let url = URL(string: "https://equipo16.tc2007b.tec.mx:8443/recibosRecolector/\(idR)") else {
        print("No pude asignar el URL del API")
        return pendientesList
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    // Agregar el token al encabezado
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let group = DispatchGroup()
    group.enter()

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        let jsonDecoder = JSONDecoder()
        if let data = data {
            do {
                pendientesList = try jsonDecoder.decode([Recibos].self, from: data)
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


func Actualizar_Recibo(recibo: Actualizar_Recibos, id_bitacora: Int, token: String){
    
    let body: [String: Any] = [
        "id_recolector": recibo.id_recolector,
        "estatus": recibo.estatus,
        "comentarios": recibo.comentarios
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: body)
    
    guard let url = URL(string: "https://equipo16.tc2007b.tec.mx:8443/actualizarRecibo/\(id_bitacora)") else{
        print("No pude asigna el URL del API")
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    // Agregar el token al encabezado
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = jsonData
    
    let group = DispatchGroup()
    group.enter()
    
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        
        if (data != nil){
            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("*************** Respuesta *****************")
                print(responseJSON)
            }
        }else{
            print("Error: \(error)")
        }
        group.leave()
    }
    
    task.resume()
    group.wait()
    print("********* saliendo de la función")
    return
}

struct Actualizar_Recibos: Codable {
    var id_recolector: Int
    var estatus: String
    var comentarios: String
}
