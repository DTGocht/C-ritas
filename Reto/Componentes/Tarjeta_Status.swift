//
//  Tarjeta_Status.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import SwiftUI
struct Tarjeta_Status: View {
    var recolector: Recolector
    @State var repatidor: Repartidores
    @State var ActualizarEstado: ActualizarEstado

    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 160, height: 90)
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                
                VStack{
                    Text("Estatus ")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                    
                    /*Text("\(repatidor.estado)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hue: 0.564, saturation: 0.106, brightness: 0.217))*/
                    Text("\(repatidor.EstadoEntrega)")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hue: 0.564, saturation: 0.106, brightness: 0.217))
                }
                .onAppear(){
                    ActualizarEstado = getEstadoRecolector(idRecolector: repatidor.id, token: recolector.access_token)
                }
            }
        }
    }
}

struct Tarjeta_Status_Previews: PreviewProvider {
    static var previews: some View {
        var rep1: Repartidores = listaRepartidores[1]
        Tarjeta_Status(recolector: Recolector(access_token: "", token_type: "", idRecolector: 1), repatidor: rep1, ActualizarEstado: ActualizarEstado(estatus_entrega: ""))
    }
}
