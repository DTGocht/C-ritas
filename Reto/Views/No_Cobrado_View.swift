//
//  Cobrado_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 03/11/23.
//

import SwiftUI

struct No_Cobrado_View: View {
    let donador: Int
    var recolector: Recolector
    
    var razones = ["No se encontraba en casa", "Ya no vive ahi", "No desea continuar ayudando", "Indispuesto", "No se ubicó el domicilio"]
    @State private var razon_selecionada = "No se encontraba en casa"
    @State private var notas: String = ""
    @State private var notas_verificar = false
    
    @State var continuar = false
    
    
    var body: some View {
        NavigationStack{
            VStack{
                var listaRecibos = getRecibos(idR: recolector.idRecolector)
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
                            .frame(width: 333, height: 180)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            Text("Selecciona razon por la cual no pudo recolectar el donativo")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.top, 20)
                                .frame(width: 300)
                            
                            Picker("Please choose a color", selection: $razon_selecionada) {
                                            ForEach(razones, id: \.self) {
                                                Text($0)
                                            }
                                        }
                            .pickerStyle(.inline)
                            .frame(width: 300, height: 100)
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
                            
                            Text("\(razon_selecionada)")
                                .frame(width: 300, alignment: .leading)
                                .padding(.top, 5)
                            
                            TextField("Agrega tus comentarios extras", text: $notas)
                                .frame(width: 300, height: 10)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            
                        }
                        .frame(height: 200)
                    }
                    
                    Button(action: {
                        if notas.isEmpty{
                            continuar = false
                            notas_verificar = true
                        }
                        else{
                            notas_verificar = false
                            continuar = true
                            Actualizar(idBitacora: info_donador.id)
                        }
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
                    .alert(isPresented: $notas_verificar, content: {
                        Alert(title: Text("No se agrego nota"), message: Text("Favor de agregar una nota para poder continuar"), dismissButton: .cancel())})
                    
                }
                
                NavigationLink(isActive: $continuar, destination: { ContentView(recolector: recolector) }, label: { EmptyView()})
                
                
                Spacer()
                
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    func Actualizar(idBitacora:Int){
        
        let actualizar = Actualizar_Recibos(id_recolector: recolector.idRecolector, estatus: "No Cobrado", comentarios: ("\(razon_selecionada). \(notas)"))
        
        Actualizar_Recibo(recibo: actualizar, id_bitacora: idBitacora)
    }
}

struct No_Cobrado_View_Previews: PreviewProvider {
    static var previews: some View {
        No_Cobrado_View(donador: 1, recolector: Recolector(access_token: "", token_type: "", idRecolector: 1))
    }
}
