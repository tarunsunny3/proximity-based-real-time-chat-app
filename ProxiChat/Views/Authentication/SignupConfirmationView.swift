//
//  SignupConfirmation.swift
//  ChatApp
//
//  Created by Tarun Chinthakindi on 14/05/24.
//

import SwiftUI

struct SignupConfirmationView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        VStack{
            Text("Username: \(username)")
            InputFieldView(text: $confirmationCode, title: "Confirmation Code", placeHolder: "Enter confirmation code")
            
            Button{
                
                Task {
                    await sessionManager.confirmSignUp( username: username,
                        confirmationCode: confirmationCode)
                }
            }label: {
                HStack{
                    Text("Confirm Code")
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
            
        }
    }
}

struct SignupConfirmationView_Previews: PreviewProvider
{
    static var previews: some View {
        SignupConfirmationView(username: "Tarun")
    }
}
