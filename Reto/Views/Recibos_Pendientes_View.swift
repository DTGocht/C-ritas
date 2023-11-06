//
//  Recibos_Pendientes_View.swift
//  reto_noEntregados
//
//  Created by Manuel on 12/10/23.
//

import SwiftUI

struct Recibos_Pendientes_View: View {
    @State var listaRecibos: Array<Recibos> = []
    @State var listaRepartidores = getRepartidores()
    @State var id = 1
    
    var body: some View {
        NavigationStack{
            Header()
                .offset(y: -35)
            VStack{
                Text("Pendientes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 350, alignment: .leading)
                List {
                    ForEach(listaRecibos.filter { $0.Estatus == "Pendiente" && $0.idRecolector == id}) { recibo in
                        NavigationLink(destination: Donante_View(donador: recibo.id)) {
                            Recibos_Lista(recibo: recibo)
                        }
                    }
                    .onMove(perform: moveRecibo)
                }
                .listStyle(.inset)
                .onAppear(){
                    listaRecibos = getRecibos()}
                .navigationBarItems(trailing: EditButton())
                
                
                Spacer()
            } .padding()
                .offset(y: -35)
                .navigationBarBackButtonHidden(true)
            }
            
    }
    /*NavigationLink(destination: Jimena()) {JimenaView()}*/
    
    func moveRecibo(from source: IndexSet, to destination: Int) {
            listaRecibos.move(fromOffsets: source, toOffset: destination)
        }
}

struct Recibos_Pendientes_View_Previews: PreviewProvider {
    static var previews: some View {
        Recibos_Pendientes_View()
    }
}
