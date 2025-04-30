import SwiftData
import SwiftUI

@main
struct SpotifyStatsViewerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        //.appShortcuts([ShowDashboardIntent()])
        .modelContainer(for: RecentTrack.self)
    }
}
