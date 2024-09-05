// swiftlint:disable all
import Amplify
import Foundation

extension Conversation {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case participants
    case messages
    case lastMessage
    case createdAt
    case updatedAt
    case conversationLastMessageId
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let conversation = Conversation.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Conversations"
    model.syncPluralName = "Conversations"
    
    model.attributes(
      .primaryKey(fields: [conversation.id])
    )
    
    model.fields(
      .field(conversation.id, is: .required, ofType: .string),
      .hasMany(conversation.participants, is: .optional, ofType: UserConversations.self, associatedWith: UserConversations.keys.conversation),
      .hasMany(conversation.messages, is: .optional, ofType: Message.self, associatedWith: Message.keys.conversationId),
      .hasOne(conversation.lastMessage, is: .optional, ofType: Message.self, associatedWith: Message.keys.id, targetNames: ["conversationLastMessageId"]),
      .field(conversation.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(conversation.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(conversation.conversationLastMessageId, is: .optional, ofType: .string)
    )
    }
}

extension Conversation: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}