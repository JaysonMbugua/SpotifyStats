import Foundation

// MARK: - Shared models

struct SpotifyUserProfile: Codable {
    let id: String
    let display_name: String?
    let email: String?
    let images: [SpotifyImage]?
}

struct SpotifyImage: Codable {
    let url: String
}

struct SpotifyArtist: Codable, Identifiable {
    let id: String
    let name: String
    let genres: [String]?
    let images: [SpotifyImage]?
}

struct SpotifyTrack: Codable, Identifiable {
    let id: String
    let name: String
    let popularity: Int?
    let preview_url: String?
    let external_urls: [String: String]
    let album: SpotifyAlbum
    let artists: [SpotifyArtist]
}

struct SpotifyAlbum: Codable {
    let name: String
    let images: [SpotifyImage]
}

struct SpotifyItemsResponse<T: Codable>: Codable {
    let items: [T]
}

// MARK: - Public user & playlist

struct SpotifyPublicUser: Codable {
    let id: String
    let display_name: String?
    let images: [SpotifyImage]?
}

struct SpotifyPlaylist: Codable, Identifiable {
    let id: String
    let name: String
    let images: [SpotifyImage]?
    let tracks: PlaylistTrackInfo
}

struct PlaylistTrackInfo: Codable {
    let total: Int
}

// MARK: - Playlist Track List Response

struct PlaylistTracksResponse: Codable {
    let items: [PlaylistTrackItem]
}

struct PlaylistTrackItem: Codable {
    let track: SpotifyTrack
}

// MARK: - Playback Responses

struct CurrentlyPlayingWrapper: Codable {
    let item: SpotifyTrack?
}

struct RecentlyPlayedResponse: Codable {
    let items: [RecentlyPlayedItem]
}

struct RecentlyPlayedItem: Codable {
    let track: SpotifyTrack
}

// MARK: - API Service

enum SpotifyAPIService {
    
    static func fetchUserProfile(token: String, completion: @escaping (SpotifyUserProfile?) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/me")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let profile = try JSONDecoder().decode(SpotifyUserProfile.self, from: data)
                completion(profile)
            } catch {
                print("❌ Failed to decode user profile: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    static func fetchTopTracks(token: String, timeRange: String, completion: @escaping ([SpotifyTrack]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/me/top/tracks?limit=10&time_range=\(timeRange)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SpotifyItemsResponse<SpotifyTrack>.self, from: data)
                completion(response.items)
            } catch {
                print("❌ Failed to decode top tracks: \(error)")
                completion([])
            }
        }.resume()
    }
    
    static func fetchTopArtists(token: String, timeRange: String, completion: @escaping ([SpotifyArtist]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/me/top/artists?limit=10&time_range=\(timeRange)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SpotifyItemsResponse<SpotifyArtist>.self, from: data)
                completion(response.items)
            } catch {
                print("❌ Failed to decode top artists: \(error)")
                completion([])
            }
        }.resume()
    }
    
    static func fetchUserProfilePublic(userId: String, token: String, completion: @escaping (SpotifyPublicUser?) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/users/\(userId)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let user = try JSONDecoder().decode(SpotifyPublicUser.self, from: data)
                completion(user)
            } catch {
                print("❌ Failed to decode public user: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    static func fetchUserPlaylists(userId: String, token: String, completion: @escaping ([SpotifyPlaylist]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/users/\(userId)/playlists")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SpotifyItemsResponse<SpotifyPlaylist>.self, from: data)
                completion(response.items)
            } catch {
                print("❌ Failed to decode playlists: \(error)")
                completion([])
            }
        }.resume()
    }
    
    static func fetchPlaylistTracks(playlistId: String, token: String, completion: @escaping ([SpotifyTrack]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/playlists/\(playlistId)/tracks")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("❌ No data received")
                completion([])
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(PlaylistTracksResponse.self, from: data)
                let tracks = decoded.items.map { $0.track }
                completion(tracks)
            } catch {
                print("❌ Failed to decode playlist tracks: \(error)")
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("❓ Raw response:\n\(jsonString)")
                }
                completion([])
            }
        }.resume()
    }
    
    static func fetchCurrentlyPlaying(token: String, completion: @escaping (SpotifyTrack?) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/me/player/currently-playing")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data, data.count > 0 else {
                completion(nil)
                return
            }
            
            do {
                let wrapper = try JSONDecoder().decode(CurrentlyPlayingWrapper.self, from: data)
                completion(wrapper.item)
            } catch {
                print("❌ Failed to decode currently playing: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    static func fetchRecentlyPlayed(token: String, completion: @escaping ([SpotifyTrack]) -> Void) {
        let url = URL(string: "https://api.spotify.com/v1/me/player/recently-played?limit=10")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let response = try JSONDecoder().decode(RecentlyPlayedResponse.self, from: data)
                let tracks = response.items.map { $0.track }
                completion(tracks)
            } catch {
                print("❌ Failed to decode recently played: \(error)")
                completion([])
            }
        }.resume()
    }
    
    // MARK: - Widget-specific Fetch
    
    /*static func fetchTopArtistForWidget(token: String, completion: @escaping (TopArtist?) -> Void) {
     fetchTopArtists(token: token, timeRange: "short_term") { artists in
     guard let topArtist = artists.first else {
     completion(nil)
     return
     }
     let artist = TopArtist(
     name: topArtist.name,
     imageURL: topArtist.images?.first.flatMap { URL(string: $0.url) }
     )
     completion(artist)
     }
     }
     
     }*/}
