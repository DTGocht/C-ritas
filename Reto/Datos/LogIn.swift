//
//  LogIn.swift
//  Reto
//
//  Created by Jaime Cabrera on 05/11/23.
//

import Foundation


func VerificarUsuario(usr: User) -> Recolector {

    let body: [String: Any] = [
        "username": usr.username,
        "password": usr.password
    ]

    // Inicializa recolector
    var recolector = Recolector(access_token: "", token_type: "", idRecolector: 0)


    let jsonData = try? JSONSerialization.data(withJSONObject: body)

    guard let url = URL(string: "http://10.22.197.45:8082/token") else {
        print("No pude asignar el URL del API")
        return recolector
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpBody = jsonData

    let group = DispatchGroup()
    group.enter()

    let task = URLSession.shared.dataTask(with: request) { data, response, error in

        if let data = data {
            let decoder = JSONDecoder()
            do {
                let recolectorResponse = try decoder.decode(Recolector.self, from: data)
                print("*************** Respuesta *****************")
                print(recolectorResponse)
                recolector = recolectorResponse // Asigna la respuesta al recolector
            } catch {
                print("Error al decodificar la respuesta: \(error)")
            }
        } else {
            print("Error: \(error)")
        }
        group.leave()
    }

    task.resume()
    group.wait()
    print("********* saliendo de la función")
    return recolector
}


struct Recolector: Codable {
    var access_token: String
    var token_type: String
    var idRecolector: Int
}


struct User: Codable {
    var username: String
    var password: String
}
