import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: AdminSession

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Staff Login")
                    .font(.title)
                    .foregroundColor(.yellow)

                VStack(spacing: 12) {
                    TextField("Authorized Email", text: $session.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)

                    SecureField("Passcode", text: $session.passcode)
                        .textFieldStyle(.roundedBorder)
                }

                if let error = session.loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button {
                    Task { await session.login() }
                } label: {
                    if session.isLoading {
                        ProgressView()
                            .tint(.black)
                    } else {
                        Text("Enter Dashboard")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                .foregroundColor(.black)
                .disabled(session.email.isEmpty || session.passcode.isEmpty || session.isLoading)
            }
            .padding()
            .frame(maxWidth: 400)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AdminSession())
}
