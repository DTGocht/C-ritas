//
//  ContentView.swift
//  reto_noEntregados
//
//  Created by Jimena Gallegos on 11/10/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Recibos_Pendientes_View()
                .tabItem{
                    Label("Pendientes",systemImage: "house.circle")
                }
            Recibos_Cobrados_View()
                .tabItem{
                    Label("Cobrados", systemImage: "doc.richtext.fill")
                }
            Recibos_No_Cobrados_View()
                .tabItem{
                    Label("No cobrados", systemImage: "doc.richtext.fill")
                }
            
        }
        .tint(Color("PantoneAC"))
        .navigationBarBackButtonHidden(true)
        //sirve para cambiar el background del nav bar
        /*
         .onAppear(){
         UITabBar.appearance().barTintColor = UIColor(Color("PantoneGC"))
         UITabBar.appearance().backgroundColor = UIColor(Color("PantoneGC"))
         }
         */
             
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
