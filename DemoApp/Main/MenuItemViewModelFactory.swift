//
//  Copyright (c) 2020 gematik GmbH
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
import GemCommonsKit
import UIKit

class MenuItemViewModelFactory: ViewModelFactory {

    typealias Element = MainViewController.MenuItem

    private weak var controller: MainViewControllerNavigationController?

    init(controller: MainViewControllerNavigationController) {
        self.controller = controller
    }

    func create(item: Element) -> ListItemViewModel<Element> {
        let size = CGSize(width: 168, height: 180)
        let configurationCommand = MenuItemViewCellConfigurationCommand(item: item)
        //swiftlint:disable:next force_unwrapping
        let selectCommand = MenuItemViewCellSelectCommand(item: item, navigation: controller!)
        let commands: [CommandKey: Command] = [
            .configuration: configurationCommand,
            .selection: selectCommand
            // Additional (CommandKey, Command) key-value pairs can be added here to address different scenarios
            // (selection, deselection, etc.)
        ]
        return ListItemViewModel(
                identifier: MenuItemViewCell.reuseIdentifier,
                item: item,
                size: size,
                commands: commands
        )
    }
}
