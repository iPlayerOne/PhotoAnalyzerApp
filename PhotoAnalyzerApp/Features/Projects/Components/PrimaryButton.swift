import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
        }
        .disabled(isDisabled)
        .foregroundStyle(isDisabled ? .secondary : .primary)
        .background(
            Capsule()
                .fill(isDisabled ? Color.gray.opacity(0.35) : Color("AccentMint"))
        )
    }
}

#Preview {
    PrimaryButton(title: "Start editing", isDisabled: false) {
    }
}
