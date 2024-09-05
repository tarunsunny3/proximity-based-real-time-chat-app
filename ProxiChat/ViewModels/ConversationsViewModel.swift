import SwiftUI
import Amplify
import Combine

class ConversationsViewModel: ObservableObject {
    private var sessionManager: SessionManager?
    @Published var userConversations: [UserConversations] = []
    private var subscriptions = Set<AnyCancellable>()
    private var userConversationsUpdateSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<UserConversations>>?
    private var userUpdateSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<User>>?
    private var newMessageForRecipientSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Message>>?
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        sessionManager.$currentUserId
           .sink { [weak self] userId in
               if let userId = userId {
                   print("User id is found, calling subscriptions updates on user conversations\(userId)")
                   self!.subscribeToNewUserConversations(userId: userId)
//                   self!.subscribeToNewMessagesForRecipient(recipientId: userId)
               } else {
                   print("User id became nil, calling cancel method")
                   self?.cancelUserConversationsUpdate()
//                   self?.cancelMessagesForRecipientsCreate()
               }
           }
           .store(in: &subscriptions)
    }

    func fetchUserConversations() async {
        guard let currentUserId =  sessionManager?.currentUser?.id else {
            print("No current user ID found")
            return
        }
        print("Fetching conversations for \(currentUserId)")
        let operationName = "userConversationsByUpdatedAt"

        let listUserConversationsQuery = """
        query UserConversationsByUpdatedAt($userId: ID!) {
          \(operationName)(type: "UserConversations", sortDirection: DESC, filter: {userId: {eq: $userId}}) {
            items {
              id
              title
              updatedAt
              conversation {
                id
                lastMessage {
                  id
                  content {
                    text
                  }
                    updatedAt
                    conversationId
                status
                }
              }
              unreadMessagesCount
            }
          }
        }

        """

        let request = GraphQLRequest<UserConversationsList>(
            document: listUserConversationsQuery,
            variables: ["userId": currentUserId],
            responseType: UserConversationsList.self,
            decodePath: operationName
        )

        Task {
            do {
                let result = try await Amplify.API.query(request: request)
                switch result {
                case .success(let conversationsData):
//                    print("Fetched user conversations successfully, \(conversationsData.items)")
                    print("Fetched user conversations successfully")
//                    let sortedUserConversations: [UserConversations]
//                    sortedUserConversations = try conversationsData.items.sorted {
//                        guard let firstConversation = $0.conversation, let secondConversation = $1.conversation else {
//                            throw NSError(domain: "SortingError", code: 1, userInfo: nil)
//                        }
//                        return firstConversation.updatedAt > secondConversation.updatedAt
//                    }
                    DispatchQueue.main.async {
                        self.userConversations = conversationsData.items
                    }
                case .failure(let error):
                    print("Error fetching user conversations: \(error)")
                }
            } catch {
                print("Error fetching user conversations: \(error)")
            }
        }
    }
    
    func subscribeToNewUser(userId: String?) async {
        print("Subscribing to updates on UserConversations for userid \(String(describing: userId))")
//        print("Subscribing to updates on UserConversations for user \(String(describing: sessionManager?.currentUser))")
        guard let userId = sessionManager?.currentUser?.id else {return}
        print("Guard Subscribing to updates on UserConversations for userId \(userId)")
        let operationName = "onUpdateUser"
        let request = GraphQLRequest<User>(
            document: """
            subscription UserUpdated($userId: ID!){
             \(operationName)(filter: {id: {eq: $userId}}){
                
                  id
                fullname
                email
            
               }
            }

            """,
            variables: ["userId": userId],
            responseType: User.self,
            decodePath: operationName
        )
        userUpdateSubscription = Amplify.API.subscribe(
            request: request
        )

        Task {
            do {
                for try await subscriptionEvent in userUpdateSubscription! {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state  for userUpdateSubscription is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let updatedUser):
                            print("SUBSCRIPTION: Success, we got an update on a UserConversations!!")
                            print("it is \(updatedUser)")
                            DispatchQueue.main.async{
                                self.userConversations = []
                            }
                        case .failure(let error):
                            print("Failed to receive new message: \(error)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }
    func subscribeToNewUserConversations(userId: String?) {
        print("Subscribing to updates on UserConversations for userid \(String(describing: userId))")
//        print("Subscribing to updates on UserConversations for user \(String(describing: sessionManager?.currentUser))")
        guard let userId = sessionManager?.currentUser?.id else {return}
        print("Guard Subscribing to updates on UserConversations for userId \(userId)")
        let operationName = "onUpdateUserConversations"
        let request = GraphQLRequest<UserConversations>(
            document: """
            subscription UserConversationsUpdated($userId: ID!){
             \(operationName)(filter: {userId: {eq: $userId}}){
                
                  id
                  conversation {
                    id
                  }
                  user {
                    id
                    fullname
                    email
                  }
                  title
                  unreadMessagesCount
                  updatedAt
               }
            }

            """,
            variables: ["userId": userId],
            responseType: UserConversations.self,
            decodePath: operationName
        )
        userConversationsUpdateSubscription = Amplify.API.subscribe(
            request: request
        )
        print("Subscription data is \(String(describing: userConversationsUpdateSubscription))")

        Task {
            do {
                
                for try await subscriptionEvent in userConversationsUpdateSubscription! {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state  for userConversationsUpdateSubscription is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let updatedUserConversation):
                            print("SUBSCRIPTION: Success, we got an update on a UserConversations!!")
                            print("it is \(updatedUserConversation)")
                            print("Fetching user conversations")
                            await self.fetchUserConversations()
//                            }
                        case .failure(let error):
                            print("Failed to receive new message: \(error)")
                        }
                    }
                }
            } catch {
                print("Subscription has terminated with \(error)")
            }
        }
    }
    func updateUserConversations(userConversation: UserConversations) async {
//        guard var userConversation = existingUserConversation else { return }
        print("Entered updateUserconversations")
        var userConversation = userConversation
        userConversation.unreadMessagesCount += 1
        userConversation.type = "UserConversations"
        userConversation.updatedAt = Temporal.DateTime.now().iso8601String
//        userConversation.
        do{
           
            let userConversationResult = try await Amplify.API.mutate(request: .update(userConversation))
            switch userConversationResult{
            case .success(let updatedUserConversation):
               
                print("Successfully updated user conversation's updatedAt \(updatedUserConversation)")
                
            case .failure(let error):
                print("Failed to send message: \(error)")
            }
            
        }catch{
            print("Unexpected error: \(error)")
        }
       
    }
    func cancelMessagesForRecipientsCreate(){
       subscriptions.forEach { $0.cancel() }
       subscriptions.removeAll()
       print("Canceled subscription to messages recipient")
   }
//    func subscribeToNewMessagesForRecipient(recipientId: String) {
//        let operationName = "onCreateMessage"
//        print("Subscribing to new messages for recipient, \(recipientId)")
//        let request = GraphQLRequest<Message>(
//            document: """
//            subscription RecipientMessageCreated($recipientId: ID!){
//             \(operationName)(filter: {recipientId: {eq: $recipientId}}){
//                
//                   id
//                   status
//                   updatedAt
//                   type
//                   content{
//                     text
//                   }
//                   sender {
//                     id
//                     fullname
//                     email
//                   }
//                  recipient {
//                    id
//                    fullname
//                    email
//                  }
//                   conversationId
//                 
//               }
//            }
//
//            """,
//            variables: ["recipientId": recipientId],
//            responseType: Message.self,
//            decodePath: operationName
//        )
//        newMessageForRecipientSubscription = Amplify.API.subscribe(
//            request: request
//        )
//
//        Task {
//            do {
//                for try await subscriptionEvent in newMessageForRecipientSubscription! {
//                    switch subscriptionEvent {
//                    case .connection(let subscriptionConnectionState):
//                        print("Subscription connect state for newMessageForRecipientSubscription  is \(subscriptionConnectionState)")
//                    case .data(let result):
//                        switch result {
//                        case .success(let newMessage):
//                            print("SUBSCRIPTION: Success, we got a new message for the current recipient!! \(newMessage)")
//                            // We have to increment the userConversation's unreadMessagesCount
//                        case .failure(let error):
//                            print("Failed to receive new message: \(error)")
//                        }
//                    }
//                }
//            } catch {
//                print("Subscription has terminated with \(error)")
//            }
//        }
//    }
    func cancelUserConversationsUpdate(){
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        print("Canceled subscription to conversations")
        userConversationsUpdateSubscription?.cancel()
//        userUpdateSubscription?.cancel()
        print("Userconversations update subscription is canceled")
    }
}

struct UserConversationsList: Decodable {
    var items: [UserConversations]
}

struct UserUpdateResponse: Decodable{
    var id: String
}

//struct UserConversations: Identifiable, Decodable {
//    let id: String
//    let conversation: Conversation
//}
//
//struct Conversation: Decodable {
//    let id: String
//    let title: String
//    let updatedAt: String
//}
