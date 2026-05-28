//
//  UIStoreProtocol.swift
//  UDF-Library
//
//  Created by Dmytro Maksiutenko on 2026-05-27.
//

import Foundation

/// A protocol that defines a common interface for UI states that can represent an error.
protocol BaseUIState {
    static func errorState(message: String) -> Self
}

/// A protocol that provides a standardized way to perform asynchronous work and handle errors in stores.
@MainActor
protocol UIStoreProtocol: AnyObject {
    associatedtype State: BaseUIState
    var uiState: State { get set }
}

extension UIStoreProtocol {
    /// Performs asynchronous work and automatically handles errors by updating the `uiState`.
    ///
    /// - Parameters:
    ///   - work: The asynchronous work to perform.
    ///   - onFailure: An optional closure to execute if an error occurs.
    func perform(_ work: () async throws -> Void, onFailure: (() -> Void)? = nil) async {
        do {
            try await work()
        } catch let error as RepositoryError {
            onFailure?()
            uiState = .errorState(message: error.message)
        } catch {
            onFailure?()
            uiState = .errorState(message: ErrorMessages.reportSentToDevelopers)
        }
    }
}
