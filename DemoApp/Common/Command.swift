//
//  Copyright (c) 2019 gematik - Gesellschaft für Telematikanwendungen der Gesundheitskarte mbH
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//     http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

/// Command pattern follows a pattern described on: https://tech.okcupid.com/command-patterns-and-uicollectionview/
/// for View-Action-ViewController decoupling
protocol Command {
    func perform(arguments: [CommandArgumentKey: Any])
}

/// Commands
enum CommandKey {
    /// Configure a cell/view. Typically invoked from a `dataSource.cellForItemAt` or `dataSource.cellForRowAt`
    case configuration
    /// Update view contents. Typically invoked from a `delegate.willDisplay`
    case update
    /// View/Cell did get selected. Typically invoked from a `delegate.didSelectItemAt` or `delegate.didSelectRowAt`
    case selection
    /// When a view/cell moves out of the viewport. Typically invoked from a `delegate.didEndDisplaying`
    case cancellation
}

/// Argument key
enum CommandArgumentKey {
    /// Passing a cell parameter to a command
    case cell
}

/// Composite command to attach multiple commands to a `CommandKey`
struct CompositeCommand: Command {

    private let commands: [Command]

    init(commands: [Command]) {
        self.commands = commands
    }

    func perform(arguments: [CommandArgumentKey: Any]) {
        commands.forEach {
            $0.perform(arguments: arguments)
        }
    }
}
