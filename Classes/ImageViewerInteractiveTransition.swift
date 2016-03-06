//
//  InteractiveTransition.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class ImageViewerInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var controller: UIViewController!
    var distance = UIScreen.mainScreen().bounds.size.height/2
    var interactionInProgress = false
    var shouldCompleteTransition = false
    
    override var completionSpeed: CGFloat {
        get {
            return 1 - percentComplete
        }
        set {
            self.completionSpeed = newValue
        }
    }
    
    func wireToViewController(vc: UIViewController) {
        
        controller = vc
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        vc.view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        let point = gesture.translationInView(controller.view)
        switch (gesture.state) {
        case .Began:
            interactionInProgress = true
            controller.dismissViewControllerAnimated(true, completion: nil)
        
        case .Changed:
            let height = controller.view.bounds.size.height - distance
            let fraction = point.y/height
            shouldCompleteTransition = (fraction > 0.5)
            self.updateInteractiveTransition(fraction)
        
        case .Ended, .Cancelled:
            interactionInProgress = false
            if (!shouldCompleteTransition || gesture.state == .Cancelled) {
                self.cancelInteractiveTransition()
            } else {
                self.finishInteractiveTransition()
            }
            
        default:
            break
        }
    }
}
