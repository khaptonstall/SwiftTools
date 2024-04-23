// Copyright © 2024 Kyle Haptonstall. All rights reserved.

import Foundation

struct Shell {
    private let executableURL: URL?

    private init(executableURL: URL?) {
        self.executableURL = executableURL
    }

    @discardableResult
    func run(_ command: String) throws -> String {
        let process = Process()
        let pipe = Pipe()

        process.standardOutput = pipe
        process.standardError = pipe
        process.arguments = ["-c", command]
        process.executableURL = executableURL
        process.standardInput = nil

        try process.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return output
    }
}

extension Shell {
    static let bash: Self = .init(executableURL: URL(fileURLWithPath: "/bin/bash"))
}
