//
//  ContentView.swift
//  Login|
//
//  Created by Manuel Ortiz on 19/10/23.
//

import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var opacity = 0.5
    var body: some View {
        NavigationStack{


            VStack{
                Spacer()

                Image("Logo")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding(.bottom, 20)


                TextField("", text: $username, prompt: Text("Matrícula o Usuario").foregroundColor(Color("PantoneGC")))
                    .frame(height: 45)
                    .foregroundColor(.white)
                    .background(Color("PantoneAC"))
                    .border(Color("PantoneAC"), width: 2)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                TextField("", text: $password, prompt: Text("Contraseña").foregroundColor(Color("PantoneGC")))
                    .frame(height: 45)
                    .foregroundColor(.white)
                    .background(Color("PantoneAC"))
                    .border(Color("PantoneAC"), width: 2)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)
                HStack{
                    Spacer()
                    Button("¿Olvidaste tu contraseña?"){

                    }
                    .font(.footnote)
                    .foregroundColor(Color("PantoneAO"))
                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    .padding(.bottom, 15)

                }


                /*
                Button("Iniciar Sesión"){
                    NavigationLink(){
                        ContentView()
                    }
                }
                 */
                NavigationLink("Iniciar Sesión"){
                   ContentView()
                }

                .frame(width: 320, height: 45)
                .foregroundColor(.white)
                .background(Color("PantoneAO"))
                .border(Color("PantoneAO"), width: 2)
                .cornerRadius(5)
                .padding(.horizontal, 30)
                .frame(width: 320, height: 45)

                Spacer()
                Spacer()
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}

