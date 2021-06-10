//
//  MainViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Wavecell

class MainViewController: UIViewController,
                          UITableViewDelegate,
                          UITableViewDataSource {
    
    enum Section: Int, CaseIterable {
        case active
        case history
    }
    
    // MARK: -
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: -
    
    private(set) var userContext: UserContextProtocol!
    var wavecell: VoiceSDK {
        return userContext.wavecellClient.sdk
    }
    
    // MARK: -
    
    convenience init(with userContext: UserContextProtocol) {
        self.init()
        self.userContext = userContext
    }

    // MARK: -
    
    deinit {
        unsubscribe()
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recents"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "user-profile-action"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleUserProfileAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "input-phone-number-action"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleDialAction))
        
        log.adhoc.info("number of active calls: \(wavecell.calls.count)")
        setupTableView()
        subscribe()
    }
    
    // MARK: -
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        registerCells()
    }
    
    private func registerCells() {
        tableView.registerNibCell(type: ActiveCallTableViewCell.self)
        tableView.registerNibCell(type: RecentCallTableViewCell.self)
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
        case .active:
            count = wavecell.calls.count
        case .history:
            count = userContext.wavecellClient.recents.count
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .active:
            let object: ActiveCallTableViewCell = tableView.dequeueReusableCell()
            object.setup(with: wavecell.calls[indexPath.row])
            cell = object
        case .history:
            let object: RecentCallTableViewCell = tableView.dequeueReusableCell()
            object.setup(with: userContext.wavecellClient.recents[indexPath.row])
            cell = object
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .active:
            CallSessionManager.shared.presentUI(for: wavecell.calls[indexPath.row])
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // ignore for active cell
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .active:
            return nil
        default: break
        }

        let call = userContext.wavecellClient.recents[indexPath.row]
        let callBackAction = UIContextualAction(style: .normal, title: "Callback") { [weak self] (_, _, completion) in
            guard let self = self else { return }
            self.handleCallbackAction(for: call)
            completion(true)
        }
        callBackAction.backgroundColor = .appSoftGreen
        let configuration = UISwipeActionsConfiguration(actions: [callBackAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    // MARK: -
    
    @objc func handleUserProfileAction() {
        Presenter.shared.presentUserProfileScreen()
    }

    @objc func handleDialAction() {
        Presenter.shared.presentPlaceCallViewScreen()
    }
    
    // MARK: -

    private func handleCallbackAction(for call: VoiceCall) {
        log.adhoc.info("\(call.uuid)")
        
        guard let callee = call.contact else {
            return
        }
        
        MBProgressHUD.showAdded(to: tableView, animated: true)
        userContext.wavecellClient.placeCall(callType: .voip, to: callee) { [weak self] result in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.tableView, animated: true)
            switch result {
            case .success(let call):
                log.adhoc.info("\(call.uuid.uuidString)")
            case .failure(let error):
                log.adhoc.info("\(error)")
            }
        }

    }

}

// MARK: -

extension MainViewController: CallSetObserverProtocol {

    private func subscribe() {
        wavecell.addObserver(self)
        userContext.wavecellClient.addObserver(self)
    }
    
    private func unsubscribe() {
        wavecell.removeObserver(self)
        userContext.wavecellClient.removeObserver(self)
    }

    // MARK: -
    
    func handleCallAdded(_ call: VoiceCall) {
        log.adhoc.info("\(call.uuid.uuidString)")
        tableView.reloadData()
    }
    
    func handleCallRemoved(_ call: VoiceCall) {
        log.adhoc.info("\(call.uuid.uuidString)")
    }
    
}

// MARK: -

extension MainViewController: WavecellClientRecentsObserverProtocol {
    
    func handleRecentsChanged() {
        log.adhoc.info("")
        tableView.reloadData()
    }
    
}
