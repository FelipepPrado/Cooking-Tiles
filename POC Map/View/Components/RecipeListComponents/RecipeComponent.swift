import SwiftUI

struct RecipeComponent: View {
    
    let recipe: Recipe
    let currentStatus: recipeComponent
    var isSelected: Bool = false
    
    var body: some View {
        
        switch currentStatus {
        case .unlocked:
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.cream200)
                    .stroke(isSelected ? .green500 : .cream800, lineWidth: 3)
                    .frame(maxWidth: 110, minHeight: 145)
                
                VStack(spacing: 10){
                    DiamondComponent(recipe: recipe)
                        .frame(width: 74, height: 74)
                    
                    Text(recipe.name)
                        .font(.hammersmith())
                        .foregroundColor(.brown200)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(15)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(recipe.name), desbloqueada")
            .accessibilityHint("Toque duas vezes para ver detalhes")
            
            
        case .locked:
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.cream600)
                    .stroke(.cream800, lineWidth: 3)
                    .frame(maxWidth: 110, maxHeight: 145)
                
                VStack(spacing: 10){
                    Image("padlockSymbol")
//                        .frame(width: 74, height: 74)
                    Text("Ver Mais")
                        .font(.hammersmith(fontStyle: .headline))
                        .padding(5)
                        .background(.green500)
                        .cornerRadius(30)
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(15)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Receita bloqueada")
            .accessibilityHint("Toque duas vezes para ver mais informacoes")
            
            
        case .unavailable:
            ZStack(){
                RoundedRectangle(cornerRadius: 10)
                    .fill(.brown100)
                    .stroke(.brown100, lineWidth: 3)
                    .frame(width: 110, height: 145)
                
                Image("unavailableSymbol")
                    .frame(width: 42.5, height: 72.5)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Receita indisponivel")
            
        }
        
    }
}

#Preview {
    
    @Previewable var recipe: Recipe = Recipe(
        name: "Receita",
        status: .locked,
        reward: 1,
        time: 1,
        level: .easy,
        steps: [],
        igredients: [],
        tags: [],
        category: .sobremesa,
        id: 1,
        price: 50,
        overlayImage: "nuvem",
        portions: "duas",
        recipeDescription: " "
    )
    var currentStatus: recipeComponent = .unlocked
    
    RecipeComponent(recipe: recipe, currentStatus: currentStatus)
    
}

enum recipeComponent: CaseIterable {
    case unlocked, locked, unavailable
}
