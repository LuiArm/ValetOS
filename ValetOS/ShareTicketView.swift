import SwiftUI

struct ShareTicketView: View {
    @Environment(CustomerSession.self) private var session

    private var shareText: String {
        "Here is my valet ticket: \(session.ticketNumber)"
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("Share your ticket")
                .font(.title3.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("You can share your ticket with someone who is picking up the vehicle or needs the reference number.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ShareLink(item: shareText) {
                Label("Share \(session.ticketNumber)", systemImage: "square.and.arrow.up")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(20)
        .background(Color.appBackground)
    }
}

#Preview {
    ShareTicketView()
        .environment(CustomerSession())
}
