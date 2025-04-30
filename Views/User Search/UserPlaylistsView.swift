import SwiftUI

struct UserPlaylistsView: View {
    let userId: String
    let token: String
    @State private var playlists: [SpotifyPlaylist] = []

    var body: some View {
        NavigationStack {
            List(playlists, id: \.id) { playlist in
                NavigationLink(destination: PlaylistTracksView(playlist: playlist, token: token)) {
                    VStack(alignment: .leading) {
                        Text(playlist.name)
                            .foregroundColor(.primary)
                        Text("\(playlist.tracks.total) tracks")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Public Playlists")
            .onAppear {
                SpotifyAPIService.fetchUserPlaylists(userId: userId, token: token) { fetchedPlaylists in
                    DispatchQueue.main.async {
                        self.playlists = fetchedPlaylists
                    }
                }
            }
        }
    }
}
