import SwiftUI

struct RoleSelectionView: View {
    @State private var selectedRole: Role? = nil

    enum Role: String {
        case traveller = "Traveller"
        case helper = "Helper"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 50) {
                Text("Select Your Role")
                    .font(.largeTitle)
                    .bold()
                
                HStack(spacing: 50) {
                    NavigationLink(destination: MainTabView(), tag: .traveller, selection: $selectedRole) {
                        Button(action: { selectedRole = .traveller }) {
                            VStack {
                                Image(systemName: "airplane")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.blue)
                                Text("Traveller")
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    NavigationLink(destination: MainTabView(), tag: .helper, selection: $selectedRole) {
                        Button(action: { selectedRole = .helper }) {
                            VStack {
                                Image(systemName: "hands.sparkles")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.green)
                                Text("Helper")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 100)
        }
    }
}

