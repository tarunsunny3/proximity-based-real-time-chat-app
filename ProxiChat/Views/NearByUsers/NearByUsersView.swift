import SwiftUI
import Amplify

struct NearByUsersView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @StateObject private var viewModel = NearbyUsersViewModel()
    
//    @State private var users: [User] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Nearby Users")
                    .font(.largeTitle)
                    .padding()
                
                Button {
                    Task{
                        await viewModel.fetchUsers()
                    }
                   
                } label: {
                    Text("Fetch Nearby Users")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                ScrollView{
                        VStack {
                            ForEach(0..<(viewModel.users.count / 3 + (viewModel.users.count % 3 == 0 ? 0 : 1)), id: \.self) { rowIndex in
                                HStack(spacing: 8) {
                                    ForEach(0..<3, id: \.self) { colIndex in
                                        let userIndex = rowIndex * 3 + colIndex
                                        if userIndex < viewModel.users.count {
                                            let user = viewModel.users[userIndex]
                                            NavigationLink(destination: ChatView(sessionManager: sessionManager, recipientUser: user, existingUserConversation: nil)) {
                                            UserTile(user: user)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                            }
                        }
                }
            }
                .padding()
            }
            .onAppear {
                Task{
                    await viewModel.fetchUsers()
                }
//                populateDummyUsers(number: 30)
            }
        }
    }

    private func getNearByUsers() {
        // Fetch nearby users from the backend
    }

//    private func populateDummyUsers(number: Int) {
//        var count = 1
//        for _ in 1...number {
//            let id = UUID().uuidString // Generate a unique ID
//            let fullname = "User \(count)" // Customize the fullname as needed
//            let email = "user\(count)@example.com" // Customize the email as needed
//            let status: UserStatus = .online // Customize the status as needed
//            viewModel.users.append(User(id: id, fullname: fullname, email: email, status: status))
//            count += 1
//        }
//    }
}

struct UserTile: View {
//    @Binding var user: User/
    let user: User
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
            Text(user.fullname)
            HStack(spacing: 4) {
                Circle()
                    .fill(user.status == .online ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)
                Text(user.status == .online ? "Online" : "Offline")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

#Preview {
    NearByUsersView()
}
