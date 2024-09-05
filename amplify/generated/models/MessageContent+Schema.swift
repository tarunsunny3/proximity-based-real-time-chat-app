// swiftlint:disable all
import Amplify
import Foundation

extension MessageContent {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case text
    case fileURL
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let messageContent = MessageContent.keys
    
    model.listPluralName = "MessageContents"
    model.syncPluralName = "MessageContents"
    
    model.fields(
      .field(messageContent.text, is: .optional, ofType: .string),
      .field(messageContent.fileURL, is: .optional, ofType: .string)
    )
    }
}