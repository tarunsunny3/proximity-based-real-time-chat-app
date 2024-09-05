// swiftlint:disable all
import Amplify
import Foundation

public struct Location: Model {
  public let id: String
  public var userId: String
  public var latitude: Double
  public var longitude: Double
  public var timestamp: Temporal.DateTime
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userId: String,
      latitude: Double,
      longitude: Double,
      timestamp: Temporal.DateTime) {
    self.init(id: id,
      userId: userId,
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userId: String,
      latitude: Double,
      longitude: Double,
      timestamp: Temporal.DateTime,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userId = userId
      self.latitude = latitude
      self.longitude = longitude
      self.timestamp = timestamp
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}