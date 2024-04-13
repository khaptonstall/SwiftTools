// Copyright © 2024 Kyle Haptonstall. All rights reserved.

import Foundation

extension NSRegularExpression {
    /// - Parameters:
    ///   - input: The input string on which to find matches
    ///   - index: The index of the capture group you wish to find matches for. Defaults to `1` (i.e. the first capture group)
    func matches(in input: String, at index: Int = 1) throws -> [String] {
        let results = matches(in: input, range: NSRange(input.startIndex..., in: input))

        let matches = results.compactMap { result -> String? in
            guard let range = Range(result.range(at: index), in: input) else { return nil }
            return String(input[range])
        }

        return matches
    }
}
