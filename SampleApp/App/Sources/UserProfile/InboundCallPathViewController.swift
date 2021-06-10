//
//  InboundCallPathViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit
import Wavecell

class InboundCallPathViewController: UIViewController,
                                     UITableViewDelegate,
                                     UITableViewDataSource {
    
    @IBOutlet private weak var tableView: UITableView!

    // MARK: -

    private(set) var userContext: UserContextProtocol!
    var wavecell: VoiceSDK {
        return userContext.wavecellClient.sdk
    }

    // MARK: -

    var onDoneBlock: (() -> Void)?
    
    // MARK: -

    private(set) var selectedPath: InboundCallPath! {
        didSet {
            tableView?.reloadData()
        }
    }

    // MARK: -
    
    convenience init(with userContext: UserContextProtocol) {
        self.init()
        self.userContext = userContext
        
        selectedPath = userContext.inboundCallPath
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inbound Call Path"
        
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
        tableView.registerNibCell(type: InboundOptionTableViewCell.self)
    }

    // MARK: -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: -
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InboundCallPath.allCases.count
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
        let path = InboundCallPath.allCases[indexPath.row]
        let object: InboundOptionTableViewCell = tableView.dequeueReusableCell()
        object.setup(name: path.info, selected: selectedPath == path)
        return object
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = InboundCallPath.allCases[indexPath.row]
        
        log.general.info("\(path)")
        selectedPath = path
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: -
    
    @objc
    private func handleCancelAction() {
        dismiss(animated: true, completion: nil)
    }

    @objc
    private func handleDoneAction() {
        userContext.inboundCallPath = selectedPath
        let block = onDoneBlock
        dismiss(animated: true) {
            block?()
        }
    }
    
}
