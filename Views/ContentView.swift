import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SpotifyAuthViewModel()
    @State private var showLoginWebView = false

    var body: some View {
        if viewModel.isAuthorized {
            MainTabView(viewModel: viewModel)
        } else {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color(.systemGray6), Color(.darkGray)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 40) {
                    Spacer()

                    VStack(spacing: 10) {
                        Image(systemName: "music.note.list")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)

                        Text("SpotifyStatsViewer")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button("Login with Spotify") {
                        showLoginWebView = true
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .sheet(isPresented: $showLoginWebView) {
                    SpotifyLoginView(authURL: viewModel.authURL) { code in
                        viewModel.exchangeCodeForToken(code: code) {
                            showLoginWebView = false
                        }
                    }
                }
            }
        }
    }
}
