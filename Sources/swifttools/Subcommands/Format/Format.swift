// Copyright © 2024 Kyle Haptonstall. All rights reserved.

import ArgumentParser
import Foundation
import SwiftFormat

struct Format: ParsableCommand {
    @Option(help: "Path to a configuration file containing rules and options")
    var config: String?

    @Option(name: .customLong("swiftversion"), help: "The version of Swift used in the files being formatted")
    var swiftVersion: String?

    @Flag(name: .customLong("dryrun"), help: "Run in 'dry' mode (without actually changing any files)")
    var dryRun: Bool = false

    @Flag(help: "Display detailed formatting output and warnings/errors")
    var verbose: Bool = false

    @Flag(help: "Disables non-critical output messages and warnings")
    var quiet: Bool = false

    func run() throws {
        let swiftFormat = SwiftFormat()
        try swiftFormat.run(
            configFilePath: config,
            swiftVersion: swiftVersion,
            dryRun: dryRun,
            verbose: verbose,
            quiet: quiet
        )
    }
}
