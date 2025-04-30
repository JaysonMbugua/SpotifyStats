import SwiftUI

struct UserPlaylistsView: View {
    let userId: String
    let token: String
    @State private var playlists: [SpotifyPlaylist] = []
    @State private var selectedPlaylist: SpotifyPlaylist?
    @State private var tracks: [SpotifyTrack] = []

    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section(header: Text("Public Playlists")) {
                        ForEach(playlists, id: \.id) { playlist in
                            Button(action: {
                                selectedPlaylist = playlist
                                fetchTracks(for: playlist)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(playlist.name)
                                        .foregroundColor(.primary)
                                    Text("\(playlist.tracks.total) tracks")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }

                    if let playlist = selectedPlaylist {
                        Section(header: Text("Tracks in \(playlist.name)")) {
                            ForEach(tracks, id: \.id) { track in
                                NavigationLink(destination: TrackDetailView(track: track)) {
                                    HStack {
                                        if let url = URL(string: track.album.images.first?.url ?? "") {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Color.gray
                                            }
                                            .frame(width: 60, height: 60)
                                            .cornerRadius(8)
                                        }

                                        VStack(alignment: .leading) {
                                            Text(track.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(track.artists.first?.name ?? "")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }

                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
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

    func fetchTracks(for playlist: SpotifyPlaylist) {
        SpotifyAPIService.fetchPlaylistTracks(playlistId: playlist.id, token: token) { fetchedTracks in
            DispatchQueue.main.async {
                self.tracks = fetchedTracks
            }
        }
    }
}
