//
//  Recibos_No_Cobrados_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import SwiftUI

struct Recibos_No_Cobrados_View: View {
    var recolector: Recolector
    @State var listaRecibos: Array<Recibos> = []
    @State var id = 1
    
    var body: some View {
        NavigationStack{
            @State var listaRepartidores = getRepartidores(token: recolector.access_token)
            Header()
            
            VStack{
                Text("No Cobrados")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 350, alignment: .leading)
                List {
                    ForEach(listaRecibos.filter{$0.Estatus == "No Cobrado" && $0.idRecolector == recolector.idRecolector}) { recibo in
                        Recibos_Lista(recibo: recibo)
                    }
                    .onMove(perform: moveRecibo)
                }
                .listStyle(.inset)
                .onAppear(){
                    listaRecibos = getRecibos(idR: recolector.idRecolector, token: recolector.access_token)
                }
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
        Recibos_No_Cobrados_View(recolector: Recolector(access_token: "", token_type: "", idRecolector: 1))
    }
}
