//
//  ProfileView.swift
//  ChatApp
//
//  Created by Rama Krishna on 13/05/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        List{
            Section{
                HStack(spacing: 10){
                    Text(sessionManager.currentUser?.fullname.prefix(2) ?? "")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.white))
                        .frame(width: 72, height: 72)
                        .background(Color(.systemGray2))
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    VStack(alignment: .leading, spacing: 5){
                        Text(sessionManager.currentUser?.fullname ?? "User")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        Text(sessionManager.currentUser?.email ?? "user@gmail.com")
                            .font(.footnote)
                            .accentColor(.gray)
                    }
                }
            }
           
            
            Section("Account"){
                Toggle("Discover Mode", isOn: $sessionManager.locationManager.isDiscoverModeOn)
                
                Button{
                print("Sign out")
                    Task{
                        await sessionManager.signOutLocally()
                    }
                }label: {
                    RowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .red)
                }
               
            }
        }
    }
}

#Preview {
    ProfileView()
}
