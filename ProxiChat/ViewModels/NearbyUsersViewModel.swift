//
//  NearbyUsersViewModel.swift
//  ChatApp
//
//  Created by Tarun Chinthakindi on 25/05/24.
//



import SwiftUI
import Amplify

class NearbyUsersViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func fetchUsers() async {
        do {
            let request = GraphQLRequest<User>.list(User.self, limit: 10)
            let result = try await Amplify.API.query(
               request: request
            )

            switch result {
            case .success(let users):
                print("Successfully retrieved users: \(users)")
                DispatchQueue.main.async{
                    self.users = users.elements
                }
                
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query todo: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}
