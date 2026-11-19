import SwiftUI

struct AddVehicleFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var make: String = ""
    @State private var model: String = ""
    @State private var color: String = ""
    @State private var plate: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Vehicle") {
                    TextField("Make", text: $make)
                    TextField("Model", text: $model)
                    TextField("Color", text: $color)
                    TextField("License Plate", text: $plate)
                        .textInputAutocapitalization(.characters)
                }
            }
            .navigationTitle("Add Vehicle")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { dismiss() }
                        .disabled(make.isEmpty || model.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddVehicleFormView()
}
