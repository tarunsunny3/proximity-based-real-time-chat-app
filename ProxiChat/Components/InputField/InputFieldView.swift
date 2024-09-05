//
//  InputFieldView.swift
//  ChatApp
//
//

import SwiftUI

struct InputFieldView: View {
    @Binding var text: String
    var title: String
    var placeHolder: String
    var isSecureField = false
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            
            if(isSecureField){
                SecureField(placeHolder, text: $text)
                    .font(.system(size: 14))
                    .padding(10)
                    .overlay(
                        Rectangle()
                            .stroke(Color(.black))
                    )
            }else{
                TextField(placeHolder, text: $text)
                    .font(.system(size: 14))
                    .padding(10)
                    .overlay(
                        Rectangle()
                            .stroke(Color(.black))
                    )
            }
        }
    }
}

struct InputFieldView_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldView(text: .constant(""), title: "Email Address", placeHolder: "abc@gmail.com")
    }
}
