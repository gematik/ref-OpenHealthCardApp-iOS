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

import CardReaderAccess
import CardReaderProviderApi
import GemCommonsKit
import UIKit

protocol CardReaderProviderNavigationController: class {
    func openProviderDescriptorDetailPage(_ descriptor: ProviderDescriptorType)
}

/// CardReaderProviderListViewController
class CardReaderProviderListViewController: UIViewController {
    /* Injected dependencies */
    var providerManager: CardReaderControllerManagerType!
    var viewModelFactory: ProviderDescriptorViewModelFactory!

    private lazy var dataSource: UITableViewDataSource = {
        ListItemViewModelTableViewDataSource(viewModelsWrapper)
    }()

    private lazy var delegationHandler: UITableViewDelegate = {
        ListItemViewModelTableViewDelegate(viewModelsWrapper)
    }()

    private lazy var viewModelsWrapper: ListItemViewModelsWrapper<ProviderDescriptorType> = {
        return ListItemViewModelsWrapper(_viewModels)
    }()

    private lazy var _viewModels: [ListItemViewModel<ProviderDescriptorType>] = {
        return providerManager.cardReaderProviderDescriptors.map(viewModelFactory.create)
    }()

    private lazy var tableView: UITableView = {
        let mTableView = UITableView(frame: .zero, style: .plain)
        mTableView.separatorStyle = .none
        return mTableView
    }()

    override func loadView() {
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.delegate = delegationHandler

        tableView.register(
                ProviderDescriptorViewCell.self,
                forCellReuseIdentifier: ProviderDescriptorViewCell.reuseIdentifier
        )

        self.title = R.string.localizable.vc_cardReaderProviderTitle()
    }
}
