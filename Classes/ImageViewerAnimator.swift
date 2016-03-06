//
//  BaseViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

class ImageViewerAnimator: NSObject, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    let animator = ImageViewerAnimationTransition()
    let interativeAnimator = ImageViewerInteractiveTransition()

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presenting is ImageControllerProtocol && presented is ImageControllerProtocol {
            interativeAnimator.wireToViewController(presented)
            return animator
        }
        
        return nil
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if animator.isReverse && dismissed is ImageControllerProtocol {
            return animator
        }
        
        return nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interativeAnimator.interactionInProgress ? interativeAnimator : nil
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is ImageControllerProtocol && toVC is ImageControllerProtocol {
            if operation == .Push || operation == .Pop {
                return animator
            }
        }
        
        return nil
    }
}
