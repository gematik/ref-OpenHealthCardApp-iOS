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
import SnapKit
import UIKit

typealias Consumer<A> = (A) -> Void

protocol MainViewControllerNavigationController: class {
    func openCardReaderProvider()
    func openConnectedCardReaders()
}

class MainViewController: UIViewController {
    struct MenuItem {
        let icon: () -> UIImage?
        let color: () -> UIColor
        let text: () -> String
        let onSelect: Consumer<MainViewControllerNavigationController>?

        init(icon: @autoclosure @escaping () -> UIImage?,
             color: @autoclosure @escaping () -> UIColor,
             text: @autoclosure @escaping () -> String,
             onSelect: Consumer<MainViewControllerNavigationController>?) {
            self.icon = icon
            self.color = color
            self.text = text
            self.onSelect = onSelect
        }
    }

    static let navigationItems = [
        MenuItem( // swiftlint:disable:this trailing_closure
                icon: R.image.book(),
                color: UIColor(red: 42 / 255, green: 171 / 255, blue: 1.0, alpha: 1.0),
                text: R.string.localizable.menuItem_cardReaderProviderTitle(),
                onSelect: { navigation in navigation.openCardReaderProvider() }
        ),
        MenuItem( // swiftlint:disable:this trailing_closure
                icon: R.image.book(),
                color: UIColor(red: 135 / 255, green: 152 / 255, blue: 228 / 255, alpha: 1.0),
                text: R.string.localizable.menuItem_cardReaderTitle(),
                onSelect: { navigation in navigation.openConnectedCardReaders()}
        ),
        MenuItem(
                icon: nil,
                color: UIColor(red: 110 / 255, green: 110 / 255, blue: 110 / 255, alpha: 1.0),
                text: R.string.localizable.menuItem_emergencyNotesTitle(),
                onSelect: nil
        ),
        MenuItem(
                icon: nil,
                color: UIColor(red: 110 / 255, green: 110 / 255, blue: 110 / 255, alpha: 1.0),
                text: R.string.localizable.menuItem_VSDTitle(),
                onSelect: nil
        )
    ]

    /* Injected dependencies */
    var navigationItems: [MenuItem]!
    var viewModelFactory: MenuItemViewModelFactory!

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let mCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mCollectionView.alwaysBounceVertical = true
        mCollectionView.backgroundColor = UIColor.white
        return mCollectionView
    }()

    lazy var viewModels: [ListItemViewModel<MenuItem>] = {
        return navigationItems.map(viewModelFactory.create)
    }()

    override func loadView() {
        let mView = UIView(frame: .zero)
        mView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.view = mView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(MenuItemViewCell.self, forCellWithReuseIdentifier: MenuItemViewCell.reuseIdentifier)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        let viewModel = viewModels[indexPath.item]
        viewModel.commands[.selection]?.perform(arguments: [.cell: cell])
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.item]
        viewModel.commands[.update]?.perform(arguments: [.cell: cell])
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let viewModel = viewModels[indexPath.item]
        viewModel.commands[.cancellation]?.perform(arguments: [.cell: cell])
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModels[indexPath.item].size
    }
}

extension MainViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return navigationItems.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewModel = viewModels[indexPath.item]
        // The cell is dequeued based on the identifier tied to the view model
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: viewModel.identifier, for: indexPath)
        viewModel.commands[.configuration]?.perform(arguments: [.cell: cell])

        return cell
    }
}
