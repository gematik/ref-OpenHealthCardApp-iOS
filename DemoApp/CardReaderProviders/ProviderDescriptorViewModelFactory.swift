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

import CardReaderProviderApi
import UIKit

class ProviderDescriptorViewModelFactory: ViewModelFactory {

    typealias Element = ProviderDescriptorType

    private weak var controller: CardReaderProviderNavigationController?

    init(controller: CardReaderProviderNavigationController) {
        self.controller = controller
    }

    func create(item: Element) -> ListItemViewModel<Element> {
        let size = CGSize(width: 0, height: 90)
        let configurationCommand = ProviderDescriptorViewCellConfigurationCommand(item: item)
        //swiftlint:disable:next force_unwrapping
        let selectCommand = ProviderDescriptorViewCellSelectCommand(item: item, navigation: controller!)
        let commands: [CommandKey: Command] = [
            .configuration: configurationCommand,
            .selection: selectCommand
            // Additional (CommandKey, Command) pairs can be added here to address different scenarios
            // (selection, deselection, etc.)
        ]
        return ListItemViewModel(
                identifier: ProviderDescriptorViewCell.reuseIdentifier,
                item: item,
                size: size,
                commands: commands
        )
    }
}
