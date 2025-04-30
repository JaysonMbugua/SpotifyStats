import SwiftData
import SwiftUI

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecentTrack.playedAt, order: .reverse) private var savedTracks: [RecentTrack]
    @ObservedObject var viewModel: SpotifyAuthViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Now Playing")
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    if let track = viewModel.currentlyPlaying {
                        HStack {
                            if let url = URL(string: track.album.images.first?.url ?? "") {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 100, height: 100)
                                .cornerRadius(12)
                            }

                            VStack(alignment: .leading) {
                                Text(track.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(track.artists.first?.name ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                    } else {
                        Text("Nothing is playing right now.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }

                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal)

                    Text("Recently Played (from SwiftData)")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding(.horizontal)

                    if savedTracks.isEmpty {
                        Text("No saved tracks yet.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(savedTracks.prefix(10), id: \.id) { recent in
                            NavigationLink(destination: TrackDetailView(track: mapRecentToSpotifyTrack(recent))) {
                                HStack {
                                    if let url = URL(string: recent.imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                    }

                                    VStack(alignment: .leading) {
                                        Text(recent.name)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        Text(recent.artist)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.darkGray))
                                .cornerRadius(12)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .refreshable {
                viewModel.loadPlaybackData(with: modelContext)
            }
            .background(Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white }))
            .onAppear {
                viewModel.loadPlaybackData(with: modelContext)
            }
            .navigationTitle("Library")
        }
    }

    private func mapRecentToSpotifyTrack(_ recent: RecentTrack) -> SpotifyTrack {
        return SpotifyTrack(
            id: recent.id,
            name: recent.name,
            popularity: 0,
            preview_url: nil,
            external_urls: [:],
            album: SpotifyAlbum(
                name: "Unknown Album",
                images: [SpotifyImage(url: recent.imageUrl)]
            ),
            artists: [SpotifyArtist(
                id: UUID().uuidString,
                name: recent.artist,
                genres: nil,
                images: nil
            )]
        )
    }
}
