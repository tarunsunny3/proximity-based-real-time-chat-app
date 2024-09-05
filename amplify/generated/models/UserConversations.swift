// swiftlint:disable all
import Amplify
import Foundation

public struct UserConversations: Model {
  public let id: String
  public var user: User?
  public var conversation: Conversation
  public var title: String
  public var type: String?
  public var updatedAt: String
  public var unreadMessagesCount: Int
  public var createdAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      user: User? = nil,
      conversation: Conversation,
      title: String,
      type: String? = nil,
      updatedAt: String,
      unreadMessagesCount: Int) {
    self.init(id: id,
      user: user,
      conversation: conversation,
      title: title,
      type: type,
      updatedAt: updatedAt,
      unreadMessagesCount: unreadMessagesCount,
      createdAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      user: User? = nil,
      conversation: Conversation,
      title: String,
      type: String? = nil,
      updatedAt: String,
      unreadMessagesCount: Int,
      createdAt: Temporal.DateTime? = nil) {
      self.id = id
      self.user = user
      self.conversation = conversation
      self.title = title
      self.type = type
      self.updatedAt = updatedAt
      self.unreadMessagesCount = unreadMessagesCount
      self.createdAt = createdAt
  }
}