////
////  ConversationsView.swift
////  ChatApp
////
////  Created by Rama Krishna on 13/05/24.
////
//
//import Amplify
//import SwiftUI
//import Foundation
//extension Date {
//    var toDateTime: Temporal.DateTime {
//        return Temporal.DateTime(self)
//    }
//}
//struct ConversationsView: View {
//   
//    // Dummy data for conversations
//    @State private var conversations: [MyConversation] = [
//        MyConversation(id: "1", title: "Chat with Alice", updatedAt: Date(), messages: []),
//        MyConversation(id: "2", title: "Chat with Bob", updatedAt: Date(), messages: []),
//    ]
//    @EnvironmentObject var sessionManager: SessionManager
//    @State var selectedConversation: MyConversation?
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(conversations) { conversation in
//                    NavigationLink(destination: ChatView(conversation: $selectedConversation)) {
//                        ConversationRow(conversation: conversation)
//                    }
//                    .onTapGesture {
//                        selectedConversation = conversation
//                    }
//                    .swipeActions(edge: .trailing) {
//                        Button(role: .destructive) {
//                            // Block user action
//                            blockUser(conversationId: conversation.id)
//                        } label: {
//                            Label("Block", systemImage: "hand.raised.fill")
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Conversations")
//        }
//    }
//    
//    private func blockUser(conversationId: String) {
//        // Handle the block user action
//        print("Blocked user in conversation \(conversationId)")
//    }
//}
//
//struct ConversationRow: View {
//    let conversation: MyConversation
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(conversation.title)
//                    .font(.headline)
//                Text("Last message: \(conversation.messages.last?.content.text ?? "")")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            Spacer()
//        }
//        .padding()
//    }
//}
//
//struct ConversationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConversationsView()
//            .environmentObject(SessionManager())
//    }
//}
//struct MyMessage: Identifiable {
//    let id: String
//    let content: MyMessageContent
//    let senderId: String
//    let sentAt: Date
//    let status: MyMessageStatus
//    let read: Bool
//}
//// Dummy models
//struct MyConversation: Identifiable {
//    let id: String
//    let title: String
//    let updatedAt: Date
//    let messages: [MyMessage]
//}
//
//
//
