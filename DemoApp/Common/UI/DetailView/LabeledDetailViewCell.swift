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

class LabeledDetailViewCell: UITableViewCell {
    static let reuseIdentifier = "LabeledDetailViewCell.reuseIdentifier"

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: .value2, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    var label: String? {
        get {
            return labelLabel.text
        }
        set {
            labelLabel.text = newValue
        }
    }

    var details: String? {
        get {
            return detailsLabel.text
        }
        set {
            detailsLabel.text = newValue
        }
    }

    private lazy var detailsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = self.detailTextLabel?.font
        label.textColor = self.detailTextLabel?.textColor
        label.textAlignment = .left
        return label
    }()

    private lazy var labelLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = self.textLabel?.font
        label.textColor = self.textLabel?.textColor
        label.textAlignment = .right
        return label
    }()

    func setLabelTextColor(_ color: UIColor?) {
        if let color = color {
            labelLabel.textColor = color
        }
    }

    func setDetailTextColor(_ color: UIColor?) {
        if let color = color {
            detailsLabel.textColor = color
        }
    }

    func setupView() {
        self.contentView.addSubview(labelLabel)
        self.contentView.addSubview(detailsLabel)

        labelLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.firstBaseline.equalTo(detailsLabel)
            make.height.lessThanOrEqualTo(25)
        }

        detailsLabel.snp.makeConstraints { make in
            make.left.equalTo(labelLabel.snp.right).offset(8)
            make.height.greaterThanOrEqualTo(16)
            make.bottom.right.top.equalToSuperview().inset(8)
        }

        self.selectionStyle = .none
    }
}
