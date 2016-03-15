//
//  DeleteImageViewController.swift
//  EdusnsClient
//
//  Created by ZhaoWei on 16/2/2.
//  Copyright © 2016年 csdept. All rights reserved.
//

import UIKit

public class ImageViewerViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, ImageControllerProtocol {
    public var imageView: UIImageView!
    public var image: UIImage?
    public var rightBarItemTitle: String?
    public var rightBarItemImage: UIImage?
    public var rightAction: ((Void) -> (Void))?
    public var isPresented = true
    private var scrollView: UIScrollView!
    private var naviBarHeight: CGFloat {
        return isPresented ? 0 : 64
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        self.edgesForExtendedLayout = .None
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.maximumZoomScale = 5.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-offsetY-[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["offsetY" : naviBarHeight], views: ["scrollView" : scrollView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView" : scrollView]))
        
        imageView = UIImageView()
        imageView.image = image
        scrollView.addSubview(imageView)
        
        if isPresented {
            let tap = UITapGestureRecognizer(target: self, action: "dismiss")
            self.scrollView.addGestureRecognizer(tap)
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
        self.imageView.frame = centerFrameForImageView()
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        if isPresented {
            return true
        }
        
        return false
    }
    
    //MARK: - Custom Methods
    private func centerFrameForImageView() -> CGRect {
        guard let aImage = image else { return CGRectZero }
        
        let viewWidth = self.scrollView.frame.size.width
        let viewHeight = self.scrollView.frame.size.height
        let imageWidth = aImage.size.width
        let imageHeight = aImage.size.height
        let newWidth = min(viewWidth, CGFloat(floorf(Float(imageWidth * (viewHeight / imageHeight)))))
        let newHeight = min(viewHeight, CGFloat(floorf(Float(imageHeight * (viewWidth / imageWidth)))))
        
        return CGRectMake((viewWidth - newWidth)/2, (viewHeight - newHeight)/2, newWidth, newHeight)
    }
    
    private func centerScrollViewContents() {
        let viewWidth = self.scrollView.frame.size.width
        let viewHeight = self.scrollView.frame.size.height
        let imageWidth = imageView.frame.size.width
        let imageHeight = imageView.frame.size.height
        
        let originX = max(0, (viewWidth - imageWidth)/2)
        let originY = max(0, (viewHeight - imageHeight)/2)
        self.imageView.frame.origin = CGPointMake(originX, originY)
    }

    //MARK: - Button Action
    @objc private func rightBarItemAction() {
        self.navigationController!.popViewControllerAnimated(true)
        if let block = rightAction {
            block()
        }
    }
    
    @objc private func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- UIScrollViewDelegate
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
}
