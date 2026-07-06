import SwiftUI

struct BottomTaskBar: View {
    let countText: String
    var onAdd: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Text(countText)
                .font(.footnote)
                .foregroundStyle(AppTheme.secondaryText)
            Spacer()
        }
        .padding(.top, 6)
        .padding(.bottom, 8)
        .overlay(alignment: .trailing) {
            Button(action: onAdd) {
                Image(systemName: "square.and.pencil")
                    .font(.title2)
                    .foregroundStyle(AppTheme.accent)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)

                AppTheme.background.opacity(0.45)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}
