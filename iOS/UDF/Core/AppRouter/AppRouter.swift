//
//  AppRouter.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-20.
//

import Foundation
import SwiftUI

/// A router that coordinates programmatic navigation throughout the application.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `AppRouter` acts as the **Navigation Coordinator**.
/// It acts as the single source of truth for navigation state (`navPath`). Instead of views pushing and popping screens
/// directly using binding, they instruct the router to transition, which updates the state and redraws the navigation stack.
@Observable
@MainActor
final class AppRouter {
    
    /// The programmatic navigation path driving the root navigation stack.
    ///
    /// In UDF, this represents the current navigation history/state.
    var navPath: [Route]
    
    /// The repository dependency passed down to child stores during initialization.
    private var repo: RepositoryProtocol
    
    /// Initializes the app router with a specified repository.
    ///
    /// - Parameter repo: The data repository used to feed data to child screens.
    ///
    /// In UDF, this sets up the router with access to side-effect channels required for routing destinations.
    init(_ repo: RepositoryProtocol) {
        self.navPath = []
        self.repo = repo
    }
    
    /// Generates and configures the SwiftUI view corresponding to a given route.
    ///
    /// - Parameter route: The navigation target.
    /// - Returns: A configured view equipped with its relevant store and environment.
    ///
    /// In UDF, this acts as the **View Factory / Assembler**, instantiating stores with the repository reference
    /// and injecting the router as an environment object.
    @ViewBuilder
    func view(for route: Route) -> some View {
        switch route {
        case .main:
            let store = MainScreenStore(repo)
            MainScreen(store: store)
                .environment(self)
        case .createBookScreen:
            let store = CreateBookScreenStore(repo)
            CreateBookScreen(store: store)
                .environment(self)
        case .bookScreen(let book):
            let store = BookScreenStore(repo, book)
            BookScreen(store: store)
                .environment(self)
        }
    }
    
    /// Pushes a new route onto the navigation stack.
    ///
    /// - Parameter route: The destination route to navigate to.
    ///
    /// In UDF, this triggers a navigation state mutation, appending a new destination onto the navigation path.
    func navigate(to route: Route) {
        navPath.append(route)
    }
    
    /// Pops the top-most route off the navigation stack.
    ///
    /// In UDF, this triggers a navigation state mutation to go back one screen.
    func navigateBack() {
        if !navPath.isEmpty {
            navPath.removeLast()
        }
    }
}
