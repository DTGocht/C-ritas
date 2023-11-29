//
//  Cobrado_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 03/11/23.
//

import SwiftUI

struct Cobrado_View: View {
    let donador: Int
    var recolector: Recolector
    @State var selectedDate: Date = Date()
    @State private var cancelado: Int = 1
    @State var continuar = false
    @State private var notas: String = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                var listaRecibos = getRecibos(idR: recolector.idRecolector, token: recolector.access_token)
                
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
                        
                        Text("Estatus: Cobrado")
                            .fontWeight(.bold)
                    }
                    
                    
                    ZStack(){
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 333, height: 400)
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
                        .frame(height: 400)
                    }
                    
                    Button(action: {
                        continuar = true;
                        Actualizar(idBitacora: info_donador.id)
                        
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
                
                NavigationLink(isActive: $continuar, destination: {ContentView(recolector: recolector) }, label: { EmptyView()})
                
                
                Spacer()
                
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    
    func Actualizar(idBitacora:Int){
        let actualizar = Actualizar_Recibos(id_recolector: recolector.idRecolector, estatus: "Cobrado", comentarios: notas)
        
        Actualizar_Recibo(recibo: actualizar, id_bitacora: idBitacora, token: recolector.access_token)
    }
}

struct Cobrado_View_Previews: PreviewProvider {
    static var previews: some View {
        Cobrado_View(donador: 1, recolector: Recolector(access_token: "", token_type: "", idRecolector: 1))
    }
}
