//
//  ModelExtensions.swift
//  ChatApp
//
//  Created by Tarun Chinthakindi on 23/05/24.
//

import Foundation
import Amplify

// Extend Conversation to conform to Identifiable
extension Conversation: Identifiable {}
extension UserConversations: Identifiable {}
extension User: Identifiable {}
extension Message: Identifiable {}

