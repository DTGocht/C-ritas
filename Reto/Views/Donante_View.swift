//
//  ContentView.swift
//  reto_noEntregados
//
//  Created by Jimena Gallegos on 11/10/23.
//

import SwiftUI

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    @State var comentario: String
    @State var nuevo: String
    
    var body: some View {
        
        VStack{
            Spacer()
            HStack{
                Spacer()
            }
            Text("Agrega un comentario")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.01, green: 0.56, blue: 0.62))
              .frame(width: 320, height: 35, alignment: .leading)
            
            TextField("Detalles", text: $nuevo, axis: .vertical)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
                .frame(width: 320)
            
            HStack{
                Button("Añadir"){
                    comentario = nuevo
                    print(comentario)
                    dismiss()
                }.buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.01, green: 0.56, blue: 0.62))
                
                Button("Cancelar"){
                    print(comentario)
                    dismiss()
                }.buttonStyle(.borderedProminent)
                    .tint(Color(red: 0.01, green: 0.56, blue: 0.62))
            }
            Spacer()
        }
        .background(Color(hue: 0.519, saturation: 0.364, brightness: 0.914))
    }
}

struct Donante_View: View {
    let donador: Int
    @State var Alerta_Recibido = false
    @State var Alerta_No_Recibido = false
    @State var listaRecibos = getRecibos()
    @State private var mostrarComentarios = false
    @State private var cobrado = false
    @State private var no_cobrado = false
    
