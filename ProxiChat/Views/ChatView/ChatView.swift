//
//  ChatView.swift
//  ProxiChat
//
//  Created by Tarun Chinthakindi on 27/05/24.
//
import SwiftUI
import Amplify

struct ChatView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel: ChatViewModel
    @State private var messageText: String = ""
    let recipientUser: User? // The ID of the recipient user
    let existingUserConversation: UserConversations? // The ID of an existing conversation, if any

    init(sessionManager: SessionManager, recipientUser: User?, existingUserConversation: UserConversations?) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(sessionManager: sessionManager, recipientUser: recipientUser, existingUserConversation: existingUserConversation))
        self.recipientUser = recipientUser
        self.existingUserConversation = existingUserConversation
    }

    var body: some View {
        VStack {
                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.messages) { message in
                                    HStack {
                                        if message.sender?.id == sessionManager.currentUserId {
                                            Spacer()
                                            Text(message.content.text ?? "Error")
                                                .padding()
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        } else {
                                            Text(message.content.text ?? "Error")
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                            Spacer()
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .onChange(of: viewModel.messages.count) { _ in
                                if let lastMessage = viewModel.messages.last {
                                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                        .onAppear {
                            Task {
                                if let conversation = existingUserConversation?.conversation{
                                    await viewModel.fetchMessages(conversationId: conversation.id)
                                    if let lastMessage = viewModel.messages.last {
                                        scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                    await viewModel.handleViewAppear()
                                    
                                }
                            }
                        }
                        .onDisappear(){
                            Task{
                                await viewModel.handleViewDisappear()
                            }
                        }
                    }

                    HStack {
                        TextField("Enter message", text: $messageText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(minHeight: CGFloat(30))
                        Button(action: {
                            Task {
                               
                                await viewModel.sendMessage(content: messageText, to: recipientUser?.id)
                                messageText = ""
                            }
                        }) {
                            Text("Send")
                        }
                        .padding()
                    }
                    .padding()
                }
                .navigationTitle("Chat")
    }
    
}

#Preview {
    ChatView(sessionManager: SessionManager(), recipientUser: nil, existingUserConversation: nil)
        .environmentObject(SessionManager())
}
