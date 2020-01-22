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
import GemCommonsKit
import SnapKit
import UIKit

class CardReaderProviderDetailViewController: UIViewController {
    var descriptor: ProviderDescriptorType!
    var viewModelFactory: LabeledDetailViewModelFactory!

    private lazy var viewModelsWrapper: ListItemViewModelsWrapper<LabeledDetailViewModelFactory.Element> = {
        return ListItemViewModelsWrapper(_viewModels)
    }()

    private lazy var _viewModels: [ListItemViewModel<LabeledDetailViewModelFactory.Element>] = {
        return [
            (R.string.localizable.crp_detail_name(), descriptor.name, nil),
            (R.string.localizable.crp_detail_desc(), descriptor.providerDescription, nil),
            (R.string.localizable.crp_detail_license(), descriptor.license, nil),
            (R.string.localizable.crp_detail_class(), descriptor.providerClassName, nil)
        ].map(viewModelFactory.create)
    }()

    private lazy var dataSource: UITableViewDataSource = {
        ListItemViewModelTableViewDataSource(viewModelsWrapper)
    }()

    private lazy var delegationHandler: UITableViewDelegate = {
        ListItemViewModelTableViewDelegate(viewModelsWrapper)
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

        self.title = descriptor.name

        tableView.dataSource = dataSource
        tableView.delegate = delegationHandler
        tableView.estimatedRowHeight = 50

        tableView.register(
                LabeledDetailViewCell.self,
                forCellReuseIdentifier: LabeledDetailViewCell.reuseIdentifier
        )
    }
}
