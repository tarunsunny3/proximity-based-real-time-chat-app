//import SwiftUI
//import Combine
//import Amplify
//
//class ConversationsViewModel: ObservableObject {
//    @Published var conversations: [Conversation] = []
//    @Published var selectedConversation: Conversation?
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        fetchConversations()
//        subscribeToNewConversations()
//    }
//
//    func fetchConversations() {
//        Amplify.API.query(request: .list(Conversation.self))
//            .resultPublisher
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print("Failed to fetch conversations: \(error)")
//                }
//            } receiveValue: { result in
//                switch result {
//                case .success(let conversations):
//                    self.conversations = conversations
//                case .failure(let error):
//                    print("Failed to fetch conversations: \(error)")
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    private func subscribeToNewConversations() {
//        let request = GraphQLRequest<Conversation>(document: Subscriptions.onCreateConversation, responseType: Conversation.self)
//
//        Amplify.API.subscribe(request: request)
//            .resultPublisher
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print("Failed to subscribe to new conversations: \(error)")
//                }
//            } receiveValue: { result in
//                switch result {
//                case .success(let conversation):
//                    if !self.conversations.contains(where: { $0.id == conversation.id }) {
//                        self.conversations.append(conversation)
//                    }
//                case .failure(let error):
//                    print("Failed to receive new conversation: \(error)")
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    func createNewConversation(with user: User) {
//        let newConversation = Conversation(id: UUID().uuidString, title: "Chat with \(user.fullname)", participants: [], messages: [], createdAt: Temporal.DateTime.now(), updatedAt: Temporal.DateTime.now())
//        let request = GraphQLRequest<Conversation>(document: Mutations.createConversation, variables: ["input": newConversation.toDict()], responseType: Conversation.self)
//
//        Amplify.API.mutate(request: request)
//            .resultPublisher
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print("Failed to create new conversation: \(error)")
//                }
//            } receiveValue: { result in
//                switch result {
//                case .success(let conversation):
//                    self.selectedConversation = conversation
//                    self.createConversationUser(conversation: conversation, user: user)
//                case .failure(let error):
//                    print("Failed to create new conversation: \(error)")
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    private func createConversationUser(conversation: Conversation, user: User) {
//        let conversationUser = ConversationUser(id: UUID().uuidString, userId: user.id, conversationId: conversation.id, joinedAt: Temporal.DateTime.now(), lastReadMessageId: nil)
//        let request = GraphQLRequest<ConversationUser>(document: Mutations.createConversationUser, variables: ["input": conversationUser.toDict()], responseType: ConversationUser.self)
//
//        Amplify.API.mutate(request: request)
//            .resultPublisher
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print("Failed to create conversation user: \(error)")
//                }
//            } receiveValue: { result in
//                switch result {
//                case .success(let conversationUser):
//                    print("Conversation user created: \(conversationUser)")
//                case .failure(let error):
//                    print("Failed to create conversation user: \(error)")
//                }
//            }
//            .store(in: &cancellables)
//    }
//}
//
//extension Conversation {
//    func toDict() -> [String: Any] {
//        return [
//            "id": id,
//            "title": title,
//            "createdAt": createdAt?.iso8601String,
//            "updatedAt": updatedAt!.iso8601String
//        ]
//    }
//}
//
//extension ConversationUser {
//    func toDict() -> [String: Any] {
//        return [
//            "id": id,
//            "userId": userId,
//            "conversationId": conversationId,
//            "joinedAt": joinedAt.iso8601String,
//            "lastReadMessageId": lastReadMessageId as Any
//        ]
//    }
//}
