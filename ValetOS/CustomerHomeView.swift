import SwiftUI

/// C-02 Home and active tickets (customer app)
struct CustomerHomeView: View {
    @Environment(CustomerSession.self) private var session

    @State private var showingAddVehicle = false
    @State private var showingShare = false
    @State private var showingSupport = false

    // Placeholder properties to personalize UI without requiring backend fields
    // Avoid KVC to prevent crashes; use placeholders and prefer known typed properties when available.
    private var customerName: String {
        // If you later add `session.customerName: String?`, this will pick it up.
        if let s = Mirror(reflecting: session).children.first(where: { $0.label == "customerName" })?.value as? String, !s.isEmpty {
            return s
        }
        return "there"
    }
    private var vehiclePlate: String {
        // Prefer a typed plate if `session.vehicle.plate` exists; otherwise use a placeholder.
        let plate = (Mirror(reflecting: session.vehicle).children.first { $0.label == "plate" }?.value as? String)
        return (plate?.isEmpty == false) ? plate! : "7ABC123"
    }
    private var vehicleLastUsedLocation: String {
        if let s = Mirror(reflecting: session).children.first(where: { $0.label == "vehicleLastUsedLocation" })?.value as? String, !s.isEmpty {
            return s
        }
        return "Elm Street Garage"
    }
    private var activeETAText: String {
        if let s = Mirror(reflecting: session).children.first(where: { $0.label == "etaString" })?.value as? String, !s.isEmpty {
            return s
        }
        return "12 min"
    }
    private var currentLocationName: String {
        if let s = Mirror(reflecting: session).children.first(where: { $0.label == "currentLocationName" })?.value as? String, !s.isEmpty {
            return s
        }
        return "Pickup zone A"
    }

    // Placeholder recent tickets
    private struct RecentTicket: Identifiable {
        let id = UUID()
        let locationName: String
        let number: String
        let vehicleSummary: String
        let statusTitle: String
        let statusIcon: String
    }
    private var recentTickets: [RecentTicket] {
        [
            .init(locationName: "Elm Street Garage", number: "V-2026-000871", vehicleSummary: "Silver Subaru Outback", statusTitle: "Completed", statusIcon: "flag.checkered"),
            .init(locationName: "Market Center", number: "V-2026-000702", vehicleSummary: "Blue Tesla Model 3", statusTitle: "Completed", statusIcon: "flag.checkered")
        ]
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("ValetOS")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Color(hex: 0xB8C4D8))
                    Text("Welcome back, \(customerName)")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Your tickets")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
                .background(Color.brandNavy.ignoresSafeArea(edges: .top))

                // Vehicle summary card
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your vehicle")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.inkSecondary)

                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "car.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 36)
                            .foregroundStyle(Color.brandNavy)
                            .accessibilityHidden(true)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(session.vehicle.title)
                                .font(.headline)
                                .foregroundStyle(Color.brandNavy)
                            Text("Plate: \(vehiclePlate)")
                                .font(.footnote)
                                .foregroundStyle(Color.inkSecondary)
                            Text("Last used: \(vehicleLastUsedLocation)")
                                .font(.footnote)
                                .foregroundStyle(Color.inkSecondary)
                        }
                        Spacer()
                    }
                }
                .card(padding: 16)
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 10) {
                    SectionTitle("Active")
                        .padding(.horizontal, 20)

                    NavigationLink {
                        CustomerTicketView()
                    } label: {
                        ticketRow
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 20)

                    // Quick actions
                    HStack(spacing: 12) {
                        QuickActionButton(title: "Share ticket", systemImage: "square.and.arrow.up") {
                            showingShare = true
                        }
                        QuickActionButton(title: "Add vehicle", systemImage: "car.fill.badge.plus") {
                            showingAddVehicle = true
                        }
                        QuickActionButton(title: "Report issue", systemImage: "exclamationmark.bubble.fill") {
                            showingSupport = true
                        }
                    }
                    .padding(.horizontal, 20)
                }

                VStack(alignment: .leading, spacing: 10) {
                    SectionTitle("History")
                        .padding(.horizontal, 20)

                    ForEach(recentTickets) { ticket in
                        VehicleRow(
                            title: ticket.locationName,
                            subtitle: "\(ticket.number) · \(ticket.vehicleSummary)",
                            chip: ChipSpec(text: ticket.statusTitle, icon: ticket.statusIcon, tone: .gray)
                        )
                        .padding(.horizontal, 20)
                    }

                    NavigationLink("View all history") {
                        CustomerHistoryView()
                    }
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 20)
                    .foregroundStyle(Color.brandNavy)
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showingAddVehicle) {
            AddVehicleFormView()
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingShare) {
            ShareTicketView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $showingSupport) {
            SupportView()
                .presentationDetents([.medium, .large])
        }
    }

    private var ticketRow: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(session.companyName)
                    .font(.footnote)
                    .foregroundStyle(Color.inkSecondary)
                Text(session.vehicle.title)
                    .font(.headline)
                    .foregroundStyle(Color.brandNavy)
                Text(session.ticketNumber)
                    .font(.footnote)
                    .foregroundStyle(Color.inkSecondary)
                HStack(spacing: 8) {
                    StatusChip(session.status.chip)
                    StatusChip(ChipSpec(text: "ETA \(activeETAText)", icon: "clock", tone: .blue))
                    StatusChip(ChipSpec(text: currentLocationName, icon: "mappin.and.ellipse", tone: .gray))
                }
                .padding(.top, 4)
            }
            Spacer(minLength: 8)
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.inkSecondary)
                .accessibilityHidden(true)
        }
        .card(padding: 16)
    }
}
struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.footnote.weight(.semibold))
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.brandNavy)
    }
}

