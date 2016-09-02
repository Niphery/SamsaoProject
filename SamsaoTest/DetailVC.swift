//
//  DetailVC.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 02-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit

class DetailVC: UITableViewController {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var lastUpdated: UILabel!
    @IBOutlet weak var defaultBranch: UILabel!
    @IBOutlet weak var forks: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var repo: Repo!
    var gitAvatar: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.repo.fullName
        
        self.avatar.image = self.gitAvatar
        self.fullName.text = self.repo.fullName
        self.detail.text = self.repo.detail
        self.url.text = self.repo.url
        self.createdAt.text = NSDateFormatter.localizedStringFromDate(repo.createdAt, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        self.lastUpdated.text = NSDateFormatter.localizedStringFromDate(repo.lastUpdate, dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        self.defaultBranch.text = self.repo.defaultBranch
        self.forks.text = "\(self.repo.forksCount)"
        self.language.text = self.repo.language
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleTapGesture(sender: UITapGestureRecognizer) {
        self.performSegueWithIdentifier(SEGUE_GIT_REPO, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_GIT_REPO {
            if let vc = segue.destinationViewController as? WebVC {
                vc.url = self.repo.url
                vc.repoTitle = self.repo.fullName
            }
        }
    }
    

}
