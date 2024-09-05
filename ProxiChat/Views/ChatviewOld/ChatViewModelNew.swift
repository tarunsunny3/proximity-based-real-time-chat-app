////
////  ChatViewModel.swift
////  ChatApp
////
////  Created by Tarun Chinthakindi on 23/05/24.
////
//
//import SwiftUI
//import Amplify
//
//class ChatViewModel: ObservableObject {
//    @Published var messages: [Message] = []
//    @Published var conversation: MyConversation?
//    @Published var replyToMessage: Message?
//    private var nextToken: String?
//    
//    let sessionManager: SessionManager
//    let user: User
//    
//    init(user: User, conversation: MyConversation?, sessionManager: SessionManager) {
//        self.user = user
//        self.conversation = conversation
//        self.sessionManager = sessionManager
//        if let conversation = conversation {
//            fetchMessages(conversationId: conversation.id)
//            subscribeToMessages(conversationId: conversation.id)
//        }
//    }
//    
//    func fetchMessages(conversationId: String, limit: Int = 20) {
//        let request = GraphQLRequest<QueryResponse<Message>>(
//            document: Queries.fetchMessages,
//            variables: ["conversationId": conversationId, "limit": limit, "nextToken": nextToken]
//        )
//        
//        _ = Amplify.API.query(request: request) { result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self.messages.append(contentsOf: response.items)
//                    self.nextToken = response.nextToken
//                }
//            case .failure(let error):
//                print("Failed to fetch messages: \(error)")
//            }
//        }
//    }
//    
//    func sendMessage(content: String) {
//        guard let userId = sessionManager.currentUser?.id else { return }
//        
//        let newMessage = Message(
//            id: UUID().uuidString,
//            content: content,
//            senderId: userId,
//            conversationId: conversation?.id,
//            sentAt: Date()
//        )
//        
//        if let conversation = conversation {
//            createMessage(message: newMessage, conversationId: conversation.id)
//        } else {
//            createConversationWithMessage(message: newMessage)
//        }
//    }
//    
//    private func createMessage(message: Message, conversationId: String) {
//        let request = GraphQLRequest<MutationResponse<Message>>(
//            document: Mutations.createMessage,
//            variables: ["message": message]
//        )
//        
//        _ = Amplify.API.mutate(request: request) { result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self.messages.append(response)
//                }
//            case .failure(let error):
//                print("Failed to send message: \(error)")
//            }
//        }
//    }
//    
//    private func createConversationWithMessage(message: Message) {
//        let newConversation = MyConversation(
//            id: UUID().uuidString,
//            title: "Chat with \(user.fullname)",
//            participants: [],
//            updatedAt: Date()
//        )
//        
//        let request = GraphQLRequest<MutationResponse<MyConversation>>(
//            document: Mutations.createConversation,
//            variables: ["conversation": newConversation]
//        )
//        
//        _ = Amplify.API.mutate(request: request) { result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self.conversation = response
//                    self.createConversationUsers(conversationId: response.id)
//                    self.createMessage(message: message, conversationId: response.id)
//                    self.subscribeToMessages(conversationId: response.id)
//                }
//            case .failure(let error):
//                print("Failed to create conversation: \(error)")
//            }
//        }
//    }
//    
//    private func createConversationUsers(conversationId: String) {
//        guard let currentUserId = sessionManager.currentUser?.id else { return }
//        
//        let participants = [
//            ConversationUser(id: UUID().uuidString, userId: currentUserId, conversationId: conversationId, joinedAt: Date()),
//            ConversationUser(id: UUID().uuidString, userId: user.id, conversationId: conversationId, joinedAt: Date())
//        ]
//        
//        participants.forEach { participant in
//            let request = GraphQLRequest<MutationResponse<ConversationUser>>(
//                document: Mutations.createConversationUser,
//                variables: ["conversationUser": participant]
//            )
//            
//            _ = Amplify.API.mutate(request: request) { result in
//                switch result {
//                case .success(let response):
//                    print("Created conversation user: \(response)")
//                case .failure(let error):
//                    print("Failed to create conversation user: \(error)")
//                }
//            }
//        }
//    }
//    
//    private func subscribeToMessages(conversationId: String) {
//        let request = GraphQLRequest<SubscriptionResponse<Message>>(
//            document: Subscriptions.onCreateMessage,
//            variables: ["conversationId": conversationId]
//        )
//        
//        _ = Amplify.API.subscribe(request: request) { event in
//            switch event {
//            case .data(let result):
//                switch result {
//                case .success(let message):
//                    DispatchQueue.main.async {
//                        self.messages.append(message)
//                    }
//                case .failure(let error):
//                    print("Subscription error: \(error)")
//                }
//            default:
//                break
//            }
//        }
//    }
//}
