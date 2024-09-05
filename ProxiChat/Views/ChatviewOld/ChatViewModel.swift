//import SwiftUI
//import Combine
//
//class ChatViewModel: ObservableObject {
//    @Published var messages: [MyMessage] = []
//    @Published var newMessageText: String = ""
//    @Published var replyToMessage: MyMessage?
//    @Published var conversation: MyConversation?
//    
//    private var cancellables = Set<AnyCancellable>()
//    private var sessionManager: SessionManager
//    var user: User
//    
//    init(conversation: MyConversation?, user: User, sessionManager: SessionManager) {
//        self.conversation = conversation
//        self.user = user
//        self.sessionManager = sessionManager
//        
//        // Load initial messages if there is an existing conversation
//        if let conversation = conversation {
//            loadMessages(for: conversation)
//        }
//    }
//    
//    private func loadMessages(for conversation: MyConversation) {
//        // Load messages from API or database
//        // This is a mock implementation
//        self.messages = [
//            MyMessage(id: "1", content: MyMessageContent(text: "Hello!", imageId: nil), senderId: "1", sentAt: Date(), status: .sent, read: false),
//            MyMessage(id: "2", content: MyMessageContent(text: "Hi, how are you?", imageId: nil), senderId: "1", sentAt: Date(), status: .sent, read: false),
//            MyMessage(id: "3", content: MyMessageContent(text: "I'm good, how are you?", imageId: "2", senderId: "1", sentAt: Date(), status: .sent, read: false),
//        ]
//    }
//    
//    func sendMessage() {
//        guard let userId = sessionManager.currentUser?.id else { return }
//        
//        let messageContent = MyMessageContent(text: newMessageText, imageId: nil)
//        let newMessage = MyMessage(
//            id: UUID().uuidString,
//            content: messageContent,
//            senderId: userId,
//            sentAt: Date(),
//            status: .sent,
//            read: false
//        )
//        
//        messages.append(newMessage)
//        newMessageText = ""
//        
//        if conversation == nil {
//            // Create a new conversation and conversation user if this is a new conversation
//            let newConversation = MyConversation(id: UUID().uuidString, title: "Chat with \(user.fullname)", updatedAt: Date(), messages: [newMessage])
//            // Mock API call to create conversation and conversation user
//            self.conversation = newConversation
//            print("Created new conversation: \(newConversation)")
//        } else {
//            // Update existing conversation with new message
//            print("Added message to existing conversation: \(conversation!.id)")
//        }
//    }
//}
