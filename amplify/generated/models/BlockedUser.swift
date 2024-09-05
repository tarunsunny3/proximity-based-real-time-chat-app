// swiftlint:disable all
import Amplify
import Foundation

public struct BlockedUser: Model {
  public let id: String
  public var userId: String
  public var blockedUser: User?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userId: String,
      blockedUser: User? = nil) {
    self.init(id: id,
      userId: userId,
      blockedUser: blockedUser,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userId: String,
      blockedUser: User? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userId = userId
      self.blockedUser = blockedUser
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}