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

/// Wrapper for an array of ListItemViewModel<T> so several classes can keep a reference to the wrapped array.
/// The wrapped array can be accessed directly.
/// Some convenience methods derived from an array like count, append, ... are offered.
class ListItemViewModelsWrapper<T> {
    var viewModels: [ListItemViewModel<T>]

    init(_ viewModels: [ListItemViewModel<T>]) {
        self.viewModels = viewModels
    }

    var count: Int {
        return viewModels.count
    }

    subscript(index: Int) -> ListItemViewModel<T> {
        return viewModels[index]
    }

    func append(_ viewModel: ListItemViewModel<T>) {
        viewModels.append(viewModel)
    }

    func removeAll(where predicate: (ListItemViewModel<T>) -> Bool) {
        viewModels.removeAll(where: predicate)
    }
}
