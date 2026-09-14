//
//  StatusCoinComponent.swift
//  POC Map
//
//  Created by Maria Fernanda Braga Queiroz on 04/09/26.
//

import SwiftUI

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let corte = rect.height * 0.4
        
        path.move(to: CGPoint(x: corte, y: 0))
        path.addLine(to: CGPoint(x: rect.width - corte, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width - corte, y: rect.height))
        path.addLine(to: CGPoint(x: corte, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2))
        path.closeSubpath()
        return path
    }
}

struct StatusCoinComponent: View {
    let coin: Int
    
    private var formattedCoin: String {
        coin.formatted(.number.notation(.compactName))
    }
    
    var body: some View {
        HStack(spacing: 3) {
            Text(formattedCoin)
                .font(.hammersmith(fontStyle: .headline))
                .foregroundColor(.cream300)
                .lineLimit(1)
            
            Image("statusCoin")
                .frame(width: 29, height: 24)

        }
        .frame(minWidth: 42)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            HexagonShape()
                .fill(.brown900)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(coin) moedas")
    }
}

#Preview {
    StatusCoinComponent(coin: 10000)
}
