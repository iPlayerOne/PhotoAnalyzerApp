import SwiftUI

struct EmptyProjectsView: View {
    let onStartEditing: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundStyle(Color("AccentMint"))
            
            Text(AppStrings.Projects.emptyTitle)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(AppStrings.Projects.emptySubtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            PrimaryButton(title: AppStrings.Button.startEditing, isDisabled: false, action: onStartEditing)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding(.horizontal, 75)
    }
}

#Preview {
    EmptyProjectsView(onStartEditing: {})
}
