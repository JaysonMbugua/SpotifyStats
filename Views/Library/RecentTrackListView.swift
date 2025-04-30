import SwiftData
import SwiftUI

struct RecentTrackListView: View {
    @Query(sort: \RecentTrack.playedAt, order: .reverse) var recentTracks: [RecentTrack]

    var body: some View {
        NavigationStack {
            List(recentTracks) { track in
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: track.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(track.name)
                            .font(.headline)
                        Text(track.artist)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(track.playedAt.formatted(.dateTime))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Recently Played")
        }
    }
}