    var body: some View {
        VStack {
            if let info_donador = listaRecibos.first(where: { $0.id == donador }) {
                
                if (info_donador.TelMovil != "" && info_donador.TelCasa != "" && info_donador.TelOficina != ""){
                    
                    Header()
                    
                    Text("\(info_donador.NombreDonante) \(info_donador.ApellidoPaterno)")
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
                            
                            Link("\(info_donador.TelMovil)", destination: URL(string: "tel:\(info_donador.TelMovil)")!)
                                .frame(width: 310, alignment: .leading)
                            
                            Divider()
                                .frame(width: 310)
                            
                            Text("Casa")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelCasa)", destination: URL(string: "tel:\(info_donador.TelCasa)")!)
                                .frame(width: 310, alignment: .leading)
                            
                            Divider()
                                .frame(width: 310)
                            
                            Text("Tel Referente")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelOficina)", destination: URL(string: "tel:\(info_donador.TelOficina)")!)
                                .frame(width: 310, alignment: .leading)
                        }
                    }
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 175)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack(spacing: 4){
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Dirreción")
                                    
                                    Text("\(info_donador.Colonia.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Direccion.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Municipio.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.CP.capitalized)")
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Mapa()
                            }
                            .frame(width: 310)
                            
                            Divider()
                                .frame(width: 320)
                            
                            Text("Referencia")
                                .frame(width: 310, alignment: .leading)
                            
                            Text("\(info_donador.Referencias.capitalized)")
                                .foregroundColor(.blue)
                                .frame(width: 310, alignment: .leading)
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
                            
                            Text("$\(info_donador.Importe, specifier: "%.2f")")
                                .font(
                                    Font.custom("SF Pro", size: 26)
                                    .weight(.medium)
                                    )
                                .foregroundColor(Color(red: 0.061, green: 0.51, blue: 0.997))
                                .frame(width: 310, alignment: .leading)
                            
                        }
                    }
                    Button(action: {
                        Alerta_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.28, green: 0.63, blue: 0.28))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    Button(action: {
                        Alerta_No_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("No Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.78, green: 0.04, blue: 0.05))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_No_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como No Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    no_cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    NavigationLink(isActive: $cobrado, destination: { Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                    NavigationLink(isActive: $no_cobrado, destination: { No_Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                Spacer()
                }
                
                else if (info_donador.TelMovil != "" && info_donador.TelCasa != "" && info_donador.TelOficina == ""){
                    Header()
                    
                    Text("\(info_donador.NombreDonante) \(info_donador.ApellidoPaterno)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom,3)
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 120)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            Text("Celular")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelMovil)", destination: URL(string: "tel:\(info_donador.TelMovil)")!)
                                .frame(width: 310, alignment: .leading)
                            
                            Divider()
                                .frame(width: 310)
                            
                            Text("Casa")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelCasa)", destination: URL(string: "tel:\(info_donador.TelCasa)")!)
                                .frame(width: 310, alignment: .leading)
                        }
                    }
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 198)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Dirreción")
                                    
                                    Text("\(info_donador.Colonia.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Direccion.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Municipio.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.CP.capitalized)")
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Mapa()
                            }
                            .frame(width: 310)
                            
                            Divider()
                                .frame(width: 320)
                            
                            Text("Referencia")
                                .frame(width: 310, alignment: .leading)
                            
                            Text("\(info_donador.Referencias.capitalized)")
                                .foregroundColor(.blue)
                                .frame(width: 310, alignment: .leading)
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
                            
                            Text("$\(info_donador.Importe, specifier: "%.2f")")
                                .font(
                                    Font.custom("SF Pro", size: 26)
                                    .weight(.medium)
                                    )
                                .foregroundColor(Color(red: 0.061, green: 0.51, blue: 0.997))
                                .frame(width: 310, alignment: .leading)
                            
                        }
                    }
                    Button(action: {
                        Alerta_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.28, green: 0.63, blue: 0.28))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    Button(action: {
                        Alerta_No_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("No Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.78, green: 0.04, blue: 0.05))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_No_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como No Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    no_cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    NavigationLink(isActive: $cobrado, destination: { Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                    NavigationLink(isActive: $no_cobrado, destination: { No_Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                Spacer()
                }
                
                else if (info_donador.TelMovil != "" && info_donador.TelCasa == "" && info_donador.TelOficina != ""){
                    Header()
                    
                    Text("\(info_donador.NombreDonante) \(info_donador.ApellidoPaterno)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom,3)
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 120)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            Text("Celular")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelMovil)", destination: URL(string: "tel:\(info_donador.TelMovil)")!)
                                .frame(width: 310, alignment: .leading)
                            
                            Divider()
                                .frame(width: 310)
                            
                            Text("Tel Referente")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelOficina)", destination: URL(string: "tel:\(info_donador.TelOficina)")!)
                                .frame(width: 310, alignment: .leading)
                        }
                    }
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 198)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Dirreción")
                                    
                                    Text("\(info_donador.Colonia.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Direccion.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Municipio.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.CP.capitalized)")
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Mapa()
                            }
                            .frame(width: 310)
                            
                            Divider()
                                .frame(width: 320)
                            
                            Text("Referencia")
                                .frame(width: 310, alignment: .leading)
                            
                            Text("\(info_donador.Referencias.capitalized)")
                                .foregroundColor(.blue)
                                .frame(width: 310, alignment: .leading)
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
                            
                            Text("$\(info_donador.Importe, specifier: "%.2f")")
                                .font(
                                    Font.custom("SF Pro", size: 26)
                                    .weight(.medium)
                                    )
                                .foregroundColor(Color(red: 0.061, green: 0.51, blue: 0.997))
                                .frame(width: 310, alignment: .leading)
                            
                        }
                    }
                    
                    Button(action: {
                        Alerta_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.28, green: 0.63, blue: 0.28))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    Button(action: {
                        Alerta_No_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("No Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.78, green: 0.04, blue: 0.05))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_No_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como No Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    no_cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    NavigationLink(isActive: $cobrado, destination: { Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                    NavigationLink(isActive: $no_cobrado, destination: { No_Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                Spacer()
                }
                
                else if (info_donador.TelMovil != "" && info_donador.TelCasa == "" && info_donador.TelOficina == ""){
                    Header()
                    
                    Text("\(info_donador.NombreDonante) \(info_donador.ApellidoPaterno)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom,3)
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 70)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            Text("Celular")
                                .frame(width: 310, alignment: .leading)
                            
                            Link("\(info_donador.TelMovil)", destination: URL(string: "tel:\(info_donador.TelMovil)")!)
                                .frame(width: 310, alignment: .leading)
                            
                        }
                    }
                    
                    ZStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 340, height: 220)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
                            .cornerRadius(10)
                        
                        VStack{
                            HStack{
                                VStack(alignment: .leading){
                                    Text("Dirreción")
                                    
                                    Text("\(info_donador.Colonia.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Direccion.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.Municipio.capitalized)")
                                        .foregroundColor(.blue)
                                    
                                    Text("\(info_donador.CP.capitalized)")
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Mapa()
                            }
                            .frame(width: 310)
                            
                            Divider()
                                .frame(width: 320)
                            
                            Text("Referencia")
                                .frame(width: 310, alignment: .leading)
                            
                            Text("\(info_donador.Referencias.capitalized)")
                                .foregroundColor(.blue)
                                .frame(width: 310, alignment: .leading)
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
                            
                            Text("$\(info_donador.Importe, specifier: "%.2f")")
                                .font(
                                    Font.custom("SF Pro", size: 26)
                                    .weight(.medium)
                                    )
                                .foregroundColor(Color(red: 0.061, green: 0.51, blue: 0.997))
                                .frame(width: 310, alignment: .leading)
                            
                        }
                    }
                    
                    Button(action: {
                        Alerta_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.28, green: 0.63, blue: 0.28))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    Button(action: {
                        Alerta_No_Recibido = true
                    }) {
                        HStack {
                            Spacer()
                            Image("No Entregado")
                            Spacer()
                        }
                    }
                    .frame(width: 340, height: 56)
                    .background(Color(red: 0.78, green: 0.04, blue: 0.05))
                    .cornerRadius(10)
                    .alert(isPresented: $Alerta_No_Recibido) {
                        Alert(
                            title: Text("¿Seguro que desea marcar como No Recibido?"),
                            primaryButton: .default(
                                Text("Continuar"),
                                action: {
                                    no_cobrado.toggle()
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("Cancelar"),
                                action: {
                                }
                            )
                        )
                    }
                    
                    NavigationLink(isActive: $cobrado, destination: { Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                    NavigationLink(isActive: $no_cobrado, destination: { No_Cobrado_View(donador: donador) }, label: { EmptyView()})
                    
                Spacer()
                }
                
            }
        }
    }
}
struct Donante_View_Previews: PreviewProvider {
    static var previews: some View {
        Donante_View(donador: 1)
    }
}
