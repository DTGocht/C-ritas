//
//  Cobrado_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 03/11/23.
//

import SwiftUI

struct No_Cobrado_View: View {
    let donador: Int
    @State var listaRecibos = getRecibos()
    @State var selectedDate: Date = Date()
    @State private var cancelado: Int = 1
    @State private var notas: String = ""
    @State var continuar = false
    
    var body: some View {
        NavigationStack{
            VStack{
                if let info_donador = listaRecibos.first(where: { $0.id == donador }) {
                    
                    Header()
                    
                    Text("\(info_donador.NombreDonante) \(info_donador.ApellidoPaterno)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 15)
                    
                    ZStack{
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 333, height: 48)
                          .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                          .cornerRadius(10)
                        
                        Text("Estatus: No Cobrado")
                            .fontWeight(.bold)
                    }
                    
                    ZStack{
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 333, height: 103)
                          .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                          .cornerRadius(10)
                        
                        VStack{
                            
                            Text("Fecha de reprogramación")
                                .fontWeight(.bold)
                            
                            DatePicker("", selection: $selectedDate)
                                            .datePickerStyle(.compact)
                                            .frame(width: 70)
                                    }
                        
                    }
                    
                    ZStack{
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 333, height: 103)
                          .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                          .cornerRadius(10)
                        
                        VStack{
                            Text("¿Usuario cancelado?")
                                .fontWeight(.bold)
                            
                            Picker(selection: $cancelado, label: Text("Estado Cancelado")){
                                Text("Si").tag(5)
                                Text("No").tag(10)
                            }
                            .pickerStyle(.segmented)
                            .frame(width: 300)
                        }
                        
        
                    }
                    
                    ZStack(){
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 333, height: 200)
                          .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                          .cornerRadius(10)
                        
                        VStack(){
                            Text("Notas")
                                .fontWeight(.bold)
                                .padding(.top, 20)
                            
                            TextField(" Agrega tus comentarios ", text: $notas)
                                .frame(width: 300, height: 50)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            
                        }
                        .frame(height: 200)
                    }
                    
                    Button(action: {
                        continuar = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Continuar")
                            Spacer()
                        }
                    }
                    .frame(width: 333, height: 56)
                    .background(Color(red: 0.28, green: 0.63, blue: 0.28))
                    .foregroundColor(.white)
                    .bold()
                    .cornerRadius(10)
                    
                }
                 
                NavigationLink(isActive: $continuar, destination: { Recibos_Pendientes_View() }, label: { EmptyView()})
                
                
                Spacer()
                
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct No_Cobrado_View_Previews: PreviewProvider {
    static var previews: some View {
        No_Cobrado_View(donador: 1)
    }
}
