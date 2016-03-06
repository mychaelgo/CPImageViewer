//
//  ImageViewerAnimationController.swift
//  EdusnsClient
//
//  Created by ZhaoWei on 16/2/2.
//  Copyright © 2016年 csdept. All rights reserved.
//

import UIKit

@objc public protocol ImageControllerProtocol {
    var imageView: UIImageView! { get }
}

public class ImageViewerAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private var originalFrame = CGRectZero
    private(set) public var isReverse = false
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        
        let toFrame = transitionContext.finalFrameForViewController(toVC!)
        let backgroundView = UIView(frame: toFrame)
        backgroundView.backgroundColor = UIColor.blackColor()
        containerView?.addSubview(backgroundView)
        
        let imageFromVC = fromVC as! ImageControllerProtocol
        let imageToVC = toVC as! ImageControllerProtocol
        let fromImageView = imageFromVC.imageView
        let toImageView = imageToVC.imageView
        let fromFrame = fromImageView.convertRect(fromImageView.bounds, toView: containerView)
        let newImageView = UIImageView(frame: fromFrame)
        newImageView.image = fromImageView.image
        newImageView.contentMode = .ScaleAspectFit
        containerView?.addSubview(newImageView)
        
        if !isReverse {
            originalFrame = fromFrame
            backgroundView.alpha = 0.0
            fromImageView.alpha = 0.0
        } else {
            backgroundView.alpha = 1.0
            fromVC!.view.alpha = 0.0
            containerView!.addSubview(toVC!.view)
            containerView!.sendSubviewToBack(toVC!.view)
        }
        
        let duration = transitionDuration(transitionContext)
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            if !self.isReverse {
                newImageView.frame = toFrame
                backgroundView.alpha = 1.0
            } else {
                newImageView.frame = self.originalFrame
                backgroundView.alpha = 0.0
            }
            }, completion: { finished in
                newImageView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                
                let cancel = transitionContext.transitionWasCancelled()
                
                if !self.isReverse {
                    containerView!.addSubview(toVC!.view)
                } else {
                    if cancel {
                        fromVC!.view.alpha = 1.0
                    } else {
                        toImageView.alpha = 1.0
                    }
                }
    
                if !cancel {
                    self.isReverse = !self.isReverse
                }
                transitionContext.completeTransition(!cancel)
        })
    }
}
