//
//  RingtonesViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class RingtonesViewController: UIViewController,
                               UITableViewDelegate,
                               UITableViewDataSource {
    
    enum Section: Int, CaseIterable {
        case system
        case custom
    }

    // MARK: -
    
    @IBOutlet private weak var tableView: UITableView!

    // MARK: -
    
    private(set) var dataSource = RingtoneDataSource()
    
    // MARK: -

    private(set) var userContext: UserContextProtocol!
    var wavecell: VoiceSDK {
        return userContext.wavecellClient.sdk
    }

    // MARK: -

    var onDoneBlock: (() -> Void)?
    
    // MARK: -

    private(set) var selectedRingtone: String = "" {
        didSet {
            tableView?.reloadData()
        }
    }

    // MARK: -
    
    convenience init(with userContext: UserContextProtocol) {
        self.init()
        self.userContext = userContext
        
        selectedRingtone = userContext.callKit?.ringtoneSound ?? ""
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ringtone"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(handleCancelAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(handleDoneAction))
        registerCells()
    }
    
    // MARK: -
    
    private func registerCells() {
        tableView.tableFooterView = UIView()
        tableView.registerNibCell(type: RingtoneOptionTableViewCell.self)
    }

    // MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        let value = Section(rawValue: section)!
        switch value {
        case .system:
            count = 1
        case .custom:
            count = dataSource.ringtones.count
        }
        return count
    }

    // MARK: -
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .system:
            let object: RingtoneOptionTableViewCell = tableView.dequeueReusableCell()
            object.setup(name: "Default", selected: selectedRingtone.isEmpty)
            cell = object
        case .custom:
            let ringtone = dataSource.ringtones[indexPath.row]
            let object: RingtoneOptionTableViewCell = tableView.dequeueReusableCell()
            object.setup(name: ringtone.filename, selected: selectedRingtone == ringtone.filename)
            cell = object
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        log.general.info("\(indexPath.section)")
        switch section {
        case .system:
            selectedRingtone = ""
        case .custom:
            let ringtone = dataSource.ringtones[indexPath.row]
            selectedRingtone = ringtone.filename
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: -
    
    @objc
    private func handleCancelAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func handleDoneAction() {
        userContext.callKit?.ringtoneSound = selectedRingtone.isEmpty ? nil : selectedRingtone
        let block = onDoneBlock
        dismiss(animated: true) {
            block?()
        }
    }
    
}
