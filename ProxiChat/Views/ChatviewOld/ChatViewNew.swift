////
////  ChatView.swift
////  ChatApp
////
////  Created by Tarun Chinthakindi on 23/05/24.
////
//
//import SwiftUI
//
//struct ChatView: View {
//    @ObservedObject var viewModel: ChatViewModel
//    
//    var body: some View {
//        VStack {
//            List(viewModel.messages) { message in
//                MessageView(
//                    message: message,
//                    isCurrentUser: message.senderId == viewModel.sessionManager.currentUser?.id,
//                    onReply: { replyMessage in
//                        viewModel.replyToMessage = replyMessage
//                    }
//                )
//            }
//            
//            if let replyToMessage = viewModel.replyToMessage {
//                HStack {
//                    Text("Replying to: \(replyToMessage.content)")
//                        .lineLimit(1)
//                        .padding(8)
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                    Button(action: {
//                        viewModel.replyToMessage = nil
//                    }) {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding(.horizontal)
//            }
//            
//            HStack {
//                TextField("Message", text: $viewModel.newMessageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: {
//                    viewModel.sendMessage(content: viewModel.newMessageText)
//                }) {
//                    Text("Send")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                }
//                .padding(.trailing)
//            }
//        }
//        .onAppear {
//            if let conversationId = viewModel.conversation?.id {
//                viewModel.fetchMessages(conversationId: conversationId)
//            }
//        }
//    }
//}
