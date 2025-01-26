//
//  ErrorView.swift
//  CampingSweet
//
//  Created by Timothy Causgrove on 1/24/25.
//

import SwiftUI

struct ErrorView: View {
    let errorType: UserError
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay {
                VStack {
                    Button( "OK" ) {
                        viewModel.userError = nil
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
    }
}

#Preview {
    ErrorView(errorType: UserError.failedLoading)
        .environmentObject(ViewModel())
}
