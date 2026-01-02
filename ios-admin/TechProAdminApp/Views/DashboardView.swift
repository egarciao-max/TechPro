import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var session: AdminSession
    @State private var newStaffEmail = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Repair Manager") {
                    ForEach(session.tickets) { ticket in
                        TicketRow(ticket: ticket)
                    }
                }

                Section("Authorized Staff") {
                    ForEach(session.whitelist, id: \.self) { staff in
                        HStack {
                            Text(staff)
                            Spacer()
                            Button(role: .destructive) {
                                Task { await session.removeStaff(email: staff) }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                            .disabled(session.whitelist.count <= 1)
                        }
                    }

                    HStack {
                        TextField("Add Email", text: $newStaffEmail)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Button("Add") {
                            let trimmed = newStaffEmail.trimmingCharacters(in: .whitespacesAndNewlines)
                            Task {
                                await session.addStaff(email: trimmed)
                                newStaffEmail = ""
                            }
                        }
                        .disabled(newStaffEmail.isEmpty)
                    }
                }
            }
            .navigationTitle("Admin Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout", role: .destructive) {
                        session.logout()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        Task { await session.refreshTickets() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                await session.refreshTickets()
            }
        }
    }
}

private struct TicketRow: View {
    @EnvironmentObject private var session: AdminSession
    let ticket: Ticket

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(ticket.name)
                .font(.headline)
            Text("ID: \(ticket.id)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Picker("Status", selection: Binding(
                get: { ticket.status },
                set: { newStatus in
                    Task { await session.updateStatus(ticket: ticket, status: newStatus) }
                }
            )) {
                ForEach(Ticket.statuses, id: \.self) { status in
                    Text(status)
                }
            }
            .pickerStyle(.menu)

            Text("Last update: \(ticket.lastUpdate.formatted(date: .abbreviated, time: .shortened))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AdminSession())
}
