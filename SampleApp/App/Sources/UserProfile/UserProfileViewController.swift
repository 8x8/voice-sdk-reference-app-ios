//
//  UserProfileViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Wavecell

class UserProfileViewController: UIViewController,
                                 UITableViewDelegate,
                                 UITableViewDataSource {
    
    enum Section: Int, CaseIterable {
        case profile
        case phone
        case ringtone
        case inbound
        case account
        case sdk
        case deactivate
    }

    enum ProfileSection: Int, CaseIterable {
        case name
        case userId
    }

    enum AccountSection: Int, CaseIterable {
        case accountId
        case serviceUrl
        case jwtUrl
    }

    enum SdkSection: Int, CaseIterable {
        case pushToken
        case wavecellVersion
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigate-back-action"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleDoneAction))
        registerCells()
    }
 
    // MARK: -
    
    @objc func handleDoneAction() {
        Presenter.shared.presentMainScreen()
    }
    
    // MARK: -
    
    private func registerCells() {
        tableView.tableFooterView = UIView()
        tableView.registerNibCell(type: DeactivateTableViewCell.self)
        tableView.registerNibCell(type: VersionTableViewCell.self)
        tableView.registerNibCell(type: ContactIdTableViewCell.self)
        tableView.registerNibCell(type: DisplayNameTableViewCell.self)
        tableView.registerNibCell(type: PhoneTableViewCell.self)
        tableView.registerNibCell(type: RingtoneTableViewCell.self)
        tableView.registerNibCell(type: InboundTableViewCell.self)
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
        case .profile:
            count = ProfileSection.allCases.count
        case .phone:
            count = 1
        case .ringtone:
            count = 1
        case .inbound:
            count = 1
        case .account:
            count = AccountSection.allCases.count
        case .sdk:
            count = SdkSection.allCases.count
        case .deactivate:
            count = 1
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
        
        guard let profile = userContext.profile else {
            return UITableViewCell()
        }
        
        let section = Section(rawValue: indexPath.section)!
        switch section {
        case .profile:
            let row = ProfileSection(rawValue: indexPath.row)!
            switch row {
            case .userId:
                let object: ContactIdTableViewCell = tableView.dequeueReusableCell()
                object.setup(name: "User ID", value: profile.userId)
                cell = object
            case .name:
                let object: DisplayNameTableViewCell = tableView.dequeueReusableCell()
                object.setup(name: "User Name", value: profile.displayName)
                cell = object
            }
        case .phone:
            let object: PhoneTableViewCell = tableView.dequeueReusableCell()
            let phone = userContext.phoneNumber ?? ""
            object.setup(name: "Phone", value: phone)
            cell = object
        case .ringtone:
            let object: RingtoneTableViewCell = tableView.dequeueReusableCell()
            let ringtone = userContext.callKit?.ringtoneSound ?? "Default"
            object.setup(name: "Ringtone", value: ringtone)
            cell = object
        case .inbound:
            let object: InboundTableViewCell = tableView.dequeueReusableCell()
            object.setup(name: "Inbound Call Path", value: userContext.inboundCallPath.info)
            cell = object
        case .account:
            let row = AccountSection(rawValue: indexPath.row)!
            switch row {
            case .accountId:
                let object: VersionTableViewCell = tableView.dequeueReusableCell()
                object.setup(name: "Account ID",
                             value: profile.accountId)
                cell = object
            case .serviceUrl:
                let object: VersionTableViewCell = tableView.dequeueReusableCell()
                object.setup(name: "Service URL",
                             value: userContext.account?.serviceUrl ?? "")
                cell = object
            case .jwtUrl:
                let object: VersionTableViewCell = tableView.dequeueReusableCell()
                object.setup(name: "Token URL",
                             value: userContext.account?.tokenUrl ?? "")
                cell = object
            }
        case .sdk:
            let row = SdkSection(rawValue: indexPath.row)!
            switch row {
            case .pushToken:
                let object: VersionTableViewCell = tableView.dequeueReusableCell()
                object.setup(name: "Push Token",
                             value: wavecell.pushToken)
                cell = object
            case .wavecellVersion:
                let object: VersionTableViewCell = tableView.dequeueReusableCell()
                let version = "\(wavecell.version()),\n\(wavecell.voiceStackVersion())"
                object.setup(name: "Voice SDK", value: version)
                cell = object
            }
        case .deactivate:
            let object: DeactivateTableViewCell = tableView.dequeueReusableCell()
            object.setup(text: "Sign Out")
            cell = object
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        log.general.info("\(indexPath.section)")
        switch section {
        case .profile:
            let row = ProfileSection(rawValue: indexPath.row)!
            switch row {
            case .name:
                let root = DisplayNameViewController(with: userContext)
                root.onDoneBlock = {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
                let controller = UINavigationController(rootViewController: root)
                controller.modalPresentationStyle = .currentContext
                controller.modalTransitionStyle = .crossDissolve
                present(controller, animated: true, completion: nil)
            default: break
            }
        case .sdk:
            let row = SdkSection(rawValue: indexPath.row)!
            switch row {
            case .pushToken:
                sharePushToken()
            default: break
            }
        case .ringtone:
            let root = RingtonesViewController(with: userContext)
            root.onDoneBlock = {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            let controller = UINavigationController(rootViewController: root)
            controller.modalPresentationStyle = .currentContext
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        case .inbound:
            let root = InboundCallPathViewController(with: userContext)
            root.onDoneBlock = {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            let controller = UINavigationController(rootViewController: root)
            controller.modalPresentationStyle = .currentContext
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        case .phone:
            let root = PhoneViewController(with: userContext)
            root.onDoneBlock = {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
            let controller = UINavigationController(rootViewController: root)
            controller.modalPresentationStyle = .currentContext
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        case .deactivate:
            MBProgressHUD.showAdded(to: tableView, animated: true)
            userContext.unregister { _ in
                MBProgressHUD.hide(for: tableView, animated: true)
            }
        default: break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: -
    
    private func sharePushToken() {
        let pushToken = wavecell.pushToken
        if pushToken.isEmpty {
            return
        }
        
        var text = ""
        if Utilities.shouldUseSandboxPushEnvironment() {
            #if targetEnvironment(simulator)
            text = String(format: "Push Token (websocket)\n%@", pushToken)
            #else
            text = String(format: "Push Token (apns-sandbox)\n%@", pushToken)
            #endif
        } else {
            text = String(format: "Push Token (apns-production)\n%@", pushToken)
        }

        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
}
