//
//  SignInView.swift
//  RainyDayLover
//
//  Created by Oliver Lance on 11/24/22.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    
    var body: some View {
        VStack(spacing: 15) {
            LogoView()
                .padding(.bottom)
            Text("rainy day lover")
                .padding(.bottom, 50)
                .font(.system(size: 45, weight: .light, design: .rounded))
            SignInCredentialFields(email: $email, password: $password)
            Button(action: {
                signInUser(userEmail: email, userPassword: password)
            }) {
                Text("Log In")
                    .bold()
                    .frame(width: 360, height: 50)
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
            .disabled(!signInProcessing && !email.isEmpty && !password.isEmpty ? false : true)
            Group {
                if signInProcessing {
                    ProgressView()
                }
                if !signInErrorMessage.isEmpty {
                    Text("Failed signing in.")
                        .foregroundColor(.red)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        signInProcessing = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                signInProcessing = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            signInProcessing = false
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        TextField("Email", text: $email)
            .padding()
            .background(Color("LightText"))
            .cornerRadius(10)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)

        SecureField("Password", text: $password)
            .padding()
            .background(Color("LightText"))
            .cornerRadius(10)
            .padding(.bottom, 30)
            .disableAutocorrection(true)
    }
}

struct LogoView: View {
    var body: some View {
        Image("Logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 150)
            .padding(.top, 70)
    }
}
