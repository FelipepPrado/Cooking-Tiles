import SwiftUI

struct AddRecipetoMealView: View {
    @Environment(\.dismiss) var dismiss
    let viewModel: AddRecipetoMealViewModel
    let columns = [
        GridItem(.adaptive(minimum: 110), spacing: 3)
    ]
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading){
                    Text(viewModel.recipes[0].category.displayName)
                        .font(.hammersmith(fontStyle: .title2))
                        .foregroundColor(.brown700)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.recipes){ recipe in
                            Button(action: {
                                if viewModel.viewModel.recipesDic.values.contains(recipe) {
                                    viewModel.viewModel.recipesDic.removeValue(forKey: recipe.category)
                                }
                                else{
                                    viewModel.addRecipe(recipe)
                                }
                                dismiss()
                            }, label: {
                                RecipeComponent(recipe: recipe, currentStatus: .unlocked, isSelected: viewModel.viewModel.recipesDic.values.contains(recipe))
                            })
                            .accessibilityLabel("Selecionar \(recipe.name)")
                            .accessibilityHint("Toque duas vezes para adicionar esta receita a refeicao")

                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
        }
        .background(.cream500)
    }
}



//#Preview {
//    AddRecipetoMealView()
//}
