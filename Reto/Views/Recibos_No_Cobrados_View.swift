//
//  Recibos_No_Cobrados_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import SwiftUI

struct Recibos_No_Cobrados_View: View {
    @State var listaRecibos = getRecibos()
    @State var listaRepartidores = getRepartidores()
    @State var id = 1
    
    var body: some View {
        NavigationStack{
            Header()
                
            VStack{
                Text("No Cobrados")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 350, alignment: .leading)
                List {
                    ForEach(listaRecibos.filter{$0.ESTATUS == "No Cobrado" && $0.REPARTIDOR_ID == id}) { recibo in
                        Recibos_Lista(recibo: recibo)
                    }
                    .onMove(perform: moveRecibo)
                }
                .listStyle(.inset)
                
                Spacer()
            } .padding()
            }
            
    }
    
    func moveRecibo(from source: IndexSet, to destination: Int) {
            listaRecibos.move(fromOffsets: source, toOffset: destination)
        }
}

struct Recibos_No_Cobrados_View_Previews: PreviewProvider {
    static var previews: some View {
        Recibos_No_Cobrados_View()
    }
}
