//
//  Queries.swift
//  ProxiChat
//
//  Created by Tarun Chinthakindi on 26/05/24.
//
import Foundation

struct Queries {
    static let fetchConversationUsers = """
    query GetUserConversations($userId: ID!) {
      getUser(id: $userId) {
        conversations {
          items {
            id
            conversation {
              id
              title
              updatedAt
            }
          }
        }
      }
    }
    """
}
