import SwiftUI
import Amplify
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSAPIPlugin

func configureAmplify() {
    Amplify.Logging.logLevel = .info
    do {
        try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
        try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.configure()
        print("Initialized Amplify");
    } catch {
        print("Could not initialize Amplify: \(error)")
    }
}
@main
struct ChatApp: App {
    
    init(){
        configureAmplify()
    }
    @ObservedObject var sessionManager =  SessionManager()
    var body: some Scene {
       
        WindowGroup{
//            print("Session manager currentUser is \(sessionManager.currentUser)")
//            if(sessionManager.currentUser != nil){
//                MainView()
//                    .environmentObject(sessionManager)
//            }
            switch sessionManager.authState{
            case .signIn:
                LoginView()
                    .environmentObject(sessionManager)
            case .signUp:
                SignupView()
                    .environmentObject(sessionManager)
                
            case .confirmSignup(let username):
                SignupConfirmationView(username: username)
                    .environmentObject(sessionManager)
            case .session:
                MainView()
                    .environmentObject(sessionManager)
                
            }
        }
    }
}
