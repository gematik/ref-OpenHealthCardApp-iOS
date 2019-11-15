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

import CardReaderProviderApi
import GemCommonsKit
import HealthCardAccessKit
import HealthCardControlKit
import NFCCardReaderProvider
import SnapKit
import UIKit

class CardReaderDetailViewController: UIViewController {
    //swiftlint:disable:previous type_body_length
    var cardReader: CardReaderType!
    var viewModelFactory: LabeledDetailViewModelFactory!

    private var can: CAN?

    private lazy var viewModelsWrapper: ListItemViewModelsWrapper<LabeledDetailViewModelFactory.Element> = {
        return ListItemViewModelsWrapper(_viewModels)
    }()

    private var _viewModels: [ListItemViewModel<LabeledDetailViewModelFactory.Element>] {
        return [
            (R.string.localizable.cardReader_detail_name(), cardReader.name, canTintColor),
            (R.string.localizable.cardReader_detail_card(), cardReader.cardPresent ? R.string.localizable
                    .cardReader_detail_card_present() : R.string.localizable.cardReader_detail_card_not_present(),
                    canTintColor),
            (R.string.localizable.cardReader_detail_class(), String(describing: type(of: cardReader)), canTintColor),
            (R.string.localizable.cardReader_detail_initialized(), "yes (Hard Coded)", canTintColor)
        ].map(viewModelFactory.create)
    }

    private lazy var dataSource: UITableViewDataSource = {
        ListItemViewModelTableViewDataSource(viewModelsWrapper)
    }()

    private lazy var delegationHandler: UITableViewDelegate = {
        ListItemViewModelTableViewDelegate(viewModelsWrapper)
    }()

    // MARK: Views

    private lazy var tableView: UITableView = {
        let mTableView = UITableView(frame: .zero, style: .plain)
        mTableView.separatorStyle = .none
        return mTableView
    }()

    private lazy var canTintColor = {
        UIColor(red: 39.0 / 255.0, green: 114.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
    }()

    private var doneViewBottomHideConstraint: Constraint?
    private var doneViewBottomShowConstraint: Constraint?

    private lazy var doneView: UIView = {
        let mView = UIView(frame: .zero)
        mView.backgroundColor = canTintColor

        let button = UIButton(type: .roundedRect)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.addTarget(self, action: #selector(connect), for: .touchUpInside)
        button.setTitle(R.string.localizable.btn_connect(), for: .normal)
        mView.addSubview(button)
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(38)
            make.centerY.equalToSuperview()
        }

        let cancel = UIButton(type: .roundedRect)
        cancel.setTitleColor(UIColor.white, for: .normal)
        cancel.addTarget(self, action: #selector(cancelConnect), for: .touchUpInside)
        cancel.setTitle(R.string.localizable.btn_cancel(), for: .normal)
        mView.addSubview(cancel)
        cancel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.height.equalTo(38)
            make.centerY.equalToSuperview()
        }

        return mView
    }()

    private lazy var canTextInput: UITextField = {
        let editText = UITextField(frame: .zero)
        editText.delegate = self
        editText.layer.borderColor = canTintColor.cgColor
        editText.layer.borderWidth = 1.0
        editText.borderStyle = .roundedRect
        editText.clearButtonMode = .always
        editText.keyboardType = .numberPad
        return editText
    }()

    private lazy var canLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = canTintColor
        label.text = R.string.localizable.can_label()
        label.textAlignment = .right
        return label
    }()

    override func loadView() {
        let mView = UIView(frame: .zero)

        mView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }

        let canWrapperView = UIView(frame: .zero)
        canWrapperView.addSubview(canLabel)
        canWrapperView.addSubview(canTextInput)

        tableView.tableHeaderView = canWrapperView

