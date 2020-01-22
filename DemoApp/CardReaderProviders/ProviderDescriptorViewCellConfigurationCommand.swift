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

import CardReaderProviderApi
import Foundation

struct ProviderDescriptorViewCellConfigurationCommand: Command {
    //swiftlint:disable:previous type_name
    private let item: ProviderDescriptorType

    init(item: ProviderDescriptorType) {
        self.item = item
    }

    func perform(arguments: [CommandArgumentKey: Any]) {
        guard let cell = arguments[.cell] as? ProviderDescriptorViewCell else {
            return
        }

        cell.textLabel?.text = item.name
        cell.imageView?.image = R.image.book()
        cell.detailTextLabel?.text = item.shortDescription
    }
}
