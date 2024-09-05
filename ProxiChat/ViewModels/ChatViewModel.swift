import SwiftUI
import Amplify
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
//    @Published var conversation: Conversation?
    
    private var newMessageForConversationSubscription: AmplifyAsyncThrowingSequence<GraphQLSubscriptionEvent<Message>>?
    
    
    private let recipientUser: User?
    private var existingUserConversation: UserConversations?
    private let sessionManager: SessionManager
//    private var subscriptions = Set<AnyCancellable>()
    init(sessionManager: SessionManager, recipientUser: User?, existingUserConversation: UserConversations?) {
        self.sessionManager = sessionManager
        self.recipientUser = recipientUser
        self.existingUserConversation = existingUserConversation
        
    }
    
    func getUserConversations(for conversationId: String?) async -> [UserConversations] {
        guard let conversationId = conversationId else {return []}
        let operationName = "userConversationsByConversationId"
        
        let request = GraphQLRequest<UserConversationsList>(
            document: """
                query UserConversationsByConversation($conversationId: ID!){
                    \(operationName)(conversationId: $conversationId) {
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
                            user{
                                id
                                fullname
                                email
                            }
                            userId
                            conversationId
                          unreadMessagesCount
                        }
                         
                        
                      }
                }
            """,
            variables: ["conversationId": conversationId],
            responseType: UserConversationsList.self,
            decodePath: operationName
        )
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let data):
                print("Successfully fetched user conversations for conversation id \(String(describing: conversationId))")
