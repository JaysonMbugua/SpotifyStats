import SwiftUI
import SwiftData

struct NowPlayingView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: SpotifyAuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            if let track = viewModel.currentlyPlaying {
                Text("Now Playing")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                //Now playing card
                VStack(spacing: 12) {
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
                        .font(.title2)
                        .foregroundColor(.white)

                    Text(track.artists.first?.name ?? "")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.darkGray))
                .cornerRadius(16)
                .padding(.horizontal)
            } else {
                Spacer()
                Text("Nothing playing right now 🎧")
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            self.viewModel.loadPlaybackData(with: modelContext)
        }
    }
}
