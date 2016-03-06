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
    var imageView: UIImageView!
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
        cell.imageView?.image = UIImage(named: name)
        cell.textLabel?.text = name

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        imageView = cell?.imageView
        if let navi = self.navigationController as? CustomNavigationController {
            navi.imageView = cell?.imageView
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
