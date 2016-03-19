//
//  InteractiveTransition.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

public class ImageViewerInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning, UIGestureRecognizerDelegate {
    public  var isPresented = true
    
    private weak var imageViewerVC: ImageViewerViewController!
    private var distance = UIScreen.mainScreen().bounds.size.height/2
    public  var interactionInProgress = false
    private var shouldCompleteTransition = false
    
    private var startInteractive = false
    private var transitionContext: UIViewControllerContextTransitioning?
    private var toVC: UIViewController!
    private var newImageView: UIImageView!
    private var backgroundView: UIView!
    private var toImageView: UIImageView!
    private var fromFrame: CGRect = CGRectZero
    private var toFrame: CGRect = CGRectZero
    private var style = UIModalPresentationStyle.FullScreen
    
    public func wireToViewController(vc: ImageViewerViewController) {
        
        imageViewerVC = vc
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        vc.view.addGestureRecognizer(panGesture)
    }
    
    public func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
        startInteractive = true
        self.transitionContext = transitionContext
        style = transitionContext.presentationStyle()
        
        toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let containerView = transitionContext.containerView()!
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        if style != .OverFullScreen {
            containerView.addSubview(toVC.view)
            containerView.sendSubviewToBack(toVC.view)
            
            if toVC.view.bounds.size != finalFrame.size {
                toVC.view.frame = finalFrame
                toVC.view.setNeedsLayout()
                toVC.view.layoutIfNeeded()
            }
        }
        
        backgroundView = UIView(frame: finalFrame)
        backgroundView.backgroundColor = UIColor.blackColor()
        containerView.addSubview(backgroundView)
        
        let fromImageView = imageViewerVC.animationImageView
        toImageView = (toVC as! ImageControllerProtocol).animationImageView
        fromFrame = fromImageView.convertRect(fromImageView.bounds, toView: containerView)
        toFrame = toImageView.convertRect(toImageView.bounds, toView: containerView)
        
        print(toImageView.frame, toFrame)
    
        newImageView = UIImageView(frame: fromFrame)
        newImageView.image = fromImageView.image
        newImageView.contentMode = .ScaleAspectFit
        containerView.addSubview(newImageView)
        
        imageViewerVC.view.alpha = 0.0
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        
        let currentPoint = gesture.translationInView(imageViewerVC.view)
        switch (gesture.state) {
        case .Began:
            interactionInProgress = true
            if isPresented {
                imageViewerVC.dismissViewControllerAnimated(true, completion: nil)
            } else {
               imageViewerVC.navigationController?.popViewControllerAnimated(true)
            }
        
        case .Changed:
            
            updateInteractiveTransition(currentPoint)
            
        case .Ended, .Cancelled:
            interactionInProgress = false
            if (!shouldCompleteTransition || gesture.state == .Cancelled) {
                cancelTransition()
            } else {
                completeTransition()
            }
            
        default:
            break
        }
    }
    
    private func updateInteractiveTransition(currentPoint: CGPoint) {
        guard startInteractive else { return }
        
        let percent = min(fabs(currentPoint.y) / distance, 1)
        
        shouldCompleteTransition = (percent > 0.3)
        transitionContext?.updateInteractiveTransition(percent)
        backgroundView.alpha = 1 - percent
        newImageView.frame.origin.y = fromFrame.origin.y + currentPoint.y
        
        if (fromFrame.width > UIScreen.mainScreen().bounds.size.width - 60)
        {
            newImageView.frame.size.width = fromFrame.width - percent * 60.0
            newImageView.frame.origin.x = fromFrame.origin.x + percent * 30.0
        }
    }
    
    private func completeTransition() {
        guard startInteractive else { return }
        
        let duration = 0.3
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            self.newImageView.frame = self.toFrame
            self.backgroundView.alpha = 0.0
            }, completion: { finished in
                self.startInteractive = false
                
                self.newImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                
                self.toImageView.alpha = 1.0
                
                self.transitionContext?.finishInteractiveTransition()
                self.transitionContext?.completeTransition(true)
        })
    }
    
    private func cancelTransition() {
        guard startInteractive else { return }
        
        let duration = 0.3
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            self.newImageView.frame = self.fromFrame
            self.backgroundView.alpha = 1.0
            }, completion: { finished in
                self.startInteractive = false
                
                self.newImageView.removeFromSuperview()
                self.backgroundView.removeFromSuperview()
                
                self.imageViewerVC.view.alpha = 1.0
                if self.style != .OverFullScreen {
                    self.toVC.view.removeFromSuperview()
                }
                
                self.transitionContext?.cancelInteractiveTransition()
                self.transitionContext?.completeTransition(false)
        })
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            let currentPoint = panGesture.translationInView(imageViewerVC.view)
            return fabs(currentPoint.y) > fabs(currentPoint.x)
        }
        
        return true
    }
}
