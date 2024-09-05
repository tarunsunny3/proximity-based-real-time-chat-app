import SwiftUI
import Amplify

struct RegisterView: View {
    
   
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmationCode: String = ""
    @State private var isSigningUp: Bool = false
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .padding()
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            

            
            if isSigningUp {
                ProgressView()
            } else {
                Button("Register") {
                    Task{
                        await signUp()
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        
    }
    
    func signUp() async {
        isSigningUp = true
        let userAttributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )
            if case .confirmUser(_, _, _) = signUpResult.nextStep {
                print("Sign-up successful")
                navigateToLoginView()
            }
        } catch let error as AuthError {
            print("An error occurred while registering a user \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        isSigningUp = false
    }
    func navigateToLoginView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let loginView = LoginView()
            let loginNavigationView = NavigationView { loginView }
            loginNavigationView.navigationViewStyle(StackNavigationViewStyle())
            window.rootViewController = UIHostingController(rootView: loginNavigationView)
//            self.window = window
            window.makeKeyAndVisible()
        }
    }

    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
