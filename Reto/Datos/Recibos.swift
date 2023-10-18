//
//  Recibos.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import Foundation

struct Recibos: Codable, Identifiable{
    var BITACORA: Int
    var DONANTE_APELLIDOM: String
    var DONANTE_APELLIDOP: String
    var DONANTE_COL: String
    var DONANTE_CP: String
    var DONANTE_DIR: String
    var DONANTE_MUN: String
    var DONANTE_NOMBRE: String
    var DONANTE_TELCASA: String
    var DONANTE_TELMOV: String
    var ESTATUS: String
    var IMPORTE: Double
    var REPARTIDOR_ID: Int
    var id: Int{
        return self.BITACORA
    }
}
