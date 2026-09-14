import SwiftUI

struct DetailsSheet: View {
    @Environment(ViewRouter.self) private var viewRouter
    
    var body: some View {
        VStack(spacing: 33) {
            Image("DetailImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 675)
                .frame(height: 350)
                .ignoresSafeArea(edges: .horizontal)
            
            Text("Descubra receitas com o **Mapa de Receitas**, registre **refeições** e ganhe **moedas** para adquirir novas receitas")
                .font(Font.system(size: 16, weight: .medium))
                .foregroundStyle(.brown700)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            Text("Você já inicia com **4 receitas fáceis** para começar no mundo da culinária!")
                .font(Font.system(size: 16, weight: .medium))
                .foregroundStyle(.brown700)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                viewRouter.finalSheet()
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
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cream500.ignoresSafeArea())
    }
}

#Preview {
    DetailsSheet()
        .environment(ViewRouter())
}
