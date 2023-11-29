//
//  Repartidores.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import Foundation

struct Repartidores: Identifiable, Codable {
    var id: Int
    var Nombre: String
    var ApellidoPaterno: String
    var ApellidoMaterno: String
    var EstadoEntrega: String
}

var listaRepartidores = getRepartidores(token: "")

func getRepartidores(token: String) -> Array<Repartidores> {
    var repartidoresList: Array<Repartidores> = []
    
    guard let url = URL(string: "https://equipo16.tc2007b.tec.mx:8443/recolectores") else {
        print("No pude asignar el URL del API")
        return repartidoresList
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
                repartidoresList = try jsonDecoder.decode([Repartidores].self, from: data)
            } catch {
                print(error)
            }
            group.leave()
        }
    }
    
    task.resume()
    group.wait()
    print("******** saliendo de la función")
    return repartidoresList
}

func getEstadoRecolector(idRecolector: Int, token: String) -> ActualizarEstado {
    var estadoRecolector = ActualizarEstado(estatus_entrega: "")
    
    guard let url = URL(string: "https://equipo16.tc2007b.tec.mx:8443/estatusRecolector/\(idRecolector)") else {
        print("No pude asignar el URL del API")
        return estadoRecolector
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
                estadoRecolector = try jsonDecoder.decode(ActualizarEstado.self, from: data)
            } catch {
                print(error)
            }
            group.leave()
        }
    }
    
    task.resume()
    group.wait()
    print("******** saliendo de la función")
    return estadoRecolector
}


struct ActualizarEstado: Codable {
    var estatus_entrega: String
}
