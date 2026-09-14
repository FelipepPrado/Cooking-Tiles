import SwiftUI
import PhotosUI
import SwiftData

struct NewMealView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(ViewRouter.self) var viewRouter
    
    @Query(sort: \Recipe.id, order: .forward) private var recipeModel: [Recipe]
    @Query private var players: [Player]
    
    @FocusState private var isCommentFocused: Bool
    
    var player: Player {
        players.first ?? Player(coin: 100, banner: "Phoenix")
    }
    
    @State private var viewModel = NewMealViewModel()
    
    var body: some View {
        ZStack{
            
            Color(.cream500).ignoresSafeArea()
            ScrollViewReader{ proxy in
                ScrollView{
                    VStack(spacing: 30){
                        VStack{
                            Button {
                                viewRouter.cameraView { fotoCapturada in
                                    viewModel.imageData = fotoCapturada
                                    viewModel.newMeal.image = fotoCapturada
                                }
                            } label: {
                                if let imageData = viewModel.imageData,
                                   let image = UIImage(data: imageData) {
                                    
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 285, height: 260)
                                        .clipShape(RoundedRectangle(cornerRadius: 35))
                                    
                                } else {
                                    Image(systemName: "photo.badge.plus.fill")
                                        .font(.system(size: 60))
                                        .frame(width: 285, height: 260)
                                        .foregroundStyle(.cream800)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 35)
                                                .stroke(
                                                    .cream800,
                                                    style: StrokeStyle(
                                                        lineWidth: 5,
                                                        dash: [31, 31]
                                                    )
                                                )
                                        }
                                }
                            }
                            .accessibilityLabel(viewModel.imageData != nil
                                                ? "Foto da refeicao capturada"
                                                : "Adicionar foto da refeicao")
                            .accessibilityHint("Toque duas vezes para abrir a camera")
                            
                            
                            StarRatingInputComponent(rating: $viewModel.newMeal.stars, isInput: true)
                        }
                        
                        VStack(spacing: 20){
                            Text("Receitas do Prato")
                                .font(.hammersmith(fontStyle: .title2))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.brown200)
                            
                            //Trocar essa lógica talvez (Deixar melhor e mais responsivo)
                            VStack(alignment: .center, spacing: 20){
                                HStack(spacing: 20){
                                    ForEach(RecipeCategory.allCases) { category in
                                        if category != .sobremesa{
                                            Button(action: {
                                                viewModel.recipeCategory = category
                                            }, label:{
                                                if viewModel.recipesDic[category] == nil{
                                                    VStack(alignment: .center, spacing: 9){
                                                        Image("diamondInput")
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 70, height: 70)
                                                        
                                                        Text(category.displayName)
                                                            .font(.hammersmith(fontStyle: .caption))
                                                            .foregroundStyle(.brown200)
                                                    }
                                                    
                                                }
                                                else{
                                                    VStack(alignment: .center){
                                                        if let recipe = viewModel.recipesDic[category] {
                                                            DiamondComponent(recipe: recipe)
                                                                .frame(width: 70, height: 70)
                                                        }
                                                        Spacer()
                                                        Text(viewModel.recipesDic[category]?.name ?? "Sem nome")
                                                            .font(.hammersmith(fontStyle: .caption))
                                                            .foregroundStyle(.brown200)
                                                            .frame(maxWidth: 100)
                                                            .multilineTextAlignment(.center)
                                                            .fixedSize(horizontal: false, vertical: true)
                                                        
                                                    }
                                                }
                                            })
                                            .frame(maxWidth: 88, maxHeight: 125)
                                            .accessibilityLabel(viewModel.recipesDic[category] != nil
                                                                ? "\(category.displayName): \(viewModel.recipesDic[category]?.name ?? "")"
                                                                : "Selecionar \(category.displayName)")
                                            .accessibilityHint("Toque duas vezes para escolher uma receita de \(category.displayName)")
                                            
                                        }
                                    }
                                }
                                
                                Button(action: {
                                    viewModel.recipeCategory = .sobremesa
                                }, label:{
                                    if viewModel.recipesDic[.sobremesa] == nil{
                                        VStack(alignment: .center, spacing: 9){
                                            Image("diamondInput")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 70, height: 70)
                                            
                                            Text(RecipeCategory.sobremesa.displayName)
                                                .font(.hammersmith(fontStyle: .caption))
                                                .foregroundStyle(.brown200)
                                        }
                                    }
                                    else{
                                        VStack(alignment: .center, spacing: 9){
                                            if let recipe = viewModel.recipesDic[.sobremesa] {
                                                DiamondComponent(recipe: recipe)
                                                    .frame(width: 70, height: 70)
                                            }
                                            
                                            Text(viewModel.recipesDic[.sobremesa]?.name ?? "Sem nome")
                                                .font(.hammersmith(fontStyle: .caption))
                                                .foregroundStyle(.brown200)
                                                .frame(maxWidth: 100)
                                                .multilineTextAlignment(.center)
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                })
                                .frame(maxWidth: 88, maxHeight: 125)
                                
                            }
                            
                            Text("Comentários")
                                .font(.hammersmith(fontStyle: .title2))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.brown200)
                            
                            TextField("",
                                      text: $viewModel.newMeal.comment,
                                      prompt: Text("Descreva seus comentários...")
                                .foregroundStyle(.brown200),
                                      axis: .vertical
                            )
                            .focused($isCommentFocused)
                            .id("commentField")
                            .accessibilityLabel("Comentarios")
                            .accessibilityHint("Digite seus comentarios sobre a refeicao")
                            .font(.custom("Hammersmith One", size: 16, relativeTo: .body))
                            .foregroundStyle(.brown200)
                            .lineLimit(1...4)
                            .padding(16)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(.cream600, in: RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(.cream800, lineWidth: 3)
                                    .allowsHitTesting(false)
                            }
                            
                            Color.clear
                                .frame(height: 5)
                                .id("commentBottom")
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button(action: {
                                viewModel.addMeal(context: modelContext, player)
                                viewRouter.clear()
                            }, label: {
                                HStack(spacing: 4){
                                    Text("+\(viewModel.actualScore)")
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                    
                                    Image("recipeCoin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 17)
                                }
                                .animation(.easeIn, value: viewModel.actualScore)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 6)
                            })
                            .buttonStyle(.borderedProminent)
                            .tint(.green500)
                            .disabled(viewModel.newMeal.image == Data() || viewModel.recipesDic.isEmpty)
                            .accessibilityLabel("Confirmar refeicao")
                            .accessibilityHint("Toque duas vezes para salvar a refeicao")
                            
                        }
                        
                    }
                    .sheet(item: $viewModel.recipeCategory) { category in
                        AddRecipetoMealView(
                            viewModel: AddRecipetoMealViewModel(
                                viewModel: viewModel,
                                recipes: recipeModel.filter { recipe in
                                    recipe.category == category && recipe.status == .unlocked
                                }
                            )
                        )
                    }
                    
                    .navigationTitle("Cadastrar Refeição")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Cadastrar Refeição")
                                .fontWeight(.bold)
                                .foregroundStyle(.brown200)
                                .blendMode(.plusDarker)
                        }
                    }
                }
                .onTapGesture {
                    isCommentFocused = false
                }
                .onChange(of: viewModel.newMeal.comment) {
                    if isCommentFocused {
                        withAnimation {
                            proxy.scrollTo("commentBottom", anchor: .bottom)
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
    }
}


#Preview {
    NewMealView()
        .environment(ViewRouter())
        .modelContainer(
            for: Recipe.self,
            inMemory: true
        )
}
