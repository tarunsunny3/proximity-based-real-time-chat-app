////
////  ConversationsView.swift
////  ChatApp
////
////  Created by Tarun Chinthakindi on 23/05/24.
////
//
//import SwiftUI
//import Foundation
//import Amplify
//
//struct ConversationsView: View {
//    
//
//    @StateObject private var viewModel = ConversationsViewModel()
//    @EnvironmentObject var sessionManager: SessionManager
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.conversations){ conversation in
//                NavigationLink(destination: ChatView(viewModel: ChatViewModel(user: sessionManager.currentUser!, conversationId: conversation.id))) {
//                    ConversationRow(conversation: conversation)
//                }
//            }
//            .navigationBarTitle("Conversations")
//            .navigationBarItems(trailing: Button(action: {
//                // Action to create a new conversation with a nearby user
//                // Assuming you have a way to select a user to chat with
//                // Replace with your actual user selection logic
//                let nearbyUser = User(id: UUID().uuidString, fullname: "New User", email: "newuser@example.com", status: .online)
//                viewModel.createNewConversation(with: nearbyUser)
//            }) {
//                Image(systemName: "plus")
//            })
//            .onAppear {
//                viewModel.fetchConversations()
//            }
//            .sheet(item: $viewModel.selectedConversation) { conversation in
//                NavigationView {
//                    ChatView(viewModel: ChatViewModel(user: sessionManager.currentUser!, conversationId: conversation.id))
//                }
//            }
//        }
//    }
//}
//
//struct ConversationRow: View {
//    let conversation: Conversation
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(conversation.title ?? "Chat")
//                    .font(.headline)
//                Text("Last message preview") // Replace with actual last message preview
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            Spacer()
//            if let updatedAt = conversation.updatedAt {
//                            Text(updatedAt.date, style: .date)
//                                .font(.caption)
//                                .foregroundColor(.gray)
//            } else {
//                Text("Unknown date")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//              
//        }
//    }
//}
//extension Temporal.DateTime {
//    var date: Date {
//        return foundationDate
//    }
//}
//
//struct ConversationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationsView()
//            .environmentObject(SessionManager())
//    }
//}
