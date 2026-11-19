import SwiftUI

struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CustomerSession.self) private var session

    @State private var subject: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Issue") {
                    TextField("Subject", text: $subject)
                    TextEditor(text: $description)
                        .frame(minHeight: 120)
                }

                Section {
                    Button {
                        // TODO: send issue
                        dismiss()
                    } label: {
                        Label("Submit", systemImage: "paperplane.fill")
                    }
                    .disabled(subject.isEmpty || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Support")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    SupportView()
        .environment(CustomerSession())
}
