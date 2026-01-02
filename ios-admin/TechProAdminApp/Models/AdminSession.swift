import Foundation

@MainActor
final class AdminSession: ObservableObject {
    @Published var email: String = ""
    @Published var passcode: String = ""
    @Published var tickets: [Ticket] = []
    @Published var whitelist: [String] = []
    @Published var isAuthenticated = false
    @Published var loginError: String?
    @Published var isLoading = false

    private let api = AdminAPI()

    func login() async {
        isLoading = true
        loginError = nil
        do {
            let response = try await api.login(email: email, passcode: passcode)
            tickets = response.tickets
            whitelist = response.whitelist
            isAuthenticated = true
        } catch {
            loginError = "Login fallido. Verifica el email y el passcode."
            isAuthenticated = false
        }
        isLoading = false
    }

    func logout() {
        email = ""
        passcode = ""
        tickets = []
        whitelist = []
        isAuthenticated = false
        loginError = nil
    }

    func refreshTickets() async {
        guard isAuthenticated else { return }
        do {
            let response = try await api.login(email: email, passcode: passcode)
            tickets = response.tickets
            whitelist = response.whitelist
        } catch {
            loginError = "No se pudo actualizar la información."
        }
    }

    func updateStatus(ticket: Ticket, status: String) async {
        guard isAuthenticated else { return }
        do {
            let action = try await api.updateStatus(
                id: ticket.id,
                status: status,
                email: email,
                passcode: passcode
            )
            if action == .deleted {
                tickets.removeAll { $0.id == ticket.id }
            } else {
                if let index = tickets.firstIndex(where: { $0.id == ticket.id }) {
                    tickets[index].status = status
                    tickets[index].lastUpdate = Date()
                }
            }
        } catch {
            loginError = "No se pudo actualizar el estado."
        }
    }

    func addStaff(email newEmail: String) async {
        guard !newEmail.isEmpty, !whitelist.contains(newEmail) else { return }
        whitelist.append(newEmail)
        await syncStaff()
    }

    func removeStaff(email: String) async {
        guard whitelist.count > 1 else { return }
        whitelist.removeAll { $0 == email }
        await syncStaff()
    }

    private func syncStaff() async {
        guard isAuthenticated else { return }
        do {
            try await api.updateWhitelist(
                whitelist: whitelist,
                email: email,
                passcode: passcode
            )
        } catch {
            loginError = "No se pudo sincronizar el staff."
        }
    }
}
