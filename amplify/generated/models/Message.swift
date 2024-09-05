// swiftlint:disable all
import Amplify
import Foundation

public struct Message: Model {
  public let id: String
  public var content: MessageContent
  public var status: MessageStatus
  public var read: Bool?
  public var conversationId: String
  public var sender: User?
  public var type: String?
  public var updatedAt: String
  public var createdAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      content: MessageContent,
      status: MessageStatus,
      read: Bool? = nil,
      conversationId: String,
      sender: User? = nil,
      type: String? = nil,
      updatedAt: String) {
    self.init(id: id,
      content: content,
      status: status,
      read: read,
      conversationId: conversationId,
      sender: sender,
      type: type,
      updatedAt: updatedAt,
      createdAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      content: MessageContent,
      status: MessageStatus,
      read: Bool? = nil,
      conversationId: String,
      sender: User? = nil,
      type: String? = nil,
      updatedAt: String,
      createdAt: Temporal.DateTime? = nil) {
      self.id = id
      self.content = content
      self.status = status
      self.read = read
      self.conversationId = conversationId
      self.sender = sender
      self.type = type
      self.updatedAt = updatedAt
      self.createdAt = createdAt
  }
}
