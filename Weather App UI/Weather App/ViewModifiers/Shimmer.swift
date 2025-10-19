//
//  Shimmer.swift
//  Weather App
//
//  Created by Andrew CP Markham on 19/9/2025.
//

import SwiftUI

struct Shimmer: ViewModifier {

    @State private var move: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(colors: [.clear, .white.opacity(0.5), .clear],
                                   startPoint: .top, endPoint: .bottom)
                        .rotationEffect(.degrees(30))
                        .offset(x: geo.size.width * move)
                        .frame(width: geo.size.width * 1.5, height: geo.size.height)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    move = 0.7
                }
            }
    }
}

extension View {
    func shimmer() -> some View { modifier(Shimmer()) }
}
