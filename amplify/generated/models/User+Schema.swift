// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case profileImageId
    case fullname
    case email
    case status
    case lastSeen
    case conversations
    case messages
    case interests
    case blockedUsersList
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Users"
    model.syncPluralName = "Users"
    
    model.attributes(
      .index(fields: ["email"], name: "byEmail"),
      .primaryKey(fields: [user.id])
    )
    
    model.fields(
      .field(user.id, is: .required, ofType: .string),
      .field(user.profileImageId, is: .optional, ofType: .string),
      .field(user.fullname, is: .required, ofType: .string),
      .field(user.email, is: .required, ofType: .string),
      .field(user.status, is: .optional, ofType: .enum(type: UserStatus.self)),
      .field(user.lastSeen, is: .optional, ofType: .dateTime),
      .hasMany(user.conversations, is: .optional, ofType: UserConversations.self, associatedWith: UserConversations.keys.user),
      .hasMany(user.messages, is: .optional, ofType: Message.self, associatedWith: Message.keys.sender),
      .field(user.interests, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .hasMany(user.blockedUsersList, is: .optional, ofType: BlockedUser.self, associatedWith: BlockedUser.keys.userId),
      .field(user.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(user.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension User: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}