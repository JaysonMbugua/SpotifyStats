import Foundation
import SwiftData

@Model
class RecentTrack {
    @Attribute(.unique) var id: String
    var name: String
    var artist: String
    var imageUrl: String
    var playedAt: Date

    init(id: String, name: String, artist: String, imageUrl: String, playedAt: Date) {
        self.id = id
        self.name = name
        self.artist = artist
        self.imageUrl = imageUrl
        self.playedAt = playedAt
    }
}
