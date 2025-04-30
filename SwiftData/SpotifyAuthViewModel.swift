
import CryptoKit
import Foundation
import SwiftData
import SwiftUI

class SpotifyAuthViewModel: ObservableObject {
    @Published var isAuthorized = false
    @Published var authURL: URL!
    @Published var accessToken: String = ""

    @Published var userProfile: SpotifyUserProfile?
    @Published var topTracks: [SpotifyTrack] = []
    @Published var topArtists: [SpotifyArtist] = []
    @Published var currentlyPlaying: SpotifyTrack?
    @Published var recentlyPlayed: [SpotifyTrack] = []

    @Published var topTimeRange: String = "short_term"
    @Published var topGenres: [String] = []

    init() {
        prepareAuthURL()
    }

    func prepareAuthURL() {
        let clientID = "b1bff1df19ad45d2b3ecd5603c9c513b"
        let redirectURI = "https://jaysonmbugua.github.io/Spotify-auth/callback.html"
        let scope = "user-read-private user-read-email user-top-read user-read-playback-state user-read-recently-played"
        let codeVerifier = PKCEHelper.generateCodeVerifier()
        let codeChallenge = PKCEHelper.generateCodeChallenge(codeVerifier: codeVerifier)

        var components = URLComponents(string: "https://accounts.spotify.com/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "code_challenge_method", value: "S256"),
            URLQueryItem(name: "code_challenge", value: codeChallenge)
        ]

        authURL = components.url
    }

    func exchangeCodeForToken(code: String, completion: @escaping () -> Void) {
        let clientID = "b1bff1df19ad45d2b3ecd5603c9c513b"
        let redirectURI = "https://jaysonmbugua.github.io/Spotify-auth/callback.html"
        let tokenURL = URL(string: "https://accounts.spotify.com/api/token")!
        let codeVerifier = PKCEHelper.codeVerifier

        var request = URLRequest(url: tokenURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let bodyParams = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": redirectURI,
            "client_id": clientID,
            "code_verifier": codeVerifier
        ]

        request.httpBody = bodyParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&").data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data else {
                print("❌ Token exchange failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                struct TokenResponse: Codable {
                    let access_token: String
                    let token_type: String
                    let expires_in: Int
                }

                let tokenResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    self.accessToken = tokenResponse.access_token
                    print("✅ ACCESS TOKEN: \(self.accessToken)")
                    self.isAuthorized = true
                    self.loadUserData()
                    completion()
                }
            } catch {
                print("❌ Failed to decode token response: \(error)")
                print("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            }
        }.resume()
    }

    func loadUserData() {
        SpotifyAPIService.fetchUserProfile(token: accessToken) { user in
            DispatchQueue.main.async {
                self.userProfile = user
            }
        }

        SpotifyAPIService.fetchTopTracks(token: accessToken, timeRange: topTimeRange) { tracks in
            DispatchQueue.main.async {
                self.topTracks = tracks
            }
        }

        SpotifyAPIService.fetchTopArtists(token: accessToken, timeRange: topTimeRange) { artists in
            DispatchQueue.main.async {
                self.topArtists = artists
                let genreCounts = Dictionary(grouping: artists.flatMap { $0.genres ?? [] }, by: { $0 }).mapValues { $0.count }
                self.topGenres = genreCounts.sorted(by: { $0.value > $1.value }).prefix(5).map { $0.key }
            }
        }
    }

    func loadPlaybackData(with context: ModelContext) {
        SpotifyAPIService.fetchCurrentlyPlaying(token: accessToken) { track in
            DispatchQueue.main.async {
                self.currentlyPlaying = track
            }
        }

        SpotifyAPIService.fetchRecentlyPlayed(token: accessToken) { tracks in
            DispatchQueue.main.async {
                self.recentlyPlayed = tracks
                self.saveRecentTracksToSwiftData(tracks: tracks, context: context)
            }
        }
    }

    func saveRecentTracksToSwiftData(tracks: [SpotifyTrack], context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<RecentTrack>()
        if let existing = try? context.fetch(fetchDescriptor) {
            for track in existing {
                context.delete(track)
            }
        }

        for track in tracks {
            let newTrack = RecentTrack(
                id: track.id,
                name: track.name,
                artist: track.artists.first?.name ?? "Unknown",
                imageUrl: track.album.images.first?.url ?? "",
                playedAt: Date()
            )
            context.insert(newTrack)
        }
    }
}
