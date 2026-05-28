//
//  UDF_LibraryApp.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-18.
//

import SwiftUI
import SwiftData


/// The entry point of the library application.
///
/// In the **UDF (Unidirectional Data Flow)** architecture, `UDF_LibraryApp` serves as the **Root Bootstrapper / Orchestrator**.
/// It initializes core global dependencies, such as the persistent container (`ModelContainer`), the persistent repository
/// (`LocalRepository`), and the root coordinator (`AppRouter`), and injects them into the view hierarchy.
@main
struct UDF_LibraryApp: App {
    
    /// The application's navigation router state.
    ///
    /// In UDF, this acts as the global navigation state holder.
    @State var appRouter: AppRouter
    
    /// The database repository abstraction used by the app router.
    ///
    /// In UDF, this is the root gateway to side-effects.
    let localRepository: RepositoryProtocol
    
    /// The SwiftData model container acting as the relational storage context.
    let dataContainer: ModelContainer
    
    /// Initializes the application, preparing the SwiftData containers and setting up the global router.
    ///
    /// In UDF, this performs dependency injection and setups up the base store references.
    init() {
        do {
            let modelContainer = try ModelContainer(for: Book.self)
            self.dataContainer = modelContainer
            localRepository = LocalRepository(modelContainer: modelContainer)
            appRouter = AppRouter(localRepository)
        } catch {
            fatalError("Container error: \(error)")
        }
    }
    
    /// The root body of the application scene, defining the window group and initial navigation path.
    ///
    /// In UDF, this constructs the outer boundary of the unidirectional pipeline, anchoring the programmatic `NavigationStack`.
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appRouter.navPath) {
                appRouter.view(for: .main)
                    .navigationDestination(for: Route.self) { route in
                        appRouter.view(for: route)
                    }
            }
        }
    }
}
