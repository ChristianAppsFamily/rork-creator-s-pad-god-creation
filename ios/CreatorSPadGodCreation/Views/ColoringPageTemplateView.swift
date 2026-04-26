import SwiftUI

struct ColoringPageTemplateView: View {
    let page: ColoringPage
    var showsTitle: Bool = true

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                Color.white

                RoundedRectangle(cornerRadius: 28)
                    .stroke(.black, lineWidth: 4)
                    .padding(24)

                sceneContent(size: size)

                if showsTitle {
                    VStack(spacing: 4) {
                        Spacer()
                        Text(page.title.uppercased())
                            .font(.system(size: max(16, size.width * 0.035), weight: .bold, design: .rounded))
                        Text(page.scriptureReference)
                            .font(.system(size: max(12, size.width * 0.025), weight: .semibold, design: .serif))
                    }
                    .foregroundStyle(.black)
                    .padding(.bottom, 44)
                }
            }
            .foregroundStyle(.black)
        }
        .aspectRatio(3 / 4, contentMode: .fit)
        .accessibilityLabel("\(page.title) coloring page")
    }

    @ViewBuilder
    private func sceneContent(size: CGSize) -> some View {
        switch page.id {
        case "noahs-ark":
            arkScene
        case "daniel-lions-den":
            lionsDenScene
        case "garden-of-eden":
            gardenScene
        case "samson-lion":
            samsonScene
        case "david-shepherd":
            shepherdScene
        case "jonah-big-fish":
            fishScene
        case "baby-moses-river":
            riverScene
        case "eden-animal-garden":
            gardenAnimalsScene
        default:
            creationScene
        }
    }

    private var creationScene: some View {
        VStack(spacing: 26) {
            HStack(spacing: 34) {
                outlinedSymbol("sun.max", size: 64)
                outlinedSymbol("bird", size: 58)
                outlinedSymbol("cloud", size: 64)
            }
            HStack(spacing: 28) {
                outlinedSymbol("fish", size: 70)
                outlinedSymbol("pawprint", size: 72)
                outlinedSymbol("tortoise", size: 70)
            }
            GardenGroundLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 70)
        }
        .padding(.horizontal, 54)
    }

    private var arkScene: some View {
        VStack(spacing: 18) {
            outlinedSymbol("rainbow", size: 96)
            HStack(spacing: 22) {
                outlinedSymbol("bird", size: 50)
                outlinedSymbol("pawprint", size: 54)
                outlinedSymbol("hare", size: 56)
                outlinedSymbol("tortoise", size: 56)
            }
            ArkShape()
                .stroke(.black, lineWidth: 5)
                .frame(height: 150)
                .padding(.horizontal, 44)
            WaveLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 44)
                .padding(.horizontal, 36)
        }
        .padding(.horizontal, 28)
    }

    private var lionsDenScene: some View {
        VStack(spacing: 24) {
            HStack(spacing: 34) {
                LionFaceView()
                VStack(spacing: 14) {
                    outlinedSymbol("figure.stand", size: 74)
                    Text("Daniel")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                LionFaceView()
            }
            CaveArchShape()
                .stroke(.black, lineWidth: 5)
                .frame(height: 190)
                .padding(.horizontal, 42)
        }
        .padding(.horizontal, 24)
    }

    private var gardenScene: some View {
        VStack(spacing: 24) {
            HStack(spacing: 32) {
                outlinedSymbol("leaf", size: 58)
                outlinedSymbol("figure.stand", size: 76)
                outlinedSymbol("figure.stand", size: 76)
                outlinedSymbol("leaf", size: 58)
            }
            HStack(spacing: 24) {
                outlinedSymbol("bird", size: 54)
                outlinedSymbol("pawprint", size: 62)
                outlinedSymbol("fish", size: 62)
            }
            GardenGroundLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 90)
        }
        .padding(.horizontal, 38)
    }

    private var samsonScene: some View {
        VStack(spacing: 24) {
            HStack(spacing: 36) {
                outlinedSymbol("figure.arms.open", size: 86)
                LionFaceView()
            }
            GardenGroundLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 96)
                .padding(.horizontal, 48)
        }
    }

    private var shepherdScene: some View {
        VStack(spacing: 24) {
            HStack(spacing: 28) {
                outlinedSymbol("figure.walk", size: 82)
                outlinedSymbol("cloud", size: 66)
                outlinedSymbol("cloud", size: 66)
            }
            HStack(spacing: 22) {
                outlinedSymbol("pawprint", size: 58)
                outlinedSymbol("pawprint", size: 58)
                outlinedSymbol("pawprint", size: 58)
            }
            GardenGroundLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 72)
                .padding(.horizontal, 46)
        }
    }

    private var fishScene: some View {
        VStack(spacing: 22) {
            outlinedSymbol("fish", size: 160)
            outlinedSymbol("figure.wave", size: 58)
            WaveLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 58)
                .padding(.horizontal, 38)
        }
    }

    private var riverScene: some View {
        VStack(spacing: 22) {
            HStack(spacing: 24) {
                outlinedSymbol("leaf", size: 62)
                BasketShape()
                    .stroke(.black, lineWidth: 5)
                    .frame(width: 160, height: 96)
                outlinedSymbol("leaf", size: 62)
            }
            WaveLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 76)
                .padding(.horizontal, 42)
        }
    }

    private var gardenAnimalsScene: some View {
        VStack(spacing: 24) {
            HStack(spacing: 24) {
                LionFaceView()
                outlinedSymbol("bird", size: 58)
                outlinedSymbol("hare", size: 66)
            }
            HStack(spacing: 24) {
                outlinedSymbol("fish", size: 62)
                outlinedSymbol("pawprint", size: 62)
                outlinedSymbol("tortoise", size: 62)
            }
            GardenGroundLine()
                .stroke(.black, lineWidth: 4)
                .frame(height: 76)
                .padding(.horizontal, 46)
        }
    }

    private func outlinedSymbol(_ name: String, size: CGFloat) -> some View {
        Image(systemName: name)
            .symbolRenderingMode(.monochrome)
            .font(.system(size: size, weight: .regular))
            .foregroundStyle(.black)
    }
}

