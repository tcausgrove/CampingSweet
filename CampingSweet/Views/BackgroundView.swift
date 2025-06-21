//
//  BackgroundView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 6/17/25.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Image("Background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .opacity(0.3)
            .blur(radius: 6)
    }
}

#Preview {
    BackgroundView()
}
