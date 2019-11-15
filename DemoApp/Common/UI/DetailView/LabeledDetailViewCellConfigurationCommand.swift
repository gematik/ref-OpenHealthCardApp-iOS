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
import UIKit

struct LabeledDetailViewCellConfigurationCommand: Command {
    //swiftlint:disable:previous type_name

    // Internal state required to perform the command
    private let item: LabeledDetailViewModelFactory.Element

    init(item: LabeledDetailViewModelFactory.Element) {
        self.item = item
    }

    func perform(arguments: [CommandArgumentKey: Any]) {
        guard let cell = arguments[.cell] as? LabeledDetailViewCell else {
            return
        }
        cell.label = item.0
        cell.details = item.1
        cell.setLabelTextColor(item.2)
    }
}
