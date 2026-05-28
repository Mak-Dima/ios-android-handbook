//
//  ErrorView.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-26.
//

import SwiftUI

struct ErrorView: View {
    var message: String
    
    var body: some View {
        ContentUnavailableView {
            Label("Error", systemImage: "exclamationmark.triangle")
                .foregroundStyle(.red)
        } description: {
            Text(message)
        }
    }
}

#Preview {
    ErrorView(message: "Some Error.")
}
