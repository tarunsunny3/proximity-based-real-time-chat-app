//
//  SignupView.swift
//  ChatApp
//
//  Created by  on 13/05/24.
//

import SwiftUI
import Amplify

struct SignupView: View {
    @State private var fullname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSigningUp = false
    @EnvironmentObject var sessionManager: SessionManager
    
    
    var body: some View {
            VStack {
                
                Image("proxichat")
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 32)
                // Form fields
                
                VStack(spacing: 24){
                    InputFieldView(text: $fullname, title: "Full Name", placeHolder: "Enter your fullname")
                    
                    
                    InputFieldView(text: $email, title: "Email Address", placeHolder: "name@example.com")
                    
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    InputFieldView(text: $password,
                                   title: "Password",
                                   placeHolder: "Enter your Password",
                                   isSecureField: true)
                    .textContentType(.none)
                    
                    InputFieldView(text: $confirmPassword,
                                   title: "Confirm Password",
                                   placeHolder: "Comfirm your Password",
                                   isSecureField: true)
                    .textContentType(.none)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                
                //Sign up button
                Button{
                    
                    Task {
                        await sessionManager.signUp(email: email, password:password, fullName: fullname)
                    }
                }label: {
                    HStack{
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height : 42)
                    
                }
                .background(Color(.systemBlue))
                .cornerRadius(12)
                .padding(.top, 20)
                
                Spacer()
                
                // Sign up Button
                
                Button {
                    sessionManager.showSignIn()
                }label: {
                    HStack(spacing: 3){
                        Text("Already have an account?")
                        Text("Sign In")
                            .fontWeight(.bold)
                    }
                }
                
            }
        }
}

#Preview {
    SignupView()
}
