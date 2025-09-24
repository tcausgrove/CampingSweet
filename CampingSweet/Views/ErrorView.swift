//
//  ErrorView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/24/25.
//

import SwiftUI

struct ErrorView: View {
    @Binding var errorType: UserError?

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay {
                VStack {
                    Button( "OK" ) {
                        errorType = nil
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
    }
}

#Preview {
    ErrorView(errorType: .constant(UserError.failedLoading))
}
