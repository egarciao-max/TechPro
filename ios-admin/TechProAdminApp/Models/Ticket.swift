import Foundation

struct Ticket: Identifiable, Codable {
    let id: String
    let name: String
    var status: String
    var lastUpdate: Date
}

extension Ticket {
    static let statuses = [
        "Received",
        "In Progress",
        "Waiting for Parts",
        "Ready for Pickup",
        "Completed"
    ]
}
