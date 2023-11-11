//
//  Tarjeta_Nombres.swift
//  reto_noEntregados
//
//  Created by Jimena Gallegos on 11/10/23.


import SwiftUI

struct Tarjeta_Nombre_Amarilla: View {
    let amarilloOscuro = Color(red: 0.92, green: 0.93, blue: 0.49)
    let amarilloClaro = Color(red: 0.92, green: 0.93, blue: 0.49)
    
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 333, height: 90)
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)

                HStack{
                    Spacer()
                    
                    Image("loc_marker")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .offset(x: 8, y: 18)
                        .frame(width: 25)
                    
                    Rectangle()
                        .frame(width: 235, height: 0)
                        .foregroundColor(.clear)
                    
                    Rectangle()
                        .frame(width: 13, height: 90)
                        .foregroundColor(amarilloClaro)

                    Rectangle()
                        .frame(width: 20, height: 90)
                        .foregroundColor(amarilloOscuro)
                    Spacer()
                }
            }
            .frame(width: 300)
            
        }
        }
}

struct Tarjeta_Nombre_Amarilla_Previews: PreviewProvider {
    static var previews: some View {
        Tarjeta_Nombre_Amarilla()
    }
}

