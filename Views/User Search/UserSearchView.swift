import SwiftUI

struct UserSearchView: View {
    @ObservedObject var viewModel: SpotifyAuthViewModel
    @State private var searchText = ""
    @State private var searchedUser: SpotifyPublicUser?

    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white })
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    TextField("Enter Spotify User ID", text: $searchText)
                        .padding()
                        .background(Color(uiColor: UIColor.systemGray5))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    Button(action: {
                        SpotifyAPIService.fetchUserProfilePublic(userId: searchText, token: viewModel.accessToken) { user in
                            DispatchQueue.main.async {
                                self.searchedUser = user
                            }
                        }
                    }) {
                        Text("Search")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 29/255, green: 185/255, blue: 84/255))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    if let user = searchedUser {
                        VStack(spacing: 12) {
                            if let url = URL(string: user.images?.first?.url ?? "") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            }

                            Text(user.display_name ?? user.id)
                                .font(.title3)
                                .foregroundColor(.primary)

                            NavigationLink(destination: UserPlaylistsView(userId: user.id, token: viewModel.accessToken)) {
                                Text("View Public Playlists")
                                    .font(.subheadline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(uiColor: UIColor.systemGray5))
                                    .cornerRadius(8)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .background(Color(.darkGray))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top)
                .navigationTitle("Find Users")
            }
        }
    }
}
