import SwiftUI

struct RootView: View {
    @State private var session = CustomerSession()

    var body: some View {
        NavigationStack {
            CustomerHomeView()
        }
        .tint(Color.brandTeal)
        .environment(session)
    }
}
