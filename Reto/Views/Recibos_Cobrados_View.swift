//
//  Recibos_Cobrados_View.swift
//  Reto
//
//  Created by Jimena Gallegos on 13/10/23.
//

import SwiftUI

struct Recibos_Cobrados_View: View {
    var recolector: Recolector
    @State var listaRecibos: Array<Recibos> = []
    @State var listaRepartidores = getRepartidores()
    //@State var id = 1
    
    var body: some View {
        NavigationStack{
            Header()
            VStack{
                Text("Cobrados")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(width: 350, alignment: .leading)
                List {
                    ForEach(listaRecibos.filter{$0.Estatus == "Cobrado" && $0.idRecolector == recolector.idRecolector}) { recibo in
                        Recibos_Lista(recibo: recibo)
                    }
                }
                .listStyle(.inset)
                
                .onAppear(){
                    listaRecibos = getRecibos(idR: recolector.idRecolector)
                }
                
                HStack{
                    Tarjeta_Acumulado(recolector: recolector)
                    Tarjeta_Status(repatidor: listaRepartidores[recolector.idRecolector-1])
                }
                
                Spacer()
            } .padding()
        }
        
    }
    
    func moveRecibo(from source: IndexSet, to destination: Int) {
        listaRecibos.move(fromOffsets: source, toOffset: destination)
    }
}

struct Recibos_Cobrados_View_Previews: PreviewProvider {
    static var previews: some View {
        Recibos_Cobrados_View(recolector: Recolector(access_token: "", token_type: "", idRecolector: 1))
    }
}
