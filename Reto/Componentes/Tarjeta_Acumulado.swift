//
//  Tarjeta_Acumulado.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import SwiftUI

struct Tarjeta_Acumulado: View {
    var recolector: Recolector
    
    var body: some View {
        VStack{
            let recibosCobrados = getRecibos(idR: recolector.idRecolector, token: recolector.access_token)
            
            let totalCantidad = recibosCobrados
                .filter { $0.Estatus == "Cobrado"}
                    .reduce(0) { (result, recibo) in
                        return result + recibo.Importe
                    }
            
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 160, height: 90)
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                
                VStack{
                    Text("Acumulado ")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                    
                    Text("$\(totalCantidad, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.03, green: 0.347, blue: 0.545))
                     
                }
            }
        }
    }
}


struct Tarjeta_Acumulado_Previews: PreviewProvider {
    static var previews: some View {
        Tarjeta_Acumulado(recolector: Recolector(access_token: "", token_type: "", idRecolector: 2))
    }
}
