import SwiftUI
import Observation

// MARK: - Domain types (customer's view of a parking session)

struct Vehicle {
    var plate: String
    var region: String
    var make: String
    var model: String
    var color: String

    var title: String { "\(color) \(make) \(model)" }
    var plateLine: String { "\(region) \(plate)" }

    static let sample = Vehicle(plate: "ABC123", region: "NH", make: "Honda", model: "Accord", color: "Black")
}

/// Operational status. Kept separate from payment status (spec principle 2).
enum OperationalStatus {
    case parked, retrievalRequested, retrieving, readyForPickup, completed

    var chip: ChipSpec {
        switch self {
        case .parked: return ChipSpec(text: "Parked", icon: "checkmark.circle", tone: .green)
        case .retrievalRequested: return ChipSpec(text: "Retrieval requested", icon: "arrow.down.to.line", tone: .blue)
        case .retrieving: return ChipSpec(text: "Retrieving", icon: "arrow.right", tone: .amber)
        case .readyForPickup: return ChipSpec(text: "Ready for pickup", icon: "checkmark.circle", tone: .green)
        case .completed: return ChipSpec(text: "Completed", icon: "flag.checkered", tone: .gray)
        }
    }
}

enum PaymentStatus {
    case unpaid, paid

    var chip: ChipSpec {
        switch self {
        case .unpaid: return ChipSpec(text: "Unpaid", icon: "creditcard", tone: .amber)
        case .paid: return ChipSpec(text: "Paid", icon: "checkmark", tone: .green)
        }
    }
}

// MARK: - Session

/// The customer's one active ticket. In production this comes from the backend and updates in real time.
/// Here it is local sample data, with `advanceDemo()` standing in for the attendant's actions.
@Observable
final class CustomerSession {
    var status: OperationalStatus = .parked
    var payment: PaymentStatus = .unpaid
    var retrievalAccepted = false

    let vehicle = Vehicle.sample
    let ticketNumber = "V-2026-001234"
    let companyName = "Granite State Valet"
    let locationName = "Elm Street Garage"
    let amountDue = "$18.00"

    func requestRetrieval() {
        guard status == .parked else { return }
        retrievalAccepted = false
        status = .retrievalRequested
    }

    func pay() {
        payment = .paid
    }

    func reset() {
        status = .parked
        payment = .unpaid
        retrievalAccepted = false
    }

    // MARK: Demo stand-in for the attendant app

    var demoTitle: String? {
        switch status {
        case .parked: return nil
        case .retrievalRequested: return retrievalAccepted ? "Demo: attendant starts retrieving" : "Demo: attendant accepts request"
        case .retrieving: return "Demo: attendant marks ready for pickup"
        case .readyForPickup: return "Demo: attendant completes handoff"
        case .completed: return "Demo: start over"
        }
    }

    func advanceDemo() {
        switch status {
        case .parked:
            break
        case .retrievalRequested:
            if retrievalAccepted {
                status = .retrieving
            } else {
                retrievalAccepted = true
            }
        case .retrieving:
            status = .readyForPickup
        case .readyForPickup:
            status = .completed
        case .completed:
            reset()
        }
    }
}
