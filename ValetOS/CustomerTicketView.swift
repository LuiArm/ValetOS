import SwiftUI

/// C-03 Digital ticket / QR, C-04 Vehicle details (customer app)
struct CustomerTicketView: View {
    @Environment(CustomerSession.self) private var session
    @State private var showProgress = false

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                header
                ticketCard
                detailsCard
                paymentCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color.appBackground)
        .navigationTitle("Digital ticket")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showProgress) {
            CustomerProgressView()
        }
        .safeAreaInset(edge: .bottom) {
            actionArea
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
                .background(Color.white.ignoresSafeArea(edges: .bottom))
                .overlay(alignment: .top) { Divider() }
        }
    }

    // MARK: Pieces

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(session.companyName)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)
            Text(session.locationName)
                .font(.subheadline)
                .foregroundStyle(Color(hex: 0xD5DDEA))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.brandNavy, in: RoundedRectangle(cornerRadius: 16))
    }

    private var ticketCard: some View {
        VStack(spacing: 12) {
            StatusChip(session.status.chip)
            Text(session.ticketNumber)
                .font(.title2.weight(.bold))
                .foregroundStyle(Color.brandNavy)
            QRCodeView(text: session.ticketNumber)
                .frame(width: 148, height: 148)
            Text("Show this to the attendant when you pick up.")
                .font(.footnote)
                .foregroundStyle(Color.inkSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .card(padding: 20)
    }

    // The ticket never shows phone, email or internal notes (spec section 10).
    private var detailsCard: some View {
        VStack(spacing: 0) {
            InfoRow(label: "Vehicle", value: session.vehicle.title)
            Divider()
            InfoRow(label: "Plate", value: session.vehicle.plateLine)
        }
        .padding(.horizontal, 16)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.hairline))
    }

    private var paymentCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Amount due").font(.footnote).foregroundStyle(Color.inkSecondary)
                Text(session.amountDue).font(.title3.weight(.bold)).foregroundStyle(Color.brandNavy)
            }
            Spacer()
            StatusChip(session.payment.chip)
        }
        .card(padding: 16)
    }

    @ViewBuilder
    private var actionArea: some View {
        switch session.status {
        case .parked:
            Button("Request my vehicle") {
                session.requestRetrieval()
                showProgress = true
            }
            .buttonStyle(PrimaryButtonStyle(fill: .brandTeal))
        case .retrievalRequested, .retrieving, .readyForPickup:
            Button("View retrieval progress") { showProgress = true }
                .buttonStyle(PrimaryButtonStyle(fill: .brandTeal))
        case .completed:
            Text("All done. Thanks for using \(session.companyName).")
                .font(.subheadline)
                .foregroundStyle(Color.inkSecondary)
                .frame(maxWidth: .infinity, minHeight: 56)
        }
    }
}
