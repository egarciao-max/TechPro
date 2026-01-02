import SwiftUI

@main
struct TechProAdminAppApp: App {
    @StateObject private var session = AdminSession()

    var body: some Scene {
        WindowGroup {
            if session.isAuthenticated {
                DashboardView()
                    .environmentObject(session)
            } else {
                LoginView()
                    .environmentObject(session)
            }
        }
    }
}