        mView.addSubview(doneView)
        doneView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalToSuperview()
            doneViewBottomHideConstraint = make.bottom.equalTo(mView.snp.bottom).offset(50).constraint
            make.centerX.equalToSuperview()
        }
        doneViewBottomHideConstraint?.activate()

        self.view = mView
    }

    // MARK: Life-cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let headerView = tableView.tableHeaderView else {
            return
        }

        canLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        canTextInput.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(canLabel.snp.right).offset(8)
            make.right.equalToSuperview().inset(12)
            make.bottomMargin.equalToSuperview().inset(12)
            make.topMargin.equalToSuperview().inset(12)
        }

        let sizeNeeded = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if headerView.frame.height != sizeNeeded.height {
            headerView.frame.size.height = sizeNeeded.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cardReader.name

        tableView.dataSource = dataSource
        tableView.delegate = delegationHandler
        tableView.estimatedRowHeight = 50

        tableView.register(
                LabeledDetailViewCell.self,
                forCellReuseIdentifier: LabeledDetailViewCell.reuseIdentifier
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        unregisterForKeyboardNotifications()
        unregisterCardReaderPresence()
        super.viewWillDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        registerForKeyboardNotifications()
    }

    private func unregisterCardReaderPresence() {
        cardReader.onCardPresenceChanged { _ in
        }
    }

    private func registerCardReaderPresence() {
        cardReader.onCardPresenceChanged { [unowned self] card in
            DLog("Card presence changed: \(card.name)")
            self.updateViewModels()
            if card.cardPresent {
                do {
                    guard let card = try card.connect([:]) else {
                        DLog("No card returned by connect()")
                        return
                    }
                    self.onCardConnected(card: card)
                } catch let error {
                    DLog("Error: \(error)")
                }
            }
        }

        if let nfcReader = cardReader as? NFCCardReader {
            nfcReader.startDiscovery(with: [
                NFCCardReader.keyDiscoveryMessage: R.string.localizable.nfc_start_pace_negotiation()
            ])
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        cardReader.onCardPresenceChanged { _ in
        }

        doneViewBottomShowConstraint?.deactivate()
        doneViewBottomHideConstraint?.deactivate()

        super.viewDidDisappear(animated)
    }

    private func updateViewModels() {
        viewModelsWrapper.viewModels = self._viewModels
        tableView.reloadData()
    }

    // MARK: Actions
    @objc
    func connect() {
        DLog("Start connect!!")
        canTextInput.resignFirstResponder()

        do {
            // Read CAN from user input
            let canInput = canTextInput.text ?? ""
            // Parse for validity
            can = try CAN.from(Data(canInput.utf8))
            registerCardReaderPresence()
        } catch let error {
            DLog("Error: \(error)")
            let alert = UIAlertController(
                    title: R.string.localizable.error_title(),
                    message: error.localizedDescription,
                    preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: R.string.localizable.btn_ok(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func onCardConnected(card: CardType) {
        DLog("Start open session")

        guard let can = can else {
            return
        }

        card.openSecureSession(can: can)
                .schedule(on: Executor.userInteractive)
                .run(on: Executor.main)
                .on { [unowned self] event in
                    DLog("Event: \(event)")
                    event.fold(
                            onComplete: { healthCard in
                                DLog("Healthcard: \(healthCard)")
                                let alert = UIAlertController(
                                        title: R.string.localizable.success_title(),
                                        message: nil,
                                        preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(
                                        title: R.string.localizable.btn_ok(),
                                        style: .default,
                                        handler: nil)
                                )
                                self.present(alert, animated: true, completion: nil)
                            },
                            onCancelled: {
                                DLog("Cancelled")
                            },
                            onTimedOut: {
                                DLog("Timeout")
                            },
                            onError: { error in
                                DLog("Error: \(error)")
                                if let nfcReader = self.cardReader as? NFCCardReader {
                                    nfcReader.invalidateSession(error: error.localizedDescription)
                                }
                                let alert = UIAlertController(
                                        title: R.string.localizable.error_title(),
                                        message: error.localizedDescription,
                                        preferredStyle: .alert
                                )
                                alert.addAction(UIAlertAction(
                                        title: R.string.localizable.btn_ok(),
                                        style: .default,
                                        handler: nil)
                                )
                                self.present(alert, animated: true, completion: nil)
                            }
                    )
                }

    }

    @objc
    func cancelConnect() {
        DLog("cancel!!")
        canTextInput.resignFirstResponder()
    }
}

extension CardReaderDetailViewController: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillHide(notification:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
        )
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow(notification:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
        )
    }

    @objc
    func keyboardWillHide(notification: Notification) {
        doneViewBottomShowConstraint?.deactivate()
        doneViewBottomHideConstraint?.activate()
    }

    @objc
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue)?.cgRectValue,
           let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                   as? NSNumber)?.doubleValue {
            let doneView = self.doneView

            self.doneViewBottomHideConstraint?.deactivate()
            if doneViewBottomShowConstraint == nil {
                doneView.snp.makeConstraints { make in
                    doneViewBottomShowConstraint = make.bottom.equalToSuperview().inset(keyboardSize.height).constraint
                }
            }
            UIView.animate(withDuration: duration) { [unowned self] in
                self.doneViewBottomShowConstraint?.activate()
            }
        }
    }
}
