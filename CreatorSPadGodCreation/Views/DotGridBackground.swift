import SwiftUI

struct DotGridBackground: View {
    @Environment(\.colorScheme) private var colorScheme
    let dotSpacing: CGFloat = 20
    let dotRadius: CGFloat = 1.5

    var body: some View {
        Canvas { context, size in
            let dotColor = colorScheme == .dark
                ? Color(white: 0.3)
                : Color(white: 0.82)
            var x: CGFloat = dotSpacing
            while x < size.width {
                var y: CGFloat = dotSpacing
                while y < size.height {
                    let rect = CGRect(
                        x: x - dotRadius,
                        y: y - dotRadius,
                        width: dotRadius * 2,
                        height: dotRadius * 2
                    )
                    context.fill(Path(ellipseIn: rect), with: .color(dotColor))
                    y += dotSpacing
                }
                x += dotSpacing
            }
        }
        .allowsHitTesting(false)
    }
}
