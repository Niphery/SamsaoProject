//
//  MainVC.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 01-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var textField: CustomTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textField.delegate = self
        
        self.title = "GitHub Repo"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchRepos(sender: AnyObject) {
        if let text = self.textField.text where text != "" {
            self.performSegueWithIdentifier(SEGUE_SEARCH_REPO, sender: text)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_SEARCH_REPO {
            if let username = sender as? String, let vc = segue.destinationViewController as? ReposVC {
                vc.username = username
            }
        }
    }


}

extension MainVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    func textFieldDidEndEditing(textField: UITextField) {
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text where text != "" {
            self.performSegueWithIdentifier(SEGUE_SEARCH_REPO, sender: text)
        }
        return true
    }
}
