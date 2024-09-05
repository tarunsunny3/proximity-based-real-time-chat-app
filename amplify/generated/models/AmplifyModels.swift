// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "28cd4a423fd53e9f0413a066162649b6"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: Conversation.self)
    ModelRegistry.register(modelType: UserConversations.self)
    ModelRegistry.register(modelType: Message.self)
    ModelRegistry.register(modelType: BlockedUser.self)
    ModelRegistry.register(modelType: Location.self)
  }
}