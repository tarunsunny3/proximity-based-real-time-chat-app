//import SwiftUI
//
//
//
//struct ChatView: View {
//    @ObservedObject var viewModel: ChatViewModel
////    @EnvironmentObject var sessionManager: SessionManager
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
//                    Text("Replying to: \(replyToMessage.content.text)")
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
//                Button(action: viewModel.sendMessage) {
//                    Text("Send")
//                }
//                .padding()
//                .disabled(viewModel.newMessageText.isEmpty)
//            }
//        }
//        .navigationBarTitle("Chat", displayMode: .inline)
//    }
//}
//
//struct MessageView: View {
//    let message: MyMessage
//    let isCurrentUser: Bool
//    let onReply: (MyMessage) -> Void
//    
//    var body: some View {
//        HStack {
//            if isCurrentUser {
//                Spacer()
//                VStack(alignment: .trailing) {
//                    Text(message.content.text)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                    if let imageId = message.content.imageId {
//                        Image(systemName: "photo") // Placeholder for actual image loading
//                            .padding()
//                            .background(Color.blue)
//                            .cornerRadius(8)
//                            .foregroundColor(.white)
//                    }
//                }
//                .swipeActions(edge: .leading) {
//                    Button {
//                        onReply(message)
//                    } label: {
//                        Label("Reply", systemImage: "arrowshape.turn.up.left")
//                    }
//                    .tint(.green)
//                }
//            } else {
//                VStack(alignment: .leading) {
//                    Text(message.content.text)
//                        .padding()
//                        .background(Color.gray.opacity(0.2))
//                        .cornerRadius(8)
//                    if let imageId = message.content.imageId {
//                        Image(systemName: "photo") // Placeholder for actual image loading
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                    }
//                }
//                .swipeActions(edge: .trailing) {
//                    Button {
//                        onReply(message)
//                    } label: {
//                        Label("Reply", systemImage: "arrowshape.turn.up.left")
//                    }
//                    .tint(.green)
//                }
//                Spacer()
//            }
//        }
//        .padding(isCurrentUser ? .leading : .trailing, 40)
//        .padding(.vertical, 5)
//    }
//}
//
//
//// Dummy models
//
//
//struct MyMessageContent {
//    let text: String
//    let imageId: String?
//}
//
//enum MyMessageStatus {
//    case sent
//    case delivered
//    case read
//}
//
////struct MyConversation: Identifiable {
////    let id: String
////    let title: String
////    let updatedAt: Date
////    let messages: [MyMessage]
////}
//
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        let dummyUser = User(id: "1", fullname: "Dummy User", email: "dummy@example.com", status: .online)
//        let dummyConversation = MyConversation(id: "1", title: "Dummy Conversation", updatedAt: Date(), messages: [])
//        
//        return ChatView(user: dummyUser, conversation: dummyConversation)
//            .environmentObject(SessionManager()) // Assuming you need a SessionManager environment object
//    }
//}
