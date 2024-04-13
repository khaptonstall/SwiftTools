// Copyright © 2024 Kyle Haptonstall. All rights reserved.

import ArgumentParser
import Foundation

@main
struct MainCommand: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        commandName: "swifttools",
        abstract: "A set of command-line tools to help manage Swift projects",
        subcommands: [
            Format.self,
        ]
    )
}
