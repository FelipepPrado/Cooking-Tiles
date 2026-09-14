//
//  DescriptionComponent.swift
//  POC Map
//
//  Created by Ana Soares on 02/09/26.
//

import SwiftUI

struct DescriptionComponent: View {
    
    let recipe: Recipe
    
    let currentStatus: EnumDescription
    
    var body: some View {
        
        switch currentStatus{
            
        case .detailViewUnlocked:
            ScrollView{
                VStack(alignment: .leading){
                    Text(recipe.recipeDescription)
                        .font(.hammersmith())
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                        .frame(maxWidth: 260, maxHeight: 260, alignment: .topLeading)
                        .foregroundStyle(Color.brown700)
                }
            }
            .frame(minWidth: 280, maxHeight: 280)
            .background(Color.cream600)
            .cornerRadius(10)
        
        case .detailViewLocked:
            
            VStack(alignment: .center, spacing: 10){
                Image("NoRecipe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height:80)
                    .accessibilityHidden(true)
                
                Text("Adquira essa Receita para \nvisualizar mais informações")
                    .multilineTextAlignment(.center)
                    .font(.hammersmith())
                    .foregroundStyle(Color.brown100)
            }
            .frame(minWidth: 280, maxHeight: 280)
            .background(Color.cream600)
            .cornerRadius(10)
            
        case .recipeViewLocked:
            
            VStack(alignment: .center, spacing: 10){
                Image("NoRecipe")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height:80)
                Text("Adquira essa Receita para \nvisualizar mais informações")
                    .multilineTextAlignment(.center)
                    .font(.hammersmith())
                    .foregroundStyle(Color.brown100)
            }
            .frame(minWidth: 360, minHeight: 380)
            .background(Color.cream600)
            .cornerRadius(10)
        }

    }
}

//#Preview {
//    DescriptionComponent()
//}

enum EnumDescription: CaseIterable {
    
    case detailViewUnlocked
    case detailViewLocked
    case recipeViewLocked
    
}
