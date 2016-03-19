//
//  DeleteImageViewController.swift
//  EdusnsClient
//
//  Created by ZhaoWei on 16/2/2.
//  Copyright © 2016年 csdept. All rights reserved.
//

import UIKit

public class ImageViewerViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, ImageControllerProtocol {
    public var animationImageView: UIImageView!
    public var image: UIImage?
    public var rightBarItemTitle: String?
    public var rightBarItemImage: UIImage?
    public var rightAction: ((Void) -> (Void))?
    public var isPresented = true
    private var scrollView: UIScrollView!
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        //解决屏幕旋转后，返回时image view位置错误的问题
        self.modalPresentationStyle = .OverFullScreen
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        if isPresented {
            self.edgesForExtendedLayout = .None
        }
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView" : scrollView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView" : scrollView]))
        
        animationImageView = UIImageView()
        animationImageView.image = image
        scrollView.addSubview(animationImageView)
        
        if isPresented {
            let tap = UITapGestureRecognizer(target: self, action: "dismiss")
            scrollView.addGestureRecognizer(tap)
        } else if let title = rightBarItemTitle {
            let rightItem = UIBarButtonItem(title: title, style: .Plain, target: self, action: "rightBarItemAction")
            self.navigationItem.rightBarButtonItem = rightItem
        } else if let image = rightBarItemImage {
            let rightItem = UIBarButtonItem(image: image, style: .Plain, target: self, action: "rightBarItemAction")
            self.navigationItem.rightBarButtonItem = rightItem
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.zoomScale = 1.0
        scrollView.contentInset = UIEdgeInsetsZero
        animationImageView.frame = centerFrameForImageView()
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        if isPresented {
            return true
        }
        
        return super.prefersStatusBarHidden()
    }
    
    //MARK: - Custom Methods
    private func centerFrameForImageView() -> CGRect {
        guard let aImage = image else { return CGRectZero }
        
        let viewWidth = scrollView.frame.size.width
        let viewHeight = scrollView.frame.size.height
        let imageWidth = aImage.size.width
        let imageHeight = aImage.size.height
        let newWidth = min(viewWidth, CGFloat(floorf(Float(imageWidth * (viewHeight / imageHeight)))))
        let newHeight = min(viewHeight, CGFloat(floorf(Float(imageHeight * (viewWidth / imageWidth)))))
        
        return CGRectMake((viewWidth - newWidth)/2, (viewHeight - newHeight)/2, newWidth, newHeight)
    }
    
    private func centerScrollViewContents() {
        let viewWidth = scrollView.frame.size.width
        let viewHeight = scrollView.frame.size.height
        let imageWidth = animationImageView.frame.size.width
        let imageHeight = animationImageView.frame.size.height
        
        let originX = max(0, (viewWidth - imageWidth)/2)
        let originY = max(0, (viewHeight - imageHeight)/2)
        animationImageView.frame.origin = CGPointMake(originX, originY)
    }

    //MARK: - Button Action
    @objc private func rightBarItemAction() {
        self.navigationController!.popViewControllerAnimated(true)
        if let block = rightAction {
            block()
        }
    }
    
    @objc private func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UIScrollViewDelegate
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return animationImageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}
