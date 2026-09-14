import SwiftUI

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.closeSubpath()
        }
    }
}

struct DiamondComponent: View {
    let recipe: Recipe
    var hasStroke: Bool = false
    var strokeColor: Color = .cream500
    var strokeWidth: CGFloat = 16

    var body: some View {
        DiamondShape()
            .fill(Color(recipe.category.rawValue))
            .overlay {
                if hasStroke {
                    DiamondShape()
                        .stroke(strokeColor, lineWidth: strokeWidth)
                }
            }
            .overlay {
                if recipe.status == .unlocked{
                    Image("\(recipe.name + " icon")")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                }
                else{
                    Text("?")
                        .font(.custom("HammersmithOne-Regular", size: 72, relativeTo: .title3))
                        .foregroundStyle(.cream500)
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(recipe.status == .unlocked
                                ? "Icone da receita \(recipe.name)"
                                : "Receita bloqueada")

    }
}


