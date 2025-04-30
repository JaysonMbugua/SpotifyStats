import SwiftUI
import SwiftData

struct RecentlyPlayedView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecentTrack.playedAt, order: .reverse) private var savedTracks: [RecentTrack]
    @ObservedObject var viewModel: SpotifyAuthViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recently Played")
                .font(.largeTitle)
                .padding(.horizontal)

            if savedTracks.isEmpty {
                Spacer()
                Text("No saved tracks yet.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(savedTracks.prefix(10), id: \.id) { track in
                            HStack(spacing: 12) {
                                if let url = URL(string: track.imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                                }

                                VStack(alignment: .leading) {
                                    Text(track.name)
                                        .font(.headline)
                                    Text(track.artist)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.loadPlaybackData(with: modelContext)
        }
    }
}
