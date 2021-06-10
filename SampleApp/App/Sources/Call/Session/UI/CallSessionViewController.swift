//
//  CallSessionViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

class CallSessionViewController: UIViewController {

    @IBOutlet weak var content: UIView!
    
    // MARK: -
    
    private(set) weak var session: CallSession?
    
    // MARK: -
    
    convenience init(with session: CallSession) {
        self.init()
        self.session = session
        subscribe()
    }

    deinit {
        unsubscribe()
    }
    
    // MARK: -

    private func subscribe() {
        session?.viewModel.addObserver(self)
    }

    private func unsubscribe() {
        session?.viewModel.removeObserver(self)
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TBD
        log.call.info("")
    }
    
}
