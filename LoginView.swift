import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                // App logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 160) // adjust size as needed
                    .accessibilityLabel("HerizonApp Logo")
                    .padding(.top, 24)

                Text("HerizonApp")
                    .font(.largeTitle)
                    .bold()
 
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)

                Button(action: {
                    isLoggedIn = true
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 60)
            .navigationDestination(isPresented: $isLoggedIn) {
                RoleSelectionView()
            }
        }
    }
}
