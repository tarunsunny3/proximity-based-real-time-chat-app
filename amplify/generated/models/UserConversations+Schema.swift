// swiftlint:disable all
import Amplify
import Foundation

extension UserConversations {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case user
    case conversation
    case title
    case type
    case updatedAt
    case unreadMessagesCount
    case createdAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userConversations = UserConversations.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserConversations"
    model.syncPluralName = "UserConversations"
    
    model.attributes(
      .index(fields: ["userId"], name: "byUserConversation"),
      .index(fields: ["conversationId"], name: "byConversationUser"),
      .index(fields: ["type", "updatedAt"], name: "userConversationsByUpdatedAt"),
      .primaryKey(fields: [userConversations.id])
    )
    
    model.fields(
      .field(userConversations.id, is: .required, ofType: .string),
      .belongsTo(userConversations.user, is: .optional, ofType: User.self, targetNames: ["userId"]),
      .belongsTo(userConversations.conversation, is: .required, ofType: Conversation.self, targetNames: ["conversationId"]),
      .field(userConversations.title, is: .required, ofType: .string),
      .field(userConversations.type, is: .optional, ofType: .string),
      .field(userConversations.updatedAt, is: .required, ofType: .string),
      .field(userConversations.unreadMessagesCount, is: .required, ofType: .int),
      .field(userConversations.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension UserConversations: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}