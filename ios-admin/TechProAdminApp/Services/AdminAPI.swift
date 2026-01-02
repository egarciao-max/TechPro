import Foundation

struct AdminLoginResponse: Decodable {
    let tickets: [Ticket]
    let whitelist: [String]
}

enum TicketAction: String, Decodable {
    case updated
    case deleted
}

private struct TicketActionResponse: Decodable {
    let action: TicketAction
}

final class AdminAPI {
    private let baseURL = URL(string: "https://booking-handler.techprokelowna.workers.dev")!

    func login(email: String, passcode: String) async throws -> AdminLoginResponse {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "passcode", value: passcode),
            URLQueryItem(name: "email", value: email)
        ]
        guard let url = components?.url else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return try decoder.decode(AdminLoginResponse.self, from: data)
    }

    func updateStatus(id: String, status: String, email: String, passcode: String) async throws -> TicketAction {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode([
            "id": id,
            "newStatus": status,
            "passcode": passcode,
            "email": email
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let actionResponse = try JSONDecoder().decode(TicketActionResponse.self, from: data)
        return actionResponse.action
    }

    func updateWhitelist(whitelist: [String], email: String, passcode: String) async throws {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode([
            "action": "updateWhitelist",
            "newList": whitelist,
            "passcode": passcode,
            "email": email
        ])

        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
}
