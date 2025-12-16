import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeMapView()
                .tabItem {
                    Label("Community", systemImage: "person.3.fill")
                }

            SuggestionsView()
                .tabItem {
                    Label("Suggestions", systemImage: "lightbulb.fill")
                }

            ChallengeView()
                .tabItem {
                    Label("Challenge", systemImage: "flag.fill")
                }

            MyTripView()
                .tabItem {
                    Label("My Trip", systemImage: "map.fill")
                }
        }
    }
}

