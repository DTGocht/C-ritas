//
//  Donante_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import SwiftUI
import MapKit

struct Donante_View: View {
    let donador: Int
    @State var listaRecibos = getRecibos()
    
        var body: some View {
            VStack {
                if let info_donador = listaRecibos.first(where: { $0.id == donador }) {
                    Header()
                    
                    Text("\(info_donador.DONANTE_NOMBRE) \(info_donador.DONANTE_APELLIDOP)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom,3)
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 145)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack(spacing: 2){
                            Text("Celular")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.DONANTE_TELMOV)", destination: URL(string: "tel:\(info_donador.DONANTE_TELMOV)")!)
                                .frame(width: 310, alignment: .leading)
                            
                            Divider()
                                .frame(width: 310)
                            
                            Text("Casa")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.DONANTE_TELCASA)", destination: URL(string: "tel:\(info_donador.DONANTE_TELCASA)")!)
                                .frame(width: 310, alignment: .leading)
                            
                            Divider()
                                .frame(width: 310)
                            
                            Text("Tel Referente")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.DONANTE_TELCASA)", destination: URL(string: "tel:\(info_donador.DONANTE_TELCASA)")!)
                                .frame(width: 310, alignment: .leading)
                        }
                    }
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 175)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            Text("Dirreción")
                            
                            Text("\(info_donador.DONANTE_COL.capitalized)")
                            
                            Text("\(info_donador.DONANTE_DIR.capitalized)")
                            
                            Text("\(info_donador.DONANTE_MUN.capitalized)")
                            
                            Text("\(info_donador.DONANTE_CP.capitalized)")
                        }
                        
                    }
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 72)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            Text("Cantidad a cobrar")
                                .frame(width: 310, alignment: .leading)
                            
                            Text("$\(info_donador.IMPORTE, specifier: "%.2f")")
                                .font(
                                    Font.custom("SF Pro", size: 26)
                                    .weight(.medium)
                                    )
                                .foregroundColor(Color(red: -0.169, green: 0.646, blue: 0.678))
                                .frame(width: 310, alignment: .leading)
                            
                        }
                    }
                    ZStack{
                        Button(action: { }) {
                        }
                        .frame(width: 340, height: 56)
                        .background(Color(red: 0.28, green: 0.63, blue: 0.28))
                        .cornerRadius(10)
                        
                        Image("Entregado")
                    }
                    
                    ZStack{
                        Button(action: { }) {
                        }
                        .frame(width: 340, height: 56)
                        .background(Color(red: 0.78, green: 0.04, blue: 0.05))
                        .cornerRadius(10)
                        
                        Image("No Entregado")
                    }
                    
                }
                Spacer()
            }
            .padding()
        }
    }

struct Donante_View_Previews: PreviewProvider {
    static var previews: some View {
        Donante_View(donador: 1)
    }
}


