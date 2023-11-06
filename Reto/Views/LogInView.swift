import SwiftUI

struct LogInView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var recolector: Recolector?
    @State private var isAuthenticate: Bool = false
    @State var isPresented: Bool = false
    @State private var opacity = 0.5

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .padding(.bottom, 20)

                TextField("Matrícula o Usuario", text: $username)
                    .frame(height: 45)
                    .foregroundColor(.white)
                    .background(Color("PantoneAC"))
                    .border(Color("PantoneAC"), width: 2)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)

                SecureField("Contraseña", text: $password) // Usar SecureField para contraseñas
                    .frame(height: 45)
                    .foregroundColor(.white)
                    .background(Color("PantoneAC"))
                    .border(Color("PantoneAC"), width: 2)
                    .cornerRadius(5)
                    .padding(.horizontal, 30)

                HStack {
                    Spacer()
                    Button("¿Olvidaste tu contraseña?") {

                    }
                    .font(.footnote)
                    .foregroundColor(Color("PantoneAO"))
                    .padding(.horizontal, 30)
                    .padding(.top, 5)
                    .padding(.bottom, 15)
                }

                Button("Verificar Credenciales", action: signIn)
                    .alert(isPresented: $isPresented, content: {
                        Alert(title: Text("Credenciales Incorrectas"),
                              message: Text("Inicio de sesión fallido. Verifica tus credenciales."),
                              primaryButton: .default(Text("Aceptar")),
                              secondaryButton: .destructive(Text("Cancelar"))
                        )
                    })

                if isAuthenticate {
                    NavigationLink("Iniciar Sesión", destination: ContentView()) // Corrección de la navegación
                        .frame(width: 320, height: 45)
                        .foregroundColor(.white)
                        .background(Color("PantoneAO"))
                        .border(Color("PantoneAO"), width: 2)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                        .frame(width: 320, height: 45)
                }

                Spacer()
                Spacer()
            }
        }
    }

    func signIn() {
        let user = User(username: username, password: password)
        recolector = VerificarUsuario(usr: user)

        if recolector?.idRecolector != 0 {
            isAuthenticate = true
        } else {
            isPresented = true
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
