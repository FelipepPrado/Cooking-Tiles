import SwiftUI

struct InitialSheet: View {
    @Environment(ViewRouter.self) private var viewRouter
    
    var body: some View {
        VStack(spacing: 40){
            Image("InitialImage")
                .resizable()
                .scaledToFit()
                .frame(width: 345, height: 280)
                .padding(.trailing, 30)
            
            VStack(spacing: 20){
                VStack(alignment: .center, spacing: -16){
                    Text("Bem-Vindo ao")
                        .font(.hammersmith(fontStyle: .title3))
                        .foregroundStyle(.brown700)
                    Text("Cooking Tiles")
                        .font(.custom("JainiPurva-Regular", size: 60, relativeTo: .largeTitle))
                        .foregroundStyle(.green500)
                }
                
                Text("Um aplicativo em que você pode descobrir **receitas novas**, **cadastrar refeições** realizadas e acompanhar as etapas de cozinha **sem interagir com o celular!**")
                    .font(Font.system(size: 16, weight: .medium))
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundStyle(Color.brown700)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            
            Spacer()
            
            Button {
                viewRouter.detailsSheet()
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
    }
}



#Preview {
    InitialSheet()
}
