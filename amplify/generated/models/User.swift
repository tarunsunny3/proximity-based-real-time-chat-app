// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var profileImageId: String?
  public var fullname: String
  public var email: String
  public var status: UserStatus?
  public var lastSeen: Temporal.DateTime?
  public var conversations: List<UserConversations>?
  public var messages: List<Message>?
  public var interests: [String?]?
  public var blockedUsersList: List<BlockedUser>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      profileImageId: String? = nil,
      fullname: String,
      email: String,
      status: UserStatus? = nil,
      lastSeen: Temporal.DateTime? = nil,
      conversations: List<UserConversations>? = [],
      messages: List<Message>? = [],
      interests: [String?]? = nil,
      blockedUsersList: List<BlockedUser>? = []) {
    self.init(id: id,
      profileImageId: profileImageId,
      fullname: fullname,
      email: email,
      status: status,
      lastSeen: lastSeen,
      conversations: conversations,
      messages: messages,
      interests: interests,
      blockedUsersList: blockedUsersList,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      profileImageId: String? = nil,
      fullname: String,
      email: String,
      status: UserStatus? = nil,
      lastSeen: Temporal.DateTime? = nil,
      conversations: List<UserConversations>? = [],
      messages: List<Message>? = [],
      interests: [String?]? = nil,
      blockedUsersList: List<BlockedUser>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.profileImageId = profileImageId
      self.fullname = fullname
      self.email = email
      self.status = status
      self.lastSeen = lastSeen
      self.conversations = conversations
      self.messages = messages
      self.interests = interests
      self.blockedUsersList = blockedUsersList
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}