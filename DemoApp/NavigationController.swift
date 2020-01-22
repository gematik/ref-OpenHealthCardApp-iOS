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
import Swinject
import UIKit

class NavigationController: UINavigationController {
    /* Injected */
    var container: Container!
}

extension NavigationController: MainViewControllerNavigationController {
    func openCardReaderProvider() {
        guard let controller = container.resolve(CardReaderProviderListViewController.self) else {
            DLog("Could not resolve CardReaderProviderViewController")
            return
        }
        self.pushViewController(controller, animated: true)
    }

    func openConnectedCardReaders() {
        DLog("clicked openConnectedTerminals()")
        guard let controller = container.resolve(CardReaderListViewController.self) else {
            DLog("Could not resolve ConnectedTerminalListViewController")
            return
        }
        self.pushViewController(controller, animated: true)
    }
}

extension NavigationController: CardReaderProviderNavigationController {
    func openProviderDescriptorDetailPage(_ descriptor: ProviderDescriptorType) {
        guard let controller = container.resolve(
                CardReaderProviderDetailViewController.self,
                argument: descriptor
        ) else {
            DLog("Could not resolve CardReaderProviderDetailViewController")
            return
        }
        self.pushViewController(controller, animated: true)
    }
}

extension NavigationController: CardReaderNavigationController {
    func openCardReaderDetailPage(_ cardReader: CardReaderType) {
        guard let controller = container.resolve(
                CardReaderDetailViewController.self,
                argument: cardReader
        ) else {
            DLog("Could not resolve CardReaderDetailViewController")
            return
        }
        self.pushViewController(controller, animated: true)
    }
}
