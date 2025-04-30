import SwiftUI

struct PlaylistDetailView: View {
    let playlistId: String
    let token: String
    let playlistName: String

    @State private var tracks: [SpotifyTrack] = []
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView("Loading Tracks...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .padding()
                } else if tracks.isEmpty {
                    Text("No tracks found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(tracks) { track in
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(track.name)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                if let artistName = track.artists.first?.name {
                                    Text(artistName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray5).opacity(0.2))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
        .navigationTitle(playlistName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchTracks()
        }
    }

    private func fetchTracks() {
        SpotifyAPIService.fetchPlaylistTracks(playlistId: playlistId, token: token) { fetchedTracks in
            DispatchQueue.main.async {
                self.tracks = fetchedTracks
                self.isLoading = false
            }
        }
    }
}
