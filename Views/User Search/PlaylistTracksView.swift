import SwiftUI

struct PlaylistTracksView: View {
    let playlist: SpotifyPlaylist
    let token: String
    @State private var tracks: [SpotifyTrack] = []

    var body: some View {
        List(tracks, id: \.id) { track in
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
        .navigationTitle(playlist.name)
        .onAppear {
            SpotifyAPIService.fetchPlaylistTracks(playlistId: playlist.id, token: token) { fetchedTracks in
                DispatchQueue.main.async {
                    self.tracks = fetchedTracks
                }
            }
        }
    }
}
