//
//  CardView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 11/1/24.
//

import Foundation
import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let backgroundColor: Color
    let shadowRadius: CGFloat
    let padding: CGFloat
    
    init(cornerRadius: CGFloat = 20,
         backgroundColor: Color = Color.white,
         shadowRadius: CGFloat = 5,
         padding: CGFloat = 20,
         @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.shadowRadius = shadowRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .shadow(radius: shadowRadius)
                
                content
                    .padding(padding)
            }
            .frame(width: 300, height: 160)
        }
}
