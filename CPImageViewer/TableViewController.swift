//
//  TableViewController.swift
//  CPImageViewer
//
//  Created by ZhaoWei on 16/2/27.
//  Copyright © 2016年 cp3hnu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TableViewController: UITableViewController, ImageControllerProtocol {

    var isPresented = false
    var animationImageView: UIImageView!
    var imageViewer = ImageViewerAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isPresented {
            self.navigationController?.delegate = imageViewer
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)

        let name = "\(indexPath.row + 1)"
        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
        let label = cell.contentView.viewWithTag(101) as! UILabel
        imageView.image = UIImage(named: name)
        label.text = name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let imageView = cell!.contentView.viewWithTag(100) as! UIImageView
        
        animationImageView = imageView

        tap()
    }
    
    func tap() {
        let controller = ImageViewerViewController()
        controller.transitioningDelegate = imageViewer
        controller.image = animationImageView.image
        
        if !isPresented {
            controller.viewerStyle = .Push
            controller.title = "CPImageViewer"
            
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

}
