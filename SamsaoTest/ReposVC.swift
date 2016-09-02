//
//  ReposVC.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 01-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit
import SFDraggableDialogView

class ReposVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: CustomActivityIndicator!
    
    var gitHub: GitHub!
    var username: String!
    var refreshControlTV = UIRefreshControl()
    var selectedRepo: Repo?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //TableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // activityIndicator
        self.activityIndicator.color = UIColor(red: 252/255, green: 79/255, blue: 8/255, alpha: 1)
        self.activityIndicator.type = .BallRotateChase
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimation()
        
        //Title's View
        self.title = self.username.uppercaseString
        
        
        //RefreshControl
        self.refreshControlTV.addTarget(self, action: #selector(ReposVC.refreshHandler(_:)), forControlEvents: .ValueChanged)
        self.refreshControlTV.attributedTitle = NSAttributedString(string: "Refreshing Datas")
        self.tableView.addSubview(refreshControlTV)
        
        
        self.gitHub = GitHub(username: username)
        self.gitHub.getRepos {
            self.tableView.reloadData()
            self.activityIndicator.stopAnimation()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARKS: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_DETAIL_REPO {
            if let vc = segue.destinationViewController as? DetailVC {
                vc.repo = self.selectedRepo
                vc.gitAvatar = self.gitHub.avatar
            }
        }
    }
    
    //MARKS: - IBActions
    @IBAction func refreshHandler(sender: UIRefreshControl) {
        print("Refreshing Data")
        
        self.gitHub.getRepos {
            self.tableView.reloadData()
            self.refreshControlTV.endRefreshing()
        }
        
        
    }
    
    //MARK: - Utilities functions
    func showAlert(repo: Repo) {
        let message = "Language: \(repo.language) \nDefault Branch: \(repo.defaultBranch)\nFork Count: \(repo.forksCount)"
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showBetterAlert(repo: Repo) {
        if let dialogView: SFDraggableDialogView = NSBundle.mainBundle().loadNibNamed("SFDraggableDialogView", owner: self, options: nil)[0] as? SFDraggableDialogView {
            dialogView.frame = self.view.bounds
            dialogView.photo = self.gitHub.avatar
            dialogView.delegate = self
            dialogView.titleText = NSMutableAttributedString(string: "Infos")
            dialogView.messageText = self.createNSMutableString(repo)
            dialogView.firstBtnText = "More Infos"
            dialogView.firstBtnBackgroundColor = UIColor(red: 255/255, green: 85/255, blue: 64/255, alpha: 1)
            dialogView.dialogBackgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 0.9)
            dialogView.cornerRadius = 8.0
            dialogView.backgroundShadowOpacity = 0.2
            dialogView.hideCloseButton = true
            dialogView.showSecondBtn = false
            dialogView.contentViewType = .Default
            dialogView.createBlurBackgroundWithImage(takeSnapshot(self.view), tintColor: UIColor.blackColor().colorWithAlphaComponent(0.35), blurRadius: 60.0)
            dialogView.closeBtnImage = UIImage(named: "icCross")
            dialogView.hideCloseButton = false
            self.view.addSubview(dialogView)
        }
        
    }
    
    func takeSnapshot(view: UIView) -> UIImage {
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func createNSMutableString(repo: Repo) -> NSMutableAttributedString {
        let mutableString = NSMutableAttributedString()
        
        // left aligned style
        let leftAllignedParagrahStyle = NSMutableParagraphStyle()
        leftAllignedParagrahStyle.alignment = NSTextAlignment.Center
        leftAllignedParagrahStyle.lineSpacing = 5.0
        
        // left aligned attribute
        let styleFirstWordAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0),
            NSParagraphStyleAttributeName: leftAllignedParagrahStyle]
        
        let styleDarkGreyAttributesDictionary = [
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSFontAttributeName: UIFont.systemFontOfSize(14.0),
            NSParagraphStyleAttributeName: leftAllignedParagrahStyle]
        
        // Language ->
        let languageTitleString = NSAttributedString(string: "Language: ", attributes: styleFirstWordAttributesDictionary)
        let languageString = NSAttributedString(string: "\(repo.language) \n", attributes: styleDarkGreyAttributesDictionary)
        mutableString.appendAttributedString(languageTitleString)
        mutableString.appendAttributedString(languageString)
        
        // Default Branch ->
        let branchTitleString = NSAttributedString(string: "Default Branch: ", attributes: styleFirstWordAttributesDictionary)
        let branchString = NSAttributedString(string: "\(repo.defaultBranch) \n", attributes: styleDarkGreyAttributesDictionary)
        mutableString.appendAttributedString(branchTitleString)
        mutableString.appendAttributedString(branchString)
        // Fork Count ->
        let forkTitleString = NSAttributedString(string: "Fork Count: ", attributes: styleFirstWordAttributesDictionary)
        let forkString = NSAttributedString(string: "\(repo.forksCount) \n", attributes: styleDarkGreyAttributesDictionary)
        mutableString.appendAttributedString(forkTitleString)
        mutableString.appendAttributedString(forkString)
        
        return mutableString
        
    }

}

extension ReposVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gitHub.repos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let repo = self.gitHub.repos[indexPath.row]
        let formattedDate = NSDateFormatter.localizedStringFromDate(repo.lastUpdate, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        cell.textLabel?.text = repo.fullName
        cell.detailTextLabel?.text = "Last Update: \(formattedDate)"
        cell.detailTextLabel?.textColor = UIColor.darkGrayColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedRepo = self.gitHub.repos[indexPath.row]
//        self.showAlert(self.gitHub.repos[indexPath.row])
        self.showBetterAlert(self.selectedRepo!)
    }
    
    //MARK: - Device Rotation
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //Remove Alert in case device rotate
        print(self.view.subviews.count)
        if self.view.subviews.count == 5 {
            self.view.subviews[4].removeFromSuperview()
        }
    }
    
}

extension ReposVC: SFDraggableDialogViewDelegate {
    func draggableDialogView(dialogView: SFDraggableDialogView!, didPressFirstButton firstButton: UIButton!) {
        print("first button pressed")
//        dialogView.dismissWithDrop(true)
        if let repo = self.selectedRepo {
            self.performSegueWithIdentifier(SEGUE_DETAIL_REPO, sender: repo)
        }
        
    }
    func draggingDidBegin(dialogView: SFDraggableDialogView!) {
        print("dragging has begun")
    }
    func draggingDidEnd(dialogView: SFDraggableDialogView!) {
        print("dragging did end")
    }
    func draggableDialogViewWillDismiss(dialogView: SFDraggableDialogView!) {
        print("will be dismissed")
    }
    func draggableDialogViewDismissed(dialogView: SFDraggableDialogView!) {
        print("dismissed")
    }
    
}