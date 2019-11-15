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

import UIKit

class ListItemViewModelTableViewDataSource<T>: NSObject, UITableViewDataSource {
    var viewModelWrapper: ListItemViewModelsWrapper<T>

    convenience init(_ viewModels: [ListItemViewModel<T>]) {
        self.init(ListItemViewModelsWrapper(viewModels))
    }

    init(_ viewModelWrapper: ListItemViewModelsWrapper<T>) {
        self.viewModelWrapper = viewModelWrapper
    }

    @objc
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModelWrapper.count
    }

    @objc
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModelWrapper[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.identifier, for: indexPath)
        viewModel.commands[.configuration]?.perform(arguments: [.cell: cell])

        return cell
    }
}
