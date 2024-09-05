//
//  ConversationsView.swift
//  ProxiChat
//
//  Created by Tarun Chinthakindi on 26/05/24.
//
import SwiftUI

struct ConversationsView: View {
//    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var viewModel: ConversationsViewModel
    private var sessionManager: SessionManager
    init(session: SessionManager) {
        // Placeholder for initialization with sessionManager
        self.sessionManager = session
        _viewModel = StateObject(wrappedValue: ConversationsViewModel(sessionManager: session))
    }

    var body: some View {
        NavigationView {
           
            if sessionManager.currentUserId != nil {
                List(viewModel.userConversations) { userConversation in
                    
                    NavigationLink(destination: ChatView(sessionManager: sessionManager, recipientUser: nil, existingUserConversation: userConversation)) {
                        ConversationRow(userConversation: userConversation)
                    }
                    .contextMenu {
                            Button(action: {
                                // Call your update method here
                                Task{
                                    print("Called subscribe")
                                    await viewModel.subscribeToNewUser(userId: sessionManager.currentUser?.id)
                                }
                                
                            }) {
                                Label("Subscribe", systemImage: "arrow.up.circle")
                            }
                        }
                }
                .navigationTitle("Conversations")
                .onAppear {
                    Task {
                        print("Conversations view current user id is \(sessionManager.currentUser?.id ?? "not found")")
//                        print("Subscription called")
//                        viewModel.subscribeToNewUserConversations(userId: sessionManager.currentUser?.id)
                        await viewModel.fetchUserConversations()
                    }
                }
//                .onDisappear{
//                    viewModel.cancelUserConversationsUpdate()
//                }
            }
        }
    }
}

struct ConversationRow: View {
    let userConversation: UserConversations

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(userConversation.title)
                    .font(.headline)
                Text("Last message: \(userConversation.conversation.lastMessage?.content.text?.prefix(10) ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                if userConversation.unreadMessagesCount > 0{
                    Text(String(userConversation.unreadMessagesCount))
                       .font(.subheadline)
                       .foregroundColor(.white) // Text color inside the circle
                       .padding(8) // Adjust padding to make the circle larger or smaller
                       .background(Color.green)
                       .clipShape(Circle())
                        
                }
                
            }
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    ConversationsView(session: SessionManager())
        .environmentObject(SessionManager())
}
