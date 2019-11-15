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

import SnapKit
import UIKit

class MenuItemViewCell: UICollectionViewCell {
    static let reuseIdentifier = "OHCMenuItemView.identifier"

    private lazy var label = UILabel(frame: .zero)
    private lazy var iconView = UIImageView(frame: .zero)

    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }

    var icon: UIImage? {
        get {
            return iconView.image
        }
        set {
            iconView.image = newValue
            if newValue != nil {
                iconView.backgroundColor = nil
                iconView.layer.borderWidth = 0.0
            } else {
                iconView.backgroundColor = UIColor.lightGray
                iconView.layer.borderWidth = 1.0
                iconView.layer.cornerRadius = 40.0
                iconView.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    /*
         -------------------
        |   *contentView*   |
        |   -------------   |
        |  |  *spacer*   |  |
        |  |             |  |
        |  |   -------   |  |
        |  |  |*image*|  |  |
        |  |   -------   |  |
        |  |             |  |
        |   -------------   |
        |    -----------    |
        |   |  *label*  |   |
        |    -----------    |
         -------------------
    */
    func setupView() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true

        self.contentView.addSubview(label)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.left.greaterThanOrEqualToSuperview().inset(5)
            make.right.lessThanOrEqualToSuperview().inset(5)
            make.height.equalTo(28)
            make.centerX.equalToSuperview()
        }

        let spacer = UIView(frame: .zero)
        self.contentView.addSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(label.snp.top)
        }

        spacer.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.center.equalToSuperview()
        }
    }
}
