// swiftlint:disable all
import Amplify
import Foundation

extension Message {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case status
    case read
    case conversationId
    case sender
    case type
    case updatedAt
    case createdAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let message = Message.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Messages"
    model.syncPluralName = "Messages"
    
    model.attributes(
      .index(fields: ["conversationId", "updatedAt"], name: "byConversation"),
      .index(fields: ["senderId"], name: "bySender"),
      .index(fields: ["type", "updatedAt"], name: "messagesByUpdatedAt"),
      .primaryKey(fields: [message.id])
    )
    
    model.fields(
      .field(message.id, is: .required, ofType: .string),
      .field(message.content, is: .required, ofType: .embedded(type: MessageContent.self)),
      .field(message.status, is: .required, ofType: .enum(type: MessageStatus.self)),
      .field(message.read, is: .optional, ofType: .bool),
      .field(message.conversationId, is: .required, ofType: .string),
      .belongsTo(message.sender, is: .optional, ofType: User.self, targetNames: ["senderId"]),
      .field(message.type, is: .optional, ofType: .string),
      .field(message.updatedAt, is: .required, ofType: .string),
      .field(message.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Message: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}