//
//  DataView.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-23.
//

import SwiftUI

/// A read-only subview displaying the title and details description of a book.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `BookScreenDataView` represents a stateless **View Component**.
/// It receives immutable inputs (`title` and `about`) passed down from the parent container view, remaining decoupled from stores and actions.
struct BookScreenDataView: View {
    
    /// The title of the book to display.
    var title: String
    
    /// The description of the book to display.
    var about: String
    
    /// The body of the view, representing the text layouts.
    ///
    /// In UDF, this is a pure presentation mapping of the input parameters to static text views.
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(about)
                .font(.subheadline)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .cornerRadius(8)
        }
        .padding([.top], 50)
        .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .leading)))
    }
}

#if DEBUG
#Preview {
    BookScreenDataView(title: "Title", about: "About")
}
#endif
