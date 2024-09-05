// swiftlint:disable all
import Amplify
import Foundation

public enum UserStatus: String, EnumPersistable {
  case online = "ONLINE"
  case offline = "OFFLINE"
  case away = "AWAY"
}