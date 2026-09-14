import SwiftUI

struct MealView: View {
    let meal: Meal
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 30){
                    VStack(spacing: 15){
                        Image(uiImage: UIImage(data: meal.image) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 35))
                            .padding(.horizontal, 30)
                            .accessibilityLabel("Foto da refeicao")
                        
                        StarRatingInputComponent(rating: .constant(meal.stars), isInput: false)
                    }
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text("Receitas do Prato")
                            .font(.hammersmith(fontStyle: .title2))
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.brown200)
                        
                        HStack(alignment: .center, spacing: 25){
                            ForEach(meal.recipes){ recipe in
                                VStack(spacing: 9){
                                    DiamondComponent(recipe: recipe)
                                        .frame(width: 62, height: 62)
                                    
                                    Text(recipe.name)
                                        .font(.hammersmith(fontStyle: .caption))
                                        .foregroundStyle(.brown200)
                                        .frame(maxWidth: 100)
                                        .multilineTextAlignment(.center)
                                }
                                .frame(alignment: .top)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("Receita: \(recipe.name)")

                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        if !meal.comment.isEmpty{
                            Text("Comentários")
                                .font(.hammersmith(fontStyle: .title2))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.brown200)
                            
                            Text(meal.comment)
                                .font(.hammersmith(fontStyle: .body))
                                .foregroundStyle(.brown200)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, minHeight: 52, alignment: .topLeading)
                                .padding(16)
                                .background(.cream600, in: RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(.horizontal, 36)
                .padding(.top, 60)
            }
        }
        .background(.cream500)
    }
}

#Preview {
    MealView(meal: Meal(
        image: Data(),
        stars: 5,
        recipes: [],
        score: 100,
        comment: "Muito bom!",
        date: .now
    ))
}
