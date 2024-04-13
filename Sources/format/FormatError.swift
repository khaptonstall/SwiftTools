// Copyright © 2024 Kyle Haptonstall. All rights reserved.

import Foundation

enum FormatError: Error {
    case defaultConfigurationFileNotFound
    case defaultSwiftVersionFileNotFound
}

extension FormatError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .defaultConfigurationFileNotFound:
            "Failed to find the 'default.swiftformat' file in the Package bundle."
        case .defaultSwiftVersionFileNotFound:
            "Failed to find the 'default.swift-version' file in the Package bundle."
        }
    }
}
