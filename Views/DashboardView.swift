import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: SpotifyAuthViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let user = viewModel.userProfile {
                        HStack {
                            if let imageUrl = user.images?.first?.url,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            }

                            Text("Hi, \(user.display_name ?? "Spotify User")")
                                .font(.custom("BubblegumSans-Regular", size: 24))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal)
                    }

                    Picker("Time Range", selection: $viewModel.topTimeRange) {
                        Text("Week").tag("short_term")
                        Text("Month").tag("medium_term")
                        Text("Year").tag("long_term")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .onChange(of: viewModel.topTimeRange) { _ in
                        viewModel.loadUserData()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top Tracks")
                            .font(.custom("BubblegumSans-Regular", size: 20))
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        ForEach(viewModel.topTracks.prefix(5), id: \.id) { track in
                            NavigationLink(destination: TrackDetailView(track: track)) {
                                HStack {
                                    if let url = URL(string: track.album.images.first?.url ?? "") {
                                        AsyncImage(url: url) { image in
                                            image.resizable()
                                        } placeholder: {
                                            Color.white
                                        }
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(8)
                                    }

                                    VStack(alignment: .leading) {
                                        Text(track.name)
                                            .font(.custom("BubblegumSans-Regular", size: 16))
                                            .foregroundColor(.primary)
                                        Text(track.artists.first?.name ?? "")
                                            .font(.custom("BubblegumSans-Regular", size: 12))
                                            .foregroundColor(.primary)
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

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Top Artists")
                            .font(.custom("BubblegumSans-Regular", size: 20))
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.topArtists.prefix(10), id: \.id) { artist in
                                    VStack {
                                        if let url = URL(string: artist.images?.first?.url ?? "") {
                                            AsyncImage(url: url) { image in
                                                image.resizable()
                                            } placeholder: {
                                                Color.white
                                            }
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                        }
                                        Text(artist.name)
                                            .font(.custom("BubblegumSans-Regular", size: 12))
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: 70)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .refreshable {
                viewModel.loadUserData()
            }
            .background(Color(UIColor { $0.userInterfaceStyle == .dark ? .black : .white }))
            .navigationTitle("Dashboard")
        }
    }
}
