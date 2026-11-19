import SwiftUI

struct CustomerHistoryView: View {
    @Environment(CustomerSession.self) private var session

    private struct HistoryItem: Identifiable {
        let id = UUID()
        let locationName: String
        let number: String
        let vehicleSummary: String
        let dateString: String
    }

    private var items: [HistoryItem] = [
        .init(locationName: "Elm Street Garage", number: "V-2026-000871", vehicleSummary: "Silver Subaru Outback", dateString: "Oct 12, 2026 · 5:42 PM"),
        .init(locationName: "Market Center", number: "V-2026-000702", vehicleSummary: "Blue Tesla Model 3", dateString: "Oct 3, 2026 · 2:15 PM"),
        .init(locationName: "Union Plaza", number: "V-2026-000511", vehicleSummary: "Black BMW X5", dateString: "Sep 22, 2026 · 7:03 PM")
    ]

    var body: some View {
        List {
            Section {
                ForEach(items) { item in
                    VehicleRow(
                        title: item.locationName,
                        subtitle: "\(item.number) · \(item.vehicleSummary)",
                        chip: ChipSpec(text: item.dateString, icon: "calendar", tone: .gray)
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            } header: {
                SectionTitle("History")
                    .padding(.top, 4)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .toolbar(.visible, for: .navigationBar)
    }
}

struct HistoryTicketsView: View {
    
    private struct Ticket: Identifiable {
        let id = UUID()
        let locationName: String
        let number: String
        let vehicleSummary: String
        let dateString: String
    }
    
    private let tickets: [Ticket] = [
        .init(locationName: "Central Station", number: "HIST-0001", vehicleSummary: "Red Honda Civic", dateString: "Nov 10, 2026 · 3:21 PM"),
        .init(locationName: "Downtown Lot", number: "HIST-0002", vehicleSummary: "White Ford F-150", dateString: "Nov 8, 2026 · 11:45 AM"),
        .init(locationName: "Airport Parking", number: "HIST-0003", vehicleSummary: "Green Toyota Prius", dateString: "Nov 5, 2026 · 9:30 AM")
    ]
    
    var body: some View {
        List {
            Section {
                ForEach(tickets) { ticket in
                    VehicleRow(
                        title: ticket.locationName,
                        subtitle: "\(ticket.number) · \(ticket.vehicleSummary)",
                        chip: ChipSpec(text: ticket.dateString, icon: "calendar", tone: .gray)
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            } header: {
                SectionTitle("Historical Tickets")
                    .padding(.top, 4)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .toolbar(.visible, for: .navigationBar)
    }
}

#Preview {
    HistoryTicketsView()
}
