//
//  CollectionViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, ImageControllerProtocol {

    var isPresented = false
    var imageView: UIImageView!
    var imageViewer = ImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !isPresented {
            self.navigationController?.delegate = imageViewer
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
    
        // Configure the cell
        cell.imageView.image = UIImage(named: "\(indexPath.item + 1)")
        cell.label.text = "\(indexPath.item + 1)"
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionViewCell
        
        imageView = cell.imageView
        if let navi = self.navigationController as? CustomNavigationController {
            navi.imageView = cell.imageView
        }
        
        tap()
    }
    
    func tap() {
        let controller = ImageViewerViewController()
        controller.transitioningDelegate = imageViewer
        controller.image = imageView.image
        
        if !isPresented {
            controller.isPresented = false
            controller.title = "查看图片"
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

}
