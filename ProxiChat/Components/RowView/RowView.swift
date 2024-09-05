//
//  RowView.swift
//  ChatApp
//
//  Created by Tarun Chinthakindi on 13/05/24.
//

import SwiftUI

struct RowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    var body: some View {
        HStack(spacing: 12){
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct RowView_Previews: PreviewProvider
{
    static var previews: some View {
        RowView(imageName: "gear", title: "Hey", tintColor: Color(.systemGray))
    }
}
