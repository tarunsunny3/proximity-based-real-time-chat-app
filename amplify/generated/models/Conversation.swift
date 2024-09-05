// swiftlint:disable all
import Amplify
import Foundation

public struct Conversation: Model {
  public let id: String
  public var participants: List<UserConversations>?
  public var messages: List<Message>?
  public var lastMessage: Message?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  public var conversationLastMessageId: String?
  
  public init(id: String = UUID().uuidString,
      participants: List<UserConversations>? = [],
      messages: List<Message>? = [],
      lastMessage: Message? = nil,
      conversationLastMessageId: String? = nil) {
    self.init(id: id,
      participants: participants,
      messages: messages,
      lastMessage: lastMessage,
      createdAt: nil,
      updatedAt: nil,
      conversationLastMessageId: conversationLastMessageId)
  }
  internal init(id: String = UUID().uuidString,
      participants: List<UserConversations>? = [],
      messages: List<Message>? = [],
      lastMessage: Message? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil,
      conversationLastMessageId: String? = nil) {
      self.id = id
      self.participants = participants
      self.messages = messages
      self.lastMessage = lastMessage
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.conversationLastMessageId = conversationLastMessageId
  }
}