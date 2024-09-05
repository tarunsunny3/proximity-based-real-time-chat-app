//
//  LoginView.swift
//  ChatApp
//
//  Created by Rama Krishna on 13/05/24.
//

import SwiftUI
import Amplify

func signIn(username: String, password: String) async {
    do {
        let signInResult = try await Amplify.Auth.signIn(
            username: username,
            password: password
            )
        if signInResult.isSignedIn {
            print("Sign in succeeded")
        }
    } catch let error as AuthError {
        print("Sign in failed \(error)")
    } catch {
        print("Unexpected error: \(error)")
    }
}
struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @State private var email: String = "tarunsunny2662@gmail.com"
    @State private var password: String = "Tarun@0508"

    var body: some View {
        NavigationStack{
            VStack {
                
                Image("proxichat")
                    .resizable()
                    .scaledToFit()
                    .padding(.vertical, 32)
                // Form fields
                
                VStack(spacing: 24){
                    InputFieldView(text: $email, title: "Email Address", placeHolder: "name@example.com")
                
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    InputFieldView(text: $password, title: "Password", placeHolder: "Enter your Password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
               
                
                //Sign in button
                Button{
                    
                    Task {
                        if(( try? await Amplify.Auth.getCurrentUser()) != nil){
                            await sessionManager.signOutLocally()
                        }else{
                            await sessionManager.signIn(username: email, password: password)
                        }
                        
                    }
                }label: {
                    HStack{
                        Text("SIGN IN")
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
                    sessionManager.showSignUp()               
                }label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                }
                
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
