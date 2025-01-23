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
    let padding: CGFloat
    
    init(cornerRadius: CGFloat = 20,
         backgroundColor: Color = Color.white,
         shadowRadius: CGFloat = 5,
         padding: CGFloat = 20,
         @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        ViewThatFits(in: .vertical) {
            content
                .padding(padding)
            ScrollView { content }
        }
        .frame(minHeight: 180)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.blue.opacity(0.3))
        }
        .padding(.horizontal, 12)
    }
}
