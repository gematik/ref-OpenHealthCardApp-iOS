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
import Swinject
import UIKit

extension AppDelegate {
    var container: Container {
        //swiftlint:disable force_unwrapping
        let mContainer = Container()

        /// Navigation Controller
        mContainer.registerForController(NavigationController.self) { resolver, controller in
            controller.container = mContainer
            let main = resolver.resolve(MainViewController.self)!
            controller.pushViewController(main, animated: false)
        }.inObjectScope(.container)
        //swiftlint:disable:previous multiline_function_chains

        /// MainViewController
        mContainer.registerForController(MainViewController.self) { resolver, controller in
            controller.navigationItems = MainViewController.navigationItems
            controller.viewModelFactory = resolver.resolve(MenuItemViewModelFactory.self)
        }
        mContainer.register(MenuItemViewModelFactory.self) { resolver in
            let controller = resolver.resolve(MainViewControllerNavigationController.self)!
            return MenuItemViewModelFactory(controller: controller)
        }
        mContainer.register(MainViewControllerNavigationController.self) { resolver in
            resolver.resolve(NavigationController.self)!
        }

        /// Card Reader Provider List ViewController
        mContainer.registerForController(CardReaderProviderListViewController.self) { resolver, controller in
            controller.providerManager = resolver.resolve(CardReaderControllerManagerType.self)
            controller.viewModelFactory = resolver.resolve(ProviderDescriptorViewModelFactory.self)
        }
        mContainer.register(ProviderDescriptorViewModelFactory.self) { resolver in
            ProviderDescriptorViewModelFactory(
                    controller: resolver.resolve(CardReaderProviderNavigationController.self)!
            )
        }
        mContainer.register(CardReaderProviderNavigationController.self) { resolver in
            resolver.resolve(NavigationController.self)!
        }

        /// CardReaderProviderDetailViewController
        mContainer.registerForController(CardReaderProviderDetailViewController.self) { (resolver, controller, descriptor: ProviderDescriptorType) in
            //swiftlint:disable:previous line_length
            controller.descriptor = descriptor
            controller.viewModelFactory = resolver.resolve(LabeledDetailViewModelFactory.self)
        }
        mContainer.register(LabeledDetailViewModelFactory.self) { _ in
            LabeledDetailViewModelFactory()
        }

        /// Card Reader List ViewController
        mContainer.registerForController(CardReaderListViewController.self) { resolver, controller in
            controller.providerManager = resolver.resolve(CardReaderControllerManagerType.self)
            controller.viewModelFactory = resolver.resolve(CardReaderViewModelFactory.self)
        }
        mContainer.register(CardReaderViewModelFactory.self) { resolver in
            CardReaderViewModelFactory(
                    controller: resolver.resolve(CardReaderNavigationController.self)!
            )
        }
        mContainer.register(CardReaderNavigationController.self) { resolver in
            resolver.resolve(NavigationController.self)!
        }

        /// CardReaderDetailViewController
        mContainer.registerForController(CardReaderDetailViewController.self) { (resolver, controller, cardReader: CardReaderType) in
            //swiftlint:disable:previous line_length
            controller.cardReader = cardReader
            controller.viewModelFactory = resolver.resolve(LabeledDetailViewModelFactory.self)
        }

        /// CardReaderAccess
        mContainer.register(CardReaderControllerManagerType.self) { _ in
            CardReaderControllerManager.shared
        }
        //swiftlint:enable force_unwrapping
        return mContainer
    }
}

extension Container {
    typealias Controller = UIViewController

    @discardableResult
    func registerForController<C: Controller>(
            _ controllerType: C.Type,
            name: String? = nil,
            initCompleted: @escaping (Resolver, C) -> Void
    ) -> ServiceEntry<C> {
        return register(C.self, name: name) { _ in
            C()
        }.initCompleted(initCompleted)
    }

    @discardableResult
    func registerForController<C: Controller, Arg1>(
            _ controllerType: C.Type,
            name: String? = nil,
            initCompleted: @escaping (Resolver, C, Arg1) -> Void
    ) -> ServiceEntry<C> {
        // capture the argument outside of the factory block to forward it to the initComplete block
        var argument: Arg1?
        return register(C.self, name: name) { (_: Resolver, arg1: Arg1) -> C in
            argument = arg1
            return C()
        }.initCompleted { resolver, controller in
            guard let argument = argument else {
                // Should/can not happen
                return
            }
            initCompleted(resolver, controller, argument)
        }
    }
}