private struct LionFaceView: View {
    var body: some View {
        ZStack {
            Image(systemName: "seal")
                .font(.system(size: 112, weight: .regular))
            Image(systemName: "pawprint")
                .font(.system(size: 42, weight: .regular))
        }
        .foregroundStyle(.black)
    }
}

private struct ArkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.15)
        )
        path.move(to: CGPoint(x: rect.midX - rect.width * 0.16, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.16, y: rect.minY + rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.14, y: rect.minY + rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.14, y: rect.midY))
        path.move(to: CGPoint(x: rect.midX - rect.width * 0.08, y: rect.minY + rect.height * 0.22))
        path.addLine(to: CGPoint(x: rect.midX - rect.width * 0.08, y: rect.minY + rect.height * 0.06))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.2, y: rect.minY + rect.height * 0.06))
        return path
    }
}

private struct CaveArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.2)
        )
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.maxY))
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

private struct GardenGroundLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control1: CGPoint(x: rect.minX + rect.width * 0.25, y: rect.minY),
            control2: CGPoint(x: rect.minX + rect.width * 0.75, y: rect.maxY)
        )
        return path
    }
}

private struct WaveLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let segments = 4
        let segmentWidth = rect.width / CGFloat(segments)
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        for index in 0..<segments {
            let startX = rect.minX + CGFloat(index) * segmentWidth
            path.addCurve(
                to: CGPoint(x: startX + segmentWidth, y: rect.midY),
                control1: CGPoint(x: startX + segmentWidth * 0.25, y: rect.minY),
                control2: CGPoint(x: startX + segmentWidth * 0.75, y: rect.maxY)
            )
        }
        return path
    }
}

private struct BasketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.midY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.midY),
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.1)
        )
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.22, y: rect.maxY - rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.22, y: rect.maxY - rect.height * 0.12))
        path.closeSubpath()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.28, y: rect.midY + rect.height * 0.12))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.28, y: rect.midY + rect.height * 0.12))
        return path
    }
}
