//
//  DataEditView.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-23.
//

import SwiftUI

/// An editing form view allowing the user to modify a book's properties or request its deletion.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `BookScreenDataEditView` serves as a component of the **View**.
/// It isolates modifications inside local `@State` bindings (`draftTitle`, `draftAbout`) to act as a sandbox/draft before
/// dispatching the `.update` action to commit those values to the store and trigger repository updates.
struct BookScreenDataEditView: View {
    
    /// The store managing detail and editing screen states.
    var store: BookScreenStore
    
    /// A local state variable holding the draft title during editing.
    ///
    /// In UDF, this represents isolated, transient view state that avoids polluting the main store state until committed.
    @State private var draftTitle: String
    
    /// A local state variable holding the draft description during editing.
    ///
    /// In UDF, this represents isolated, transient view state that avoids polluting the main store state until committed.
    @State private var draftAbout: String

    /// Initializes the edit view with a given store, initializing local drafts with current store values.
    ///
    /// - Parameter store: The store managing details screen state.
    ///
    /// In UDF, this maps the initial domain state from the store into local transient view states.
    init(store: BookScreenStore) {
        self.store = store
        _draftTitle = .init(initialValue: store.book.title)
        _draftAbout = .init(initialValue: store.book.about)
    }
    
    /// The body of the view, laying out input fields and action buttons.
    ///
    /// In UDF, this maps text fields to local drafts and dispatches save or delete actions to the store when buttons are tapped.
    var body: some View {
        VStack(spacing: 12) {
            editField(label: "Title", text: $draftTitle)
            editField(label: "About", text: $draftAbout)
            HStack {
                Button("Update") {
                    Task {
                        let draftBook = Book(id: store.book.id, title: draftTitle, about: draftAbout)
                        await store.handle(.update(draftBook))
                    }
                }
                .padding()
                
                Spacer()
                
                Button("Delete") {
                    Task { await store.handle(.showDeleteConfirmation) }
                }
                .padding()
            }
        }
        .padding()
    }
    
    /// Helper view builder compiling an input text field with its header label.
    ///
    /// - Parameters:
    ///   - label: The descriptive label of the text field.
    ///   - text: The bidirectional binding linking the text field to a string state.
    /// - Returns: A configured text field view.
    @ViewBuilder
    private func editField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            TextField("Enter \(label.lowercased())", text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#if DEBUG
#Preview {
    let store = BookScreenStore(
        LocalMockRepository(),
        Book(id: UUID(), title: "Test", about: "About")
    )
    
    BookScreenDataEditView(store: store)

}
#endif
