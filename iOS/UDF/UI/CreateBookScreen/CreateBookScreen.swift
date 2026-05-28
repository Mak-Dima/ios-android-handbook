//
//  BookScreen.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-19.
//

import SwiftUI

/// A view that provides form inputs to create and persist a new book in the library.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `CreateBookScreen` acts as the **View**.
/// It binds UI fields to the temporary state held in `CreateBookScreenStore` and dispatches the `.createBook` action
/// to persist changes when the user taps the create button.
struct CreateBookScreen: View {
    
    /// The application router injected via environment to manage screen transitions.
    ///
    /// In UDF, this is used to perform the navigation side-effect of popping back to the list screen once creation is complete.
    @Environment(AppRouter.self) var router
    
    /// The store managing the creation screen's state and actions.
    @State var store: CreateBookScreenStore
    
    /// The body of the view, representing the creation form and submit trigger.
    ///
    /// In UDF, this presents form fields bound to draft values and triggers the dispatch action chain upon submission.
    var body: some View {
        switch store.uiState {
        case .show:
            VStack(alignment: .center, spacing: 20) {
                TextField("Title", text: $store.book.title)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .border(Color.gray)
                TextField("About", text: $store.book.about)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                    .border(Color.gray)
                
                Button("Create") {
                    Task {
                        await store.handle(.createBook)
                        router.navigateBack()
                    }
                }
                .buttonStyle(.bordered)
            }
            .padding(20)
            .font(Font.system(size: 20))
        case .error(let message):
            ErrorView(message: message)
        }
    }
}

#if DEBUG
import SwiftData

#Preview("Success") {
    let repo = LocalMockRepository()
    let router = AppRouter(repo)
    let store = CreateBookScreenStore(repo)
    CreateBookScreen(store: store)
        .environment(router)
}

#Preview("Create Error") {
    let repo = LocalMockRepository(error: RepositoryError.createFailed)
    let router = AppRouter(repo)
    let store = CreateBookScreenStore(repo)
    CreateBookScreen(store: store)
        .environment(router)
}
#endif
