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
import Foundation
import GemCommonsKit
import UIKit

protocol CardReaderNavigationController: class {
    func openCardReaderDetailPage(_ cardReader: CardReaderType)
}

class CardReaderListViewController: UIViewController {
    /* Injected dependencies */
    var providerManager: CardReaderControllerManagerType!
    var viewModelFactory: CardReaderViewModelFactory!

    private lazy var dataSource: UITableViewDataSource = {
        ListItemViewModelTableViewDataSource(viewModelsWrapper)
    }()

    private lazy var delegationHandler: UITableViewDelegate = {
        ListItemViewModelTableViewDelegate(viewModelsWrapper)
    }()

    private lazy var viewModelsWrapper: ListItemViewModelsWrapper<CardReaderType> = {
        return ListItemViewModelsWrapper(_viewModels)
    }()

    private lazy var _viewModels: [ListItemViewModel<CardReaderType>] = {
        DLog("CardReaderControllers: \(providerManager.cardReaderControllers)")
        return providerManager.cardReaderControllers.flatMap {
            $0.cardReaders.map(viewModelFactory.create)
        }
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

        tableView.register(CardReaderViewCell.self, forCellReuseIdentifier: CardReaderViewCell.reuseIdentifier)

        self.title = R.string.localizable.vc_cardReaderTitle()

        providerManager.cardReaderControllers.forEach {
            $0.add(delegate: self)
        }
    }
}

extension CardReaderListViewController: CardReaderControllerDelegate {

    func cardReader(controller: CardReaderControllerType, didConnect cardReader: CardReaderType) {
        viewModelsWrapper.append(viewModelFactory.create(item: cardReader))
        tableView.reloadData()
    }

    func cardReader(controller: CardReaderControllerType, didDisconnect cardReader: CardReaderType) {
        viewModelsWrapper.removeAll { viewModel in
            viewModel.item === cardReader
        }
        tableView.reloadData()
    }
}