//                DispatchQueue.main.async{
//                    self.messages = data.items
//                }
                return data.items
                
            case .failure(let error):
                print("Failed to fetch messages: \(error)")
                return []
            }
        } catch {
            print("Failed to fetch messages: \(error)")
            return []
        }
        return []
    }
    
    func updateUnreadMessageCount(userConversations: [UserConversations]) async {
        for userConversation in userConversations {
            var unreadMessagesCount = userConversation.unreadMessagesCount
            if userConversation.user?.id != sessionManager.currentUserId{
               
                unreadMessagesCount += 1
            }
            let userConversationId = userConversation.id
            let operationName = "updateUserConversations"
            let request = GraphQLRequest<UserConversations>(
                document: """
                
                  mutation UpdateUserConversations($userConversationId: ID!, $unreadMessagesCount: Int!) {
                    \(operationName)( input: {id: $userConversationId, unreadMessagesCount: $unreadMessagesCount}) {
                      id
                      conversation {
                        id
                      }
                      unreadMessagesCount
                      title
                      updatedAt
                      userId
                      conversationId
                    }
                  }

                """,
                variables: ["userConversationId": userConversationId, "unreadMessagesCount": unreadMessagesCount],
                responseType: UserConversations.self,
                decodePath: operationName
            )
           
            do{
               
                let userConversationResult = try await Amplify.API.mutate(request: request)
                switch userConversationResult{
                case .success(let updatedUserConversation):
                   
                    print("Successfully updated user conversation's  for \(userConversationId) unreadMessages count to \(unreadMessagesCount)")
                case .failure(let error):
                    print("Failed to send message: \(error)")
                }
                
            }catch{
                print("Unexpected error: \(error)")
            }
           
        }
    }
    
    func fetchMessages(conversationId: String?) async {
        
        guard let conversationId = conversationId else {return}
        print("Fetching data for conversation: \(conversationId)")
        let operationName = "messagesByConversationIdAndUpdatedAt"
        let request = GraphQLRequest<ListMessagesResponse>(
            document: """
            query MessagesByUpdatedAt($conversationId: ID!){
             \(operationName)(conversationId: $conversationId){
                 items{
                   id
                   status
                     createdAt
                   updatedAt
                   type
                   content{
                     text
                   }
                   sender {
                     id
                     fullname
                     email
                   }
                conversationId
                 }
               }
            }

            """,
            variables: ["conversationId": conversationId],
            responseType: ListMessagesResponse.self,
            decodePath: operationName
        )

        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let data):
                print("Successfully fetched messages for conversation id \(String(describing: conversationId))")
                DispatchQueue.main.async{
                    self.messages = data.items
                }
                
            case .failure(let error):
                print("Failed to fetch messages: \(error)")
            }
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
   
    func sendMessage(content: String, to recipientId: String?) async {
        guard let senderId =  sessionManager.currentUserId else { return }
        print("Sender id is \(senderId)")
        if existingUserConversation == nil {
            print("***************************Creating a new conversation************************\n")
            // Create a new conversation
            let newConversation = Conversation(id: UUID().uuidString)

            do {
                let createConversationResult = try await Amplify.API.mutate(request: .create(newConversation))
                switch createConversationResult {
                case .success(let createdConversation):
//                    existingConversation = createdConversation
                    print("Successfully created conversation: \(createdConversation)")
                    let senderUserConversation =  UserConversations(
                        user: sessionManager.currentUser!,
                        conversation: createdConversation,
                        title: recipientUser?.fullname ?? "User",
                        updatedAt: Temporal.Date.now().iso8601String,
                        unreadMessagesCount: 0
                        
                    )
                    
                    let recipientUserConversation =  UserConversations(
                        user: recipientUser!,
                        conversation: createdConversation,
                        title: sessionManager.currentUser?.fullname ?? "User",
                        updatedAt: Temporal.Date.now().iso8601String,
                        unreadMessagesCount: 0
                    )

                   
                    do {
                        let createSenderConversationUserResult = try await Amplify.API.mutate(request: .create(senderUserConversation))
                        switch createSenderConversationUserResult {
                        case .success(let createdSenderConversationUser):
                            print("Successfully created sender conversation user: \(createdSenderConversationUser)")
                            existingUserConversation = createdSenderConversationUser
                        case .failure(let error):
                            print("Failed to create sender conversation user: \(error)")
                            return
                        }

                        let createRecipientConversationUserResult = try await Amplify.API.mutate(request: .create(recipientUserConversation))
                        switch createRecipientConversationUserResult {
                        case .success(let createdRecipientConversationUser):
                            print("Successfully created recipient conversation user: \(createdRecipientConversationUser)")
                        case .failure(let error):
                            print("Failed to create recipient conversation user: \(error)")
                            return
                        }
                    } catch {
                        print("Unexpected error: \(error)")
                        return
                    }
                case .failure(let error):
                    print("Failed to create conversation: \(error)")
                    return
                }
            } catch {
                print("Unexpected error: \(error)")
                return
            }

        }
        

        guard let userConversation = existingUserConversation else { return }
        let newMessage =  Message(
            content: MessageContent(text: content),
            status: .sent,
            conversationId: userConversation.conversation.id,
            sender: sessionManager.currentUser,
            type: "Message",
            updatedAt: Temporal.DateTime.now().iso8601String
        )
//        self.messages.append(newMessage)
        print("Successfully sent message locally")
        
        
        do {
            let sendMessageResult = try await Amplify.API.mutate(request: .create(newMessage))
            switch sendMessageResult {
            case .success(let createdMessage):
                DispatchQueue.main.async{
                    self.messages.append(createdMessage)
                }
               
                print("Successfully sent message to the backend: \(createdMessage)")
                await updateConversationLastMessage(lastMessageId: createdMessage.id)
                print("Called getUserConversations")
                let userConversations = await getUserConversations(for: existingUserConversation?.conversation.id)
//                print("Called updateUnreadMessa")
                await updateUnreadMessageCount(userConversations: userConversations)
//                await updateUserConversations()
            case .failure(let error):
                print("Failed to send message: \(error)")
            }
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    private func updateConversationLastMessage(lastMessageId: String) async {
        guard let userConversation = existingUserConversation else { return }
        var conversationToBeUpdated = userConversation.conversation
        let operationName = "updateConversation"
        let request = GraphQLRequest<Conversation>(
            document: """
            
              mutation UpdateConversation($conversationId: ID!, $conversationLastMessageId: ID!) {
                \(operationName)( input: {id: $conversationId, conversationLastMessageId: $conversationLastMessageId}) {
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
              }

            """,
            variables: ["conversationId": conversationToBeUpdated.id, "conversationLastMessageId": lastMessageId],
            responseType: Conversation.self,
            decodePath: operationName
        )
//        conversationToBeUpdated.conversationLastMessageId = lastMessageId
        do {
            let conversationResult = try await Amplify.API.mutate(request: request)
            switch conversationResult{
            case .success(let updatedConversation):
               
                print("Successfully updated conversation's lastMessage id to \(String(describing: lastMessageId))\n, updated conversation is \(updatedConversation)")
            case .failure(let error):
                print("Failed to update conversation: \(error)")
            }
        }catch {
            print("Failed to update conversation: \(error)")
        }
    }
    private func updateUserConversations(userConversationId: String?) async {
        guard let userConversationId = userConversationId else { return }
        let operationName = "updateUserConversations"
        let request = GraphQLRequest<UserConversations>(
            document: """
            
              mutation UpdateUserConversations($userConversationId: ID!) {
                \(operationName)( input: {id: $userConversationId}) {
                  id
                  conversation {
                    id
                  }
                  unreadMessagesCount
                  title
                  updatedAt
                  userId
                }
              }

            """,
            variables: ["userConversationId": userConversationId],
            responseType: UserConversations.self,
            decodePath: operationName
        )
       
        do{
           
            let userConversationResult = try await Amplify.API.mutate(request: request)
            switch userConversationResult{
            case .success(let updatedUserConversation):
               
                print("Successfully updated user conversation's updatedAt")
            case .failure(let error):
                print("Failed to send message: \(error)")
            }
            
        }catch{
            print("Unexpected error: \(error)")
        }
       
    }
    private func subscribeToNewMessagesForConversation(conversationId: String) {
        let operationName = "onCreateMessage"
        let request = GraphQLRequest<Message>(
            document: """
            subscription ConversationMessageCreated($conversationId: ID!){
             \(operationName)(filter: {conversationId: {eq: $conversationId}}){
                
                   id
                   status
                   updatedAt
                   type
                   content{
                     text
                   }
                   sender {
                     id
                     fullname
                     email
                   }
                   conversationId
                 
               }
            }

            """,
            variables: ["conversationId": conversationId],
            responseType: Message.self,
            decodePath: operationName
        )
        newMessageForConversationSubscription = Amplify.API.subscribe(
            request: request
        )

        Task {
            do {
                for try await subscriptionEvent in newMessageForConversationSubscription! {
                    switch subscriptionEvent {
                    case .connection(let subscriptionConnectionState):
                        print("Subscription connect state is \(subscriptionConnectionState)")
                    case .data(let result):
                        switch result {
                        case .success(let newMessage):
                            print("SUBSCRIPTION: Success, we got a new message!!")
                            if !self.messages.contains(where: { $0.id == newMessage.id }) {
                                if newMessage.conversationId == conversationId {
                                    DispatchQueue.main.async{
                                        self.messages.append(newMessage)
                                    }
                                }else{
                                    print("The current subscribed message doesn't belong to the current conversation")
                                }
                            }else{
                                print("New Message already exists!")
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
    
    
    func cancelNewMessageSubscription() {
        newMessageForConversationSubscription?.cancel()
            print("newMessageForConversationSubscription canceled")
    }
//    func cancelNewMessageForRecipient(){
//        newMessageForRecipientSubscription?.cancel()
//            print("newMessageForRecipientSubscription canceled")
//    }
    func readUserConversationUnreadMessages(userConversationId: String?) async{
        guard let userConversationId = userConversationId else {return}
        let unreadMessagesCount = 0
        let operationName = "updateUserConversations"
        let request = GraphQLRequest<UserConversations>(
            document: """
            
              mutation UpdateUserConversations($userConversationId: ID!, $unreadMessagesCount: Int!) {
                \(operationName)( input: {id: $userConversationId, unreadMessagesCount: $unreadMessagesCount}) {
                  id
                  conversation {
                    id
                  }
                  unreadMessagesCount
                  title
                  updatedAt
                  userId
                  conversationId
                }
              }

            """,
            variables: ["userConversationId": userConversationId, "unreadMessagesCount": unreadMessagesCount],
            responseType: UserConversations.self,
            decodePath: operationName
        )
       
        do{
           
            let userConversationResult = try await Amplify.API.mutate(request: request)
            switch userConversationResult{
            case .success(let updatedUserConversation):
               
                print("Successfully updated user conversation's  for \(userConversationId) unreadMessages count to \(unreadMessagesCount)")
            case .failure(let error):
                print("Failed to send message: \(error)")
            }
            
        }catch{
            print("Unexpected error: \(error)")
        }
    }
    func handleViewAppear() async {
       print("View Appeared")
       if let conversationId = existingUserConversation?.conversation.id {
           print("View appeared and current conversation exists, so subscribing")
           existingUserConversation?.unreadMessagesCount = 0
//           await readUserConversationUnreadMessages(userConversationId: existingUserConversation?.id)
           subscribeToNewMessagesForConversation(conversationId: conversationId)
           
       }
   }

   func handleViewDisappear() async {
       print("View Disappeared")
       existingUserConversation?.unreadMessagesCount = 0
//       await readUserConversationUnreadMessages(userConversationId: existingUserConversation?.id)
       cancelNewMessageSubscription()
   }
}

struct ListMessagesResponse: Decodable {
    let items: [Message]
}


