import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: SpotifyAuthViewModel

    var body: some View {
        TabView {
            DashboardView(viewModel: viewModel)
                .tabItem {
                    Label("Dashboard", systemImage: "person.crop.circle")
                }

            LibraryView(viewModel: viewModel)
                .tabItem {
                    Label("Library", systemImage: "music.note.list")
                }

            UserSearchView(viewModel: viewModel)
                .tabItem {
                    Label("User Search", systemImage: "magnifyingglass")
                }

            ProfileView(viewModel: viewModel)
                .tabItem {
                    Label("Profile", systemImage: "gearshape")
                }
        }
        .accentColor(Color(red: 29/255, green: 185/255, blue: 84/255))
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            let appearance = UITabBar.appearance()
            appearance.barTintColor = .black
            appearance.backgroundColor = .black
            appearance.unselectedItemTintColor = .gray
        }
    }
}
