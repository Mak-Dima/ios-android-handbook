//
//  MainScreen.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import SwiftUI

/// A view displaying the list of all books in the library.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `MainScreen` acts as the **View**.
/// It is a passive renderer of the state provided by `MainScreenStore`. When actions occur (e.g. appearance or row deletion),
/// it dispatches them to the store to trigger processing, maintaining the single directional loop.
struct MainScreen: View {
    
    /// The application router injected via environment to manage screen transitions.
    ///
    /// In UDF, this provides the side-effect capability to navigate to other screens (e.g. Detail or Creation screens).
    @Environment(AppRouter.self) var router
    
    /// The store acting as the single source of truth for this screen's state.
    @State var store: MainScreenStore
    
    /// The body of the view, representing the visual hierarchy mapped to the store's state.
    ///
    /// In UDF, this body is a pure mapping of `store.uiState` and `store.books` to the view structure.
    var body: some View {
        Group {
            switch store.uiState {
            case .loading:
                ProgressView()
            case .loaded:
                List {
                    ForEach(store.books) { book in
                        NavigationLink(value: Route.bookScreen(book)) {
                            HStack {
                                Text(book.title)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        Task { await store.handle(.delete(book: store.books[indexSet.first!])) }
                    })
                }
            case .empty:
                Button("Add New Book") {
                    router.navigate(to: Route.createBookScreen)
                }
            case .error(let message):
                ErrorView(message: message)
            }
        }
        .task {
            await store.handle(.read)
        }
        .toolbar {
            Button("Create") {
                router.navigate(to: Route.createBookScreen)
            }
        }
    }
}

#if DEBUG
#Preview("Success") {
    let repo = LocalMockRepository()
    let router = AppRouter(repo)
    let store = MainScreenStore(repo)
    
    MainScreen(store: store)
        .environment(router)
}

#Preview("Read Error") {
    let repo = LocalMockRepository(error: RepositoryError.readFailed)
    let router = AppRouter(repo)
    let store = MainScreenStore(repo)
    
    MainScreen(store: store)
        .environment(router)
}

#Preview("Delete Error") {
    let repo = LocalMockRepository(error: RepositoryError.deleteFailed)
    let router = AppRouter(repo)
    let store = MainScreenStore(repo)
    
    MainScreen(store: store)
        .environment(router)
}
#endif
