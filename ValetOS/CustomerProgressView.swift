import SwiftUI

/// C-06 Retrieval progress (customer app)
struct CustomerProgressView: View {
    @Environment(CustomerSession.self) private var session

    /// Index of the step currently in progress. Steps before it are done.
    private var currentStep: Int {
        switch session.status {
        case .retrievalRequested, .retrieving: return 1
        case .readyForPickup: return 2
        case .completed: return 4
        case .parked: return 0
        }
    }

    private var headline: String {
        switch session.status {
        case .retrievalRequested:
            return session.retrievalAccepted ? "An attendant is bringing your car" : "Request sent, waiting for an attendant"
        case .retrieving: return "An attendant is bringing your car"
        case .readyForPickup: return "Your car is ready"
        case .completed: return "Handoff complete"
        case .parked: return "Your vehicle is parked"
        }
    }

    private var detail: String {
        switch session.status {
        case .readyForPickup: return "Head to the pickup area and show your ticket to the attendant."
        case .completed: return "Thanks for using \(session.companyName)."
        default: return "\(session.vehicle.title) · \(session.vehicle.plateLine). We'll notify you when it's ready at the pickup area."
        }
    }

    private var steps: [(title: String, subtitle: String)] {
        let retrievingNote: String
        switch session.status {
        case .retrievalRequested:
            retrievingNote = session.retrievalAccepted ? "Jordan R. accepted" : "Waiting for an attendant"
        case .retrieving:
            retrievingNote = "Jordan R. is on the way with your car"
        default:
            retrievingNote = "Next"
        }
        return [
            ("Request sent", "Done"),
            ("Attendant retrieving your car", retrievingNote),
            ("Ready for pickup", "Up next"),
            ("Handoff", "Show your ticket to the attendant")
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    StatusChip(session.status.chip)
                    Text(headline)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 4)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(Color(hex: 0xD5DDEA))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(Color.brandNavy, in: RoundedRectangle(cornerRadius: 18))

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                        stepRow(index: index, title: step.title, subtitle: step.subtitle)
                    }
                }
                .padding(16)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.hairline))

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Amount due").font(.footnote).foregroundStyle(Color.inkSecondary)
                        Text(session.amountDue).font(.title3.weight(.bold)).foregroundStyle(Color.brandNavy)
                    }
                    Spacer()
                    if session.payment == .unpaid {
                        Button("Pay now") { session.pay() }
                            .buttonStyle(PrimaryButtonStyle(fill: .brandTeal))
                            .frame(width: 130)
                    } else {
                        StatusChip(session.payment.chip)
                    }
                }
                .card(padding: 16)

                if session.payment == .unpaid {
                    Text("You can also pay the attendant at pickup.")
                        .font(.footnote)
                        .foregroundStyle(Color.inkSecondary)
                        .frame(maxWidth: .infinity)
                }

                if let demoTitle = session.demoTitle {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Demo only")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Color.inkSecondary)
                        Text("In the real app, these updates arrive when the attendant acts in their app.")
                            .font(.footnote)
                            .foregroundStyle(Color.inkSecondary)
                        Button(demoTitle) { session.advanceDemo() }
                            .buttonStyle(SecondaryButtonStyle())
                    }
                    .padding(.top, 8)
                }
            }
            .padding(20)
        }
        .background(Color.appBackground)
        .navigationTitle("Your vehicle")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stepRow(index: Int, title: String, subtitle: String) -> some View {
        let isDone = index < currentStep
        let isCurrent = index == currentStep
        let isLast = index == steps.count - 1

        return HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(isDone ? Color.brandTeal : Color.white)
                        .frame(width: 28, height: 28)
                    Circle()
                        .strokeBorder(
                            isDone || isCurrent ? Color.brandTeal : Color.inkSecondary,
                            lineWidth: isCurrent ? 3 : 2
                        )
                        .frame(width: 28, height: 28)
                    if isDone {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                    }
                }
                if !isLast {
                    Rectangle()
                        .fill(isDone ? Color.brandTeal : Color.fieldBorder)
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isDone || isCurrent ? Color.brandNavy : Color.inkSecondary)
                Text(isDone ? "Done" : subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color.inkSecondary)
            }
            .padding(.bottom, isLast ? 0 : 18)
            Spacer(minLength: 0)
        }
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(isDone ? "Done" : (isCurrent ? "In progress. \(subtitle)" : subtitle))")
    }
}
