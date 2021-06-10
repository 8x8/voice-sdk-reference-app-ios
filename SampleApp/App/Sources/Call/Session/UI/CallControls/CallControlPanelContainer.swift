//
//  CallControlPanelContainer.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

protocol CallControlPanelContainerDataSourceProtocol: AnyObject {
    func numberOfCells(for container: CallControlPanelContainer) -> Int
    func cellSize(for container: CallControlPanelContainer) -> CGSize
    func cell(for container: CallControlPanelContainer, at index: Int) -> UIView?
}

// MARK: -

class CallControlPanelContainer {
    
    private(set) var cells = [UIView]()
    
    // MARK: -
    
    private(set) var view: UIView
    
    // MARK: -
    
    private(set) weak var delegate: CallControlPanelContainerDataSourceProtocol?
    
    // MARK: -
    
    init(with view: UIView, delegate: CallControlPanelContainerDataSourceProtocol) {
        self.view = view
        self.delegate = delegate
    }

    // MARK: -
    
    func reload() {
        guard let delegate = delegate else {
            return
        }
        
        // cleanup
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        cells.removeAll()
        
        // setup new containers
        let number = delegate.numberOfCells(for: self)
        let size = delegate.cellSize(for: self)
        for _ in 0..<number {
            let cell = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            cell.heightAnchor.constraint(greaterThanOrEqualToConstant: size.height).isActive = true
            cell.widthAnchor.constraint(greaterThanOrEqualToConstant: size.width).isActive = true
            cells.append(cell)
        }
        
        let stack = UIStackView(arrangedSubviews: cells)
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.spacing = CGFloat(10)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        let attributes: [NSLayoutConstraint.Attribute] = [.centerX, .centerY]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: stack, attribute: $0, relatedBy: .equal, toItem: view,
                               attribute: $0, multiplier: 1, constant: 0)
        })
        
        // embed
        for index in 0..<number {
            if let control = delegate.cell(for: self, at: index) {
                embed(control, at: index)
            }
        }
    }
    
    // MARK: -
    
    func replaceControl(at index: Int, with control: UIView) {
        embed(control, at: index)
    }
    
    // MARK: -
    
    private func embed(_ control: UIView, at index: Int) {
        // remove previous content
        let spot = cells[index]
        for view in spot.subviews {
            view.removeFromSuperview()
        }
        // add a new content
        control.embed(in: spot)
    }
    
}
