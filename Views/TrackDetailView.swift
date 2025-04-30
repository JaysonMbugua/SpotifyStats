import SwiftUI

struct TrackDetailView: View {
    let track: SpotifyTrack

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let url = URL(string: track.album.images.first?.url ?? "") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 200, height: 200)
                    .cornerRadius(12)
                }

                Text(track.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)

                Text(track.artists.map { $0.name }.joined(separator: ", "))
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("Album: \(track.album.name)")
                    .font(.subheadline)
                    .foregroundColor(.primary)

                if let previewURL = track.preview_url, let url = URL(string: previewURL) {
                    Link("Preview on Spotify", destination: url)
                        .padding(.top)
                }

                if let externalURL = URL(string: track.external_urls["spotify"] ?? "") {
                    Link("Open in Spotify", destination: externalURL)
                        .foregroundColor(.accentColor)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
        }
        .background(Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white }))
        .navigationTitle("Track Details")
    }
}
