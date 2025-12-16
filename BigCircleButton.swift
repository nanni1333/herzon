import SwiftUI

struct BigCircleButton: View {
    var icon: String
    var color: Color = .blue
    var size: CGFloat = 70

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.2))
                .frame(width: size, height: size)
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: size * 0.5, height: size * 0.5)
                .foregroundColor(color)
        }
    }
}

