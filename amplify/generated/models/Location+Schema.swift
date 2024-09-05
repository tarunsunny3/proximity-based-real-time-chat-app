// swiftlint:disable all
import Amplify
import Foundation

extension Location {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userId
    case latitude
    case longitude
    case timestamp
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let location = Location.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Locations"
    model.syncPluralName = "Locations"
    
    model.attributes(
      .primaryKey(fields: [location.id])
    )
    
    model.fields(
      .field(location.id, is: .required, ofType: .string),
      .field(location.userId, is: .required, ofType: .string),
      .field(location.latitude, is: .required, ofType: .double),
      .field(location.longitude, is: .required, ofType: .double),
      .field(location.timestamp, is: .required, ofType: .dateTime),
      .field(location.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(location.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Location: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}