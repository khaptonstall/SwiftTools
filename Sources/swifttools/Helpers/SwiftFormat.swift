// Copyright © 2024 Kyle Haptonstall. All rights reserved.

import Foundation
import SwiftFormat

// Edited from source: https://github.com/nicklockwood/SwiftFormat/blob/main/CommandLineTool/main.swift
final class SwiftFormat {
    // MARK: Properties

    private var stderr = FileHandle.standardError
    private let stderrIsTTY = isatty(STDERR_FILENO) != 0
    private let printQueue = DispatchQueue(label: "swiftformat.print")
    private let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).standardizedFileURL

    // MARK: Initialization

    init() {
        CLI.print = printMessage
    }

    // MARK: Formatting

    func run(
        configFilePath: String? = nil,
        swiftVersion: String? = nil,
        stagedFilesOnly: Bool = false,
        dryRun: Bool = false,
        verbose: Bool = false,
        quiet: Bool = false
    ) throws {
        guard let commandArgument = CommandLine.arguments.first else {
            return
        }

        var arguments: [String] = [commandArgument]
        try arguments.append(contentsOf: filesToFormat(stagedFilesOnly: stagedFilesOnly))

        let configFilePath = try configFilePath ?? pathForConfigFile()
        arguments.append(contentsOf: ["--config", configFilePath])

        if configFilePath.hasSuffix("default.swiftformat") {
            // If we're using the default config file, we need to manually parse and add the excludes into the swiftformat command.
            // This is needed as swiftformat currently treats the excludes as relative to the .swiftformat file.
            let exclusions = try parseExcludedFiles(configFilePath: configFilePath)
            arguments.append(contentsOf: ["--exclude", exclusions.joined(separator: ",")])
        }

        let swiftVersion = try swiftVersion ?? parseLocalSwiftVersionFile()
        arguments.append(contentsOf: ["--swiftversion", swiftVersion])

        if dryRun {
            arguments.append("--dryrun")
        }

        if verbose {
            arguments.append("--verbose")
        }

        if quiet {
            arguments.append("--quiet")
        }

        _ = CLI.run(
            in: currentDirectory.path(),
            with: arguments
        )
    }

    // MARK: File Inputs

    private func filesToFormat(stagedFilesOnly: Bool) throws -> [String] {
        guard stagedFilesOnly else {
            return ["./"] // Format all (non-excluded) files in the working directory
        }

        // --name-only: Shows the names of the files vs the actual diff
        // grep '\\.swift$': Filter output to only include .swift files
        let stagedFilePaths = try Shell.bash.run("git diff --staged --name-only | grep '\\.swift$'")
        return stagedFilePaths.split(separator: "\n").map { String($0) }
    }

    // MARK: Config File

    private func pathForConfigFile() throws -> String {
        let currentDirectoryConfigFile = currentDirectory.appending(component: ".swiftformat").path()
        if FileManager.default.fileExists(atPath: currentDirectoryConfigFile) {
            return currentDirectoryConfigFile
        } else if let defaultConfigFile = Bundle.module.path(forResource: "default.swiftformat", ofType: nil) {
            return defaultConfigFile
        } else {
            throw FormatError.defaultConfigurationFileNotFound
        }
    }

    private func parseExcludedFiles(configFilePath: String) throws -> [String] {
        let contents = try String(contentsOfFile: configFilePath)

        // --exclude\\s+: Matches the --exclude literal followed by one or more whitespace characters
        // ([^\s#]+): Captures one or more characters that are not whitespace or the # character (i.e. ignore inline comments)
        let excludeRegex = "--exclude\\s+([^\\s#]+)"
        return try NSRegularExpression(pattern: excludeRegex).matches(in: contents)
    }

    // MARK: Swift Version

    private func parseLocalSwiftVersionFile() throws -> String {
        let currentDirectoryVersionFile = currentDirectory.appending(component: ".swift-version").path()
        if FileManager.default.fileExists(atPath: currentDirectoryVersionFile) {
            return try String(contentsOfFile: currentDirectoryVersionFile)
        } else if let defaultVersionFile = Bundle.module.path(forResource: "default.swift-version", ofType: nil) {
            return try String(contentsOfFile: defaultVersionFile)
        } else {
            throw FormatError.defaultSwiftVersionFileNotFound
        }
    }

    // MARK: Logging

    private func printMessage(_ message: String, type: CLI.OutputType) {
        printQueue.sync {
            switch type {
            case .info:
                print(message, to: &stderr)
            case .success:
                print(stderrIsTTY ? message.inGreen : message, to: &stderr)
            case .error:
                print(stderrIsTTY ? message.inRed : message, to: &stderr)
            case .warning:
                print(stderrIsTTY ? message.inYellow : message, to: &stderr)
            case .content:
                print(message)
            case .raw:
                print(message, terminator: "")
            }
        }
    }
}

// MARK: - String + Color

private extension String {
    var inDefault: String { "\u{001B}[39m\(self)" }
    var inRed: String { "\u{001B}[31m\(self)\u{001B}[0m" }
    var inGreen: String { "\u{001B}[32m\(self)\u{001B}[0m" }
    var inYellow: String { "\u{001B}[33m\(self)\u{001B}[0m" }
}

// MARK: - FileHandle + TextOutputStream

extension FileHandle: TextOutputStream {
    public func write(_ string: String) {
        write(Data(string.utf8))
    }
}
