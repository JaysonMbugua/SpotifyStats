import AppIntents

struct ShowDashboardIntent: AppIntent {
    static var title: LocalizedStringResource = "Show Dashboard"
    static var description = IntentDescription("Open the SpotifyStatsViewer dashboard")

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct SpotifyShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        return [
            AppShortcut(
                intent: ShowDashboardIntent(),
                phrases: [
                    "Show my ${applicationName} dashboard",
                    "Open top tracks in ${applicationName}",
                    "Launch ${applicationName}"
                ],

                shortTitle: "Show Dashboard",
                systemImageName: "music.note.list"
            )
        ]
    }
}
