//
//  MainVC.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 01-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit
import SFDraggableDialogView

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gitHub: GitHub!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let username = "samsao"
        self.title = username.uppercaseString
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 85/255, blue: 64/255, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.gitHub = GitHub(username: username)
        self.gitHub.getRepos {
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

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
            dialogView.photo = UIImage(named: "logo")
            dialogView.delegate = self
            dialogView.titleText = NSMutableAttributedString(string: "Infos")
            dialogView.messageText = self.createNSMutableString(repo)
            dialogView.firstBtnText = "Ok".uppercaseString
            dialogView.dialogBackgroundColor = UIColor.whiteColor()
            dialogView.cornerRadius = 8.0
            dialogView.backgroundShadowOpacity = 0.2
            dialogView.hideCloseButton = true
            dialogView.showSecondBtn = false
            dialogView.contentViewType = .Default
            dialogView.firstBtnBackgroundColor = UIColor(red: 0.230, green: 0.777, blue: 0.316, alpha: 1)
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

extension MainVC: UITableViewDelegate, UITableViewDataSource {
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
//        self.showAlert(self.gitHub.repos[indexPath.row])
        self.showBetterAlert(self.gitHub.repos[indexPath.row])
    }
    
}

extension MainVC: SFDraggableDialogViewDelegate {
    func draggableDialogView(dialogView: SFDraggableDialogView!, didPressFirstButton firstButton: UIButton!) {
        print("first button pressed")
        dialogView.dismissWithDrop(true)
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