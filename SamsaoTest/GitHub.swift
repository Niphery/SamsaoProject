//
//  GitHub.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 01-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


class GitHub {
    private var _username: String!
    private var _repos: [Repo]!
    
    var reposURL: String {
        return "\(GITHUB_URL)/\(_username)/repos"
    }
    
    var username: String {
        return _username
    }
    
    var repos: [Repo] {
        return _repos
    }
    
    init(username: String) {
        self._username = username
        self._repos = [Repo]()
    }
    
    func getRepos(completed: DownloadCompleted) {
        Alamofire.request(.GET, reposURL).responseJSON { (response) in
            if let datas = response.result.value as? [Dictionary<String, AnyObject>]{
                
                for data in datas {
                    if let fullName = data["full_name"] as? String, let lastUpdate = data["updated_at"] as? String, let language = data["language"] as? String, let defaultBranch = data["default_branch"] as? String, let forksCount = data["forks"] as? Int {
                        

                        
                        let repo = Repo(fullName: fullName, lastUpdate: self.convertStringToNSDate(lastUpdate), language: language, defaultBranch: defaultBranch, forksCount: forksCount)
                        
                        self._repos.append(repo)
                        
                    }
                }
//                print("JSON: \(JSON[0]["id"])")
            }
        completed()
        }
    }
    
    func convertStringToNSDate(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.dateFromString(string) {
            return date
        } else {
            return NSDate()
        }
        
    }
    
}