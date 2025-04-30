import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: SpotifyAuthViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = viewModel.userProfile {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Account")
                                .font(.headline)
                                .padding(.bottom, 4)

                            HStack(spacing: 16) {
                                if let url = URL(string: user.images?.first?.url ?? "") {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.display_name ?? "Spotify User")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    Text(user.email ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("App Info")
                            .font(.headline)
                            .padding(.bottom, 4)

                        Text("SpotifyStatsViewer")
                            .foregroundColor(.primary)
                        Text("Made with ❤️ for COMP 433")
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    Button(action: {
                        viewModel.isAuthorized = false
                        viewModel.accessToken = ""
                        viewModel.userProfile = nil
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
            .foregroundColor(.primary)
            .navigationBarBackButtonHidden(true)
        }
    }
}
