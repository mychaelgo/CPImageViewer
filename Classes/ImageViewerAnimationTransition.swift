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

    //private var originalFrame = CGRectZero
    public var dismiss = false
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC!)
        let backgroundView = UIView(frame: finalFrame)
        backgroundView.backgroundColor = UIColor.blackColor()
        containerView?.addSubview(backgroundView)
        
        let fromImageView = (fromVC as! ImageControllerProtocol).imageView
        let toImageView = (toVC as! ImageControllerProtocol).imageView
        let fromFrame = fromImageView.convertRect(fromImageView.bounds, toView: containerView)
        let originalFrame = toImageView.convertRect(toImageView.bounds, toView: containerView)
        
        let newImageView = UIImageView(frame: fromFrame)
        newImageView.image = fromImageView.image
        newImageView.contentMode = .ScaleAspectFit
        containerView?.addSubview(newImageView)
        
        if !dismiss {
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
            if !self.dismiss {
                newImageView.frame = finalFrame
                backgroundView.alpha = 1.0
            } else {
                newImageView.frame = originalFrame
                backgroundView.alpha = 0.0
            }
            }, completion: { finished in
                newImageView.removeFromSuperview()
                backgroundView.removeFromSuperview()
                
                let cancel = transitionContext.transitionWasCancelled()
                
                if !self.dismiss {
                    if cancel {
                        fromImageView.alpha = 1.0
                    } else {
                        containerView!.addSubview(toVC!.view)
                    }
                } else {
                    if cancel {
                        fromVC!.view.alpha = 1.0
                        toVC!.view.removeFromSuperview()
                    } else {
                        toImageView.alpha = 1.0
                    }
                }
                transitionContext.completeTransition(!cancel)
        })
    }
}
