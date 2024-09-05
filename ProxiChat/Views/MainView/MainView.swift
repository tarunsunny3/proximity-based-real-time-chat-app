//
//  MainView.swift
//  ChatApp
//
//  Created by Tarun Chinthakindi on 17/05/24.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var sessionManager: SessionManager
    var body: some View {
        TabView {
//            NearByUsersView()
//                .tabItem {
//                    Label("Similar People", systemImage: "person.3.fill")
//                }
            
            ConversationsView(session: sessionManager)
                .tabItem {
                    Label("Conversations", systemImage: "bubble.left.and.bubble.right.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}
