//
//  Tarjeta_Nombres.swift
//  reto_noEntregados
//
//  Created by Jimena Gallegos on 12/10/23.


import SwiftUI

struct Tarjeta_Nombre_Roja: View {
    
    let rojoOscuro = Color(red: 0.78, green: 0.04, blue: 0.05)
    let rojoClaro = Color(red: 0.861, green: 0.496, blue: 0.51)
    
    
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
                        .foregroundColor(rojoOscuro)
                    
                    Rectangle()
                        .frame(width: 235, height: 0)
                        .foregroundColor(.clear)
                    
                    Rectangle()
                        .frame(width: 13, height: 90)
                        .foregroundColor(rojoClaro)
                    
                    Rectangle()
                        .frame(width: 20, height: 90)
                        .foregroundColor(rojoOscuro)
                    Spacer()
                }
            }
            .frame(width: 300)
                
            }
        }
    }
    
    struct Tarjeta_Nombre_Roja_Previews: PreviewProvider {
        static var previews: some View {
            Tarjeta_Nombre_Roja()
        }
    }
