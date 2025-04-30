import SwiftUI
import SwiftData

@main
struct SpotifyStatsViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RecentTrack.self)
    }
}
