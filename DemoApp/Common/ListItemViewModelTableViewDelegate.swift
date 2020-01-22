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

import UIKit

class ListItemViewModelTableViewDelegate<T>: NSObject, UITableViewDelegate {
    var viewModelsWrapper: ListItemViewModelsWrapper<T>

    convenience init(_ viewModels: [ListItemViewModel<T>]) {
        self.init(ListItemViewModelsWrapper(viewModels))
    }

    init(_ viewModelWrapper: ListItemViewModelsWrapper<T>) {
        self.viewModelsWrapper = viewModelWrapper
    }

    @objc
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let viewModel = viewModelsWrapper[indexPath.row]
        viewModel.commands[.selection]?.perform(arguments: [:])
    }

    @objc
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = viewModelsWrapper[indexPath.row]
        return viewModel.size.height
    }
}
