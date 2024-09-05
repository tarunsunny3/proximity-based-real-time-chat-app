// swiftlint:disable all
import Amplify
import Foundation

extension BlockedUser {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userId
    case blockedUser
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let blockedUser = BlockedUser.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "BlockedUsers"
    model.syncPluralName = "BlockedUsers"
    
    model.attributes(
      .index(fields: ["userId"], name: "byUser"),
      .primaryKey(fields: [blockedUser.id])
    )
    
    model.fields(
      .field(blockedUser.id, is: .required, ofType: .string),
      .field(blockedUser.userId, is: .required, ofType: .string),
      .belongsTo(blockedUser.blockedUser, is: .optional, ofType: User.self, targetNames: ["blockedUserId"]),
      .field(blockedUser.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(blockedUser.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension BlockedUser: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}