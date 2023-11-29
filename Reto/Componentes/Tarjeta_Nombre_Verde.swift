//
//  Tarjeta_Nombres.swift
//  reto_noEntregados
//
//  Created by Jimena Gallegos on 11/10/23.


import SwiftUI

struct Tarjeta_Nombre_Verde: View {
    
    let verdeOscuro = Color(red: 0.24, green: 0.7, blue: 0.24)
    let verdeClaro = Color(red: 0.24, green: 0.7, blue: 0.24).opacity(0.5)
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 333, height: 90)
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.96))
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
                
                HStack{
                    Spacer()
                    Circle()
                        .padding(.top, 33)
                        .frame(width: 20)
                        .foregroundColor(verdeOscuro)
                    
                    
                    Rectangle()
                        .frame(width: 235, height: 0)
                        .foregroundColor(.clear)
                    
                    Rectangle()
                        .frame(width: 13, height: 90)
                        .foregroundColor(verdeClaro)
                    
                    Rectangle()
                        .frame(width: 20, height: 90)
                        .foregroundColor(verdeOscuro)
                    Spacer()
                    }
                }
                .frame(width: 300)
                
            }
        }
    }
    
    struct Tarjeta_Nombre_Verde_Previews: PreviewProvider {
        static var previews: some View {
            Tarjeta_Nombre_Verde()
        }
    }

