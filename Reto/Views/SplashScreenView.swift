//
//  SplashScreenView.swift
//  Login
//
//  Created by Manuel Ortiz on 19/10/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5

    var body: some View {
        if isActive {
            LogInView()
        }
        else{
            VStack{
                HStack{Spacer()}
                Spacer()
                VStack{
                    Image("LogoBlanco")
                        .font(.system(size: 80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }

                }
                Spacer()
            }
            .background(Color("PantoneAO"))
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
        }
        }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

