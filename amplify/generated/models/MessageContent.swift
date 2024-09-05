// swiftlint:disable all
import Amplify
import Foundation

public struct MessageContent: Embeddable {
  var text: String?
  var fileURL: String?
}