# SwiftTools

A set of command-line tools to help manage Swift projects.

## Installation

### [Mint](https://github.com/yonaskolb/mint)
To install `swifttools` and link it globally:
```bash
mint install khaptonstall/swifttools@main
```

Alternatively, you can add `swifttools` to your [Mintfile](https://github.com/yonaskolb/Mint#mintfile). Running `mint boostrap` in the same directory will then install all Swift packages in your Mintfile without linking them globally.

In your Mintfile:
```
khaptonstall/swifttools@main
```

## Usage

### `format`
The `format` command uses `swiftformat`, providing some default configurations to help share standard rulesets across repos.

To run `format` using the default configuration file against the entire working directory, simply run:
```bash
mint run swifttools format
```

#### Custom Configuration
To override the default `swiftformat` configuration settings, you have the following options:

**Pass Custom .swiftformat File Path**  
You can pass a path to a custom configuration file:
```bash
mint run swifttools format --config /path/to/.swiftformat
```

**Custom Configuration File in Working Directory**  
If you didn't pass a custom configuration file path into the `format` command, it will then look for a `.swiftformat` file in the current working directory. If none is found, the default configuration will be used.

#### Custom Swift Version
To override the default `swiftformat` Swift version settings, you have the following options:

**Pass Custom Swift Version**  
You can pass in the specific Swift version you want to use:
```bash
mint run swifttools format --swiftversion 5.10
```

**Custom .swift-version File in Working Directory**  
If you didn't pass a specific Swift version into the `format` command, it will then look for a `.swift-version` file in the current working directory. If none is found, a default Swift version will be used.
