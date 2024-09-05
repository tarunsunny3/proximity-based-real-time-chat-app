//
//  SessionManager.swift
//  ChatApp
//
//  Created by Tarun Chinthakindi on 14/05/24.
//
import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

enum AuthState {
    case signUp
    case signIn
    case confirmSignup(username: String)
    case session
}

final class SessionManager: ObservableObject {
    @Published var authState: AuthState
    @Published var currentUserId: String?
    @Published var currentUser: User?
    
    var locationManager: LocationManager
      
    init() {
        authState = .signIn
        currentUserId = nil
        currentUser = nil
        locationManager = LocationManager()
    }
    
    func showSignIn(){
        DispatchQueue.main.async {
            self.authState = .signIn
        }
    }
    
    func showSignUp(){
        DispatchQueue.main.async {
            self.authState = .signUp
        }
    }
    func fetchUserData(email: String) async -> User? {
        
        print("Fetching User data for email: \(email)")
        let operationName = "userByEmail"
        let request = GraphQLRequest<UsersList>(
            document: """
            query GetUser($email: String!){
             \(operationName)(email: $email){
                 items{
                   id
                   fullname
                   email
                   interests
                 }
               }
            }
            """,
            variables: ["email": email],
            responseType: UsersList.self,
            decodePath: operationName
        )

        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let users):
                print("Successfully fetched users for email id \(String(describing: email))")
                if users.items.isEmpty{
                    print("No user found with the email \(email)")
                    return nil
                }
                return users.items.first
                
            case .failure(let error):
                print("Failed to fetch users: \(error)")
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
        return nil
    }
    func getCurrentUserId() async -> String? {
            do {
                if let user = try? await Amplify.Auth.getCurrentUser() {
                    // User is logged in, fetch user data and set authState to .session
//                    print("User is logged in")
//                    print("Auth user is \(user)")
                    
                    // Fetch user attributes
                    let userAttributes = try await Amplify.Auth.fetchUserAttributes()
    //                print("User attributes: \(userAttributes)")
                    
                    // Find the email attribute
                    if let emailAttribute = userAttributes.first(where: { $0.key == AuthUserAttributeKey.email }) {
                        let email = emailAttribute.value
                        // Fetch user data using the email and set authState to .session
                        let currUser = await fetchUserData(email: email)
                        
                        print("Curr user fetched using API is \(currUser)")
                        guard let currUserID = currUser?.id else {return nil};
                   
                        return currUserID
                    } else {
                        print("Error: Email attribute not found in user attributes")
                    }
                }
            } catch let error as AuthError {
                print("An error occurred while getting current user \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        return nil
        }
    
    func getCurrentAuthUser() async {
        do {
            if let user = try? await Amplify.Auth.getCurrentUser() {
                // User is logged in, fetch user data and set authState to .session
                print("User is logged in")
                print("Auth user is \(user)")
                
                // Fetch user attributes
                let userAttributes = try await Amplify.Auth.fetchUserAttributes()
//                print("User attributes: \(userAttributes)")
                
                // Find the email attribute
                if let emailAttribute = userAttributes.first(where: { $0.key == AuthUserAttributeKey.email }) {
                    let email = emailAttribute.value
                    // Fetch user data using the email and set authState to .session
                    let currUser = await fetchUserData(email: email)
                    print("Curr user fetched using API is \(String(describing: currUser))")
                    guard let currUserID = currUser?.id else {return};
                    DispatchQueue.main.async {
                        
                        self.currentUser = currUser
//                        print("FINALLY set the self.currentUser to \(String(describing: currUser))")
                        self.currentUserId = currUserID
//                        print("current user is \(String(describing: self.currentUser))")
                        self.authState = .session
                    }
                    
                } else {
                    print("Error: Email attribute not found in user attributes")
                }
            } else {
                // User is not logged in, set authState to .signIn
                DispatchQueue.main.async {
                    self.authState = .signIn
                }
            }
        } catch let error as AuthError {
            print("An error occurred while getting current user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }


    func signUp(email: String, password: String, fullName: String?) async {
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )
            if case .confirmUser(_, _, _) = signUpResult.nextStep {
                print("Sign-up successful, confirming user")
                // After successful signup, save user details to DynamoDB using DataStore
                let newUser = User(
                    profileImageId: "", // Add profile image ID if available
                    fullname: fullName ?? "", // Add user's full name
                    email: email,
                    status: .online,
                    lastSeen: Temporal.DateTime(Foundation.Date()) // Set current date as last seen
                )
          
                do{
                    let userData =  try await Amplify.API.mutate(request: .create(newUser))
                    switch userData{
                    case .success(let newUserCreated):
                        print("User record successfully saved in the DB!! \(newUserCreated)")
                        DispatchQueue.main.async {
                            self.authState = .confirmSignup(username: email)
                        }
                    case .failure(let error):
                        print("Error creating a new user: \(error)")
                    }
                }catch{
                    print("Error creating a new user: \(error)")
                }
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
        
        
        func resendSignUpCode(username: String) async {
            do{
                _ = try await Amplify.Auth.resendSignUpCode(for: username)
                print("Resent the sign up code")
                
            }catch {
                print("An error coccuered: \(error)")
            }
        }
        
        func confirmSignUp(username: String, confirmationCode: String) async {
            do {
                let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                    for: username,
                    confirmationCode: confirmationCode
                )
                print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
                
                await getCurrentAuthUser()
            } catch let error as AuthError {
                print("An error occurred while confirming sign up \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        func signIn(username: String, password: String) async {
            do {
                let signInResult = try await Amplify.Auth.signIn(
                    username: username,
                    password: password
                )
                print(signInResult.nextStep)
                if case .confirmSignUp = signInResult.nextStep {
                    print("Sign-up confirmation needed" )
                    
                    await resendSignUpCode(username: username)
                    DispatchQueue.main.async {
                        self.authState = .confirmSignup(username: username)
                    }
                    
                }
                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                    await self.getCurrentAuthUser()
//                    print("Userconversations subscription is called from SignIN method with userid = \(String(describing: self.currentUser?.id))")
//                    conversationsViewModel.subscribeToNewUserConversations(userId: self.currentUser?.id)
                    
                }
            } catch let error as AuthError {
                print("Sign in failed \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    func signOutLocally() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
        case .complete:
            // Sign Out completed fully and without errors.
            print("Signed out successfully")
            locationManager.stopLocationUpdates()
            DispatchQueue.main.async {
                self.authState = .signIn
//                self.conversationsViewModel?.cancelUserConversationsUpdate()
                self.currentUserId = nil
                self.currentUser = nil
            }
//            await getCurrentAuthUser()
//            print("Userconversations subscription cancellation is called from SignOUT method")
//            conversationsViewModel.cancelUserConversationsUpdate()

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.
            
            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
}

struct UsersList: Decodable {
    var items: [User]
}
