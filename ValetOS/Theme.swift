import SwiftUI

// MARK: - Colors (spec section 11: deep navy, teal accent, light neutral background)

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    static let brandNavy = Color(hex: 0x12254A)
    static let brandTeal = Color(hex: 0x0B7A6E)
    static let tealTint = Color(hex: 0xDDF3EF)
    static let appBackground = Color(hex: 0xF4F6F8)
    static let hairline = Color(hex: 0xE2E7EE)
    static let fieldBorder = Color(hex: 0xC9D2DE)
    static let inkSecondary = Color(hex: 0x4A5A75)
}

// MARK: - Status chips (text + icon + color, never color alone)

enum Tone {
    case amber, blue, green, gray

    var fg: Color {
        switch self {
        case .amber: return Color(hex: 0x7A4300)
        case .blue: return Color(hex: 0x0B4A94)
        case .green: return Color(hex: 0x0B6B3A)
        case .gray: return Color(hex: 0x3E4C63)
        }
    }

    var bg: Color {
        switch self {
        case .amber: return Color(hex: 0xFFF0D4)
        case .blue: return Color(hex: 0xE2EDFB)
        case .green: return Color(hex: 0xDCF4E4)
        case .gray: return Color(hex: 0xE8ECF2)
        }
    }
}

struct ChipSpec {
    let text: String
    let icon: String
    let tone: Tone
}

struct StatusChip: View {
    let text: String
    let icon: String
    let tone: Tone

    init(_ spec: ChipSpec) {
        self.text = spec.text
        self.icon = spec.icon
        self.tone = spec.tone
    }

    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption.weight(.semibold))
            .foregroundStyle(tone.fg)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(tone.bg, in: Capsule())
    }
}

// MARK: - Cards and buttons

extension View {
    func card(padding: CGFloat = 14) -> some View {
        self
            .padding(padding)
            .background(Color.white, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.hairline))
    }
}

private struct ButtonLabel: View {
    let configuration: ButtonStyleConfiguration
    let fill: Color
    let foreground: Color
    let outlined: Bool
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 56)
            .foregroundStyle(isEnabled ? foreground : Color.inkSecondary)
            .background(
                isEnabled ? fill : Color(hex: 0xE8ECF2),
                in: RoundedRectangle(cornerRadius: 16)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(outlined ? Color.fieldBorder : Color.clear, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var fill: Color = .brandNavy

    func makeBody(configuration: Configuration) -> some View {
        ButtonLabel(configuration: configuration, fill: fill, foreground: .white, outlined: false)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        ButtonLabel(configuration: configuration, fill: .white, foreground: .brandNavy, outlined: true)
    }
}

// MARK: - Shared building blocks

struct SectionTitle: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.inkSecondary)
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label).foregroundStyle(Color.inkSecondary)
            Spacer()
            Text(value).fontWeight(.semibold).foregroundStyle(Color.brandNavy)
        }
        .font(.subheadline)
        .frame(minHeight: 44)
    }
}

struct VehicleRow: View {
    let title: String
    let subtitle: String
    var chip: ChipSpec? = nil

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.brandNavy)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color.inkSecondary)
            }
            Spacer(minLength: 8)
            if let chip {
                StatusChip(chip)
            }
        }
        .frame(minHeight: 44)
        .card()
    }
}

struct LabeledField: View {
    let title: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default
    var capitalization: TextInputAutocapitalization = .words

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Color.inkSecondary)
            TextField("", text: $text)
                .keyboardType(keyboard)
                .textInputAutocapitalization(capitalization)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .frame(minHeight: 52)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.fieldBorder))
                .accessibilityLabel(title)
        }
    }
}
