//
//  UIKit+ViewController.swift
//  SampleApp
//
//  Copyright © 2020 8x8, Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func removeChild(animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        if children.count == 0 {
            completion?()
            return
        }
        
        // actual remove
        let vc = children[0]
        vc.willMove(toParent: nil)
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                vc.view.alpha = 0
            }, completion: { finished in
                vc.view.removeFromSuperview()
                vc.removeFromParent()
                completion?()
            })
        } else {
            vc.view.alpha = 0
            vc.view.removeFromSuperview()
            vc.removeFromParent()
            completion?()
        }
    }
    
    func presentChild(_ vc: UIViewController,
                      animated: Bool = true,
                      in view: UIView? = nil,
                      viewHierarchyCompletion: (() -> Swift.Void)? = nil,
                      animationCompletion: (() -> Swift.Void)? = nil) {
        if children.count > 0 {
            
            // avoid presenting the same controller
            if vc == children[0] {
                viewHierarchyCompletion?()
                animationCompletion?()
                return
            }
            
            cycleChild(from: children[0], to: vc, at: self, in: view,
                       animated: animated,
                       viewHierarchyCompletion: viewHierarchyCompletion,
                       animationCompletion: animationCompletion)
            
        } else {
            presentChild(vc, by: self,
                         animated: animated,
                         viewHierarchyCompletion: viewHierarchyCompletion,
                         animationCompletion: animationCompletion)
        }
    }
    
    func presentChild(_ vc: UIViewController,
                      by root: UIViewController,
                      in view: UIView? = nil,
                      animated: Bool = true,
                      viewHierarchyCompletion: (() -> Swift.Void)? = nil,
                      animationCompletion: (() -> Swift.Void)? = nil) {
        root.addChild(vc)
        
        if let rootView = view ?? root.view {
            rootView.addSubview(vc.view)
            rootView.bringSubviewToFront(vc.view)
            vc.view.frame = rootView.bounds
        }
        
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.view.alpha = 0
        viewHierarchyCompletion?()
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                vc.view.alpha = 1
            }, completion: { finished in
                vc.didMove(toParent: root)
                animationCompletion?()
            })
        } else {
            vc.view.alpha = 1
            vc.didMove(toParent: root)
            animationCompletion?()
        }
    }
    
    func cycleChild(from oldVC: UIViewController,
                    to newVC: UIViewController,
                    at root: UIViewController,
                    in view: UIView? = nil,
                    animated: Bool = true,
                    viewHierarchyCompletion: (() -> Swift.Void)? = nil,
                    animationCompletion: (() -> Swift.Void)? = nil) {
        oldVC.willMove(toParent: nil)
        root.addChild(newVC)
        
        if let rootView = view ?? root.view {
            rootView.addSubview(newVC.view)
            rootView.bringSubviewToFront(newVC.view)
            newVC.view.frame = rootView.bounds
        }
        
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newVC.view.alpha = 0
        viewHierarchyCompletion?()
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                newVC.view.alpha = 1
                oldVC.view.alpha = 0
            }, completion: { finished in
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParent()
                newVC.didMove(toParent: root)
                animationCompletion?()
            })
        } else {
            newVC.view.alpha = 1
            oldVC.view.alpha = 0
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParent()
            newVC.didMove(toParent: root)
            animationCompletion?()
        }
    }
    
    // MARK: -
    
    func addChild(_ controller: UIViewController, to view: UIView) {
        addChild(controller)
        view.addSubview(controller.view)
        
        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.layoutIfNeeded()
        
        controller.didMove(toParent: self)
    }
    
}
