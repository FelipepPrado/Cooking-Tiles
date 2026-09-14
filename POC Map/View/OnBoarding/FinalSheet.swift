import SwiftUI

struct FinalSheet: View {
    @Environment(ViewRouter.self) private var viewRouter

    @AppStorage("hasCompletedOnboarding")
    private var hasCompletedOnboarding = false

    var body: some View {
        VStack(spacing: 65) {
            Image("FinalImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300)
                .frame(height: 260)

            Text("Acompanhe as receitas em tempo real e **controle a passagem** de etapas por meio de poses de mão, **sem precisar encostar no celular**")
                .font(Font.system(size: 16, weight: .medium))
                .foregroundStyle(.brown700)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                hasCompletedOnboarding = true
                viewRouter.dismissSheet()
            } label: {
                BrownButtonComponent(
                    title: "Próximo",
                    recipe: Recipe(
                        name: "",
                        status: .unlocked,
                        reward: 0,
                        time: 0,
                        level: .easy,
                        steps: [],
                        igredients: [],
                        tags: [],
                        category: .pratoPrincipal,
                        id: 0,
                        price: 0,
                        overlayImage: "",
                        portions: "",
                        recipeDescription: ""
                    ),
                    currentButton: .smallFill
                )
            }
        }
        .padding(.top, 50)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cream500.ignoresSafeArea())
    }
}

#Preview {
    NavigationStack {
        FinalSheet()
    }
    .environment(ViewRouter())
}
