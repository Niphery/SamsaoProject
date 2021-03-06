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
    private var _avatar: UIImage?
    
    var reposURL: String {
        return "\(GITHUB_URL)/\(_username)/repos"
    }
    
    var username: String {
        return _username
    }
    
    var repos: [Repo] {
        return _repos
    }
    
    var avatar: UIImage {
        if _avatar == nil {
            return UIImage(named: "logo")!
        }
        return _avatar!
    }
    
    init(username: String) {
        self._username = username
        self._repos = [Repo]()
    }
    
    func getRepos(completed: DownloadCompleted) {
        var oldRepos = [Repo]()
        if self._repos.count > 0  {
            oldRepos = self._repos
            self._repos = [Repo]()
        }
        
        Alamofire.request(.GET, reposURL).responseJSON { (response) in
            if let datas = response.result.value as? [Dictionary<String, AnyObject>]{
                
                if let owner = datas[0]["owner"] as? Dictionary<String, AnyObject>, let avatar = owner["avatar_url"] as? String {
                    Alamofire.request(.GET, avatar).validate(contentType: ["image/*"]).response(completionHandler: { (request, response, data, error) in
                        if error == nil {
                            if let image = UIImage(data: data!) {
                                self._avatar = image
                            }
                        }
                    })
                }
                
                for data in datas {
                    if let fullName = data["full_name"] as? String,
                        let lastUpdate = data["updated_at"] as? String,
                        let language = data["language"] as? String,
                        let defaultBranch = data["default_branch"] as? String,
                        let forksCount = data["forks"] as? Int,
                        let detail = data["description"] as? String,
                        let createdAt = data["created_at"] as? String,
                        let url = data["svn_url"] as? String
                         {
                        
                        let repo = Repo(fullName: fullName, lastUpdate: self.convertStringToNSDate(lastUpdate), language: language, defaultBranch: defaultBranch, forksCount: forksCount, detail: detail, url: url, createdAt: self.convertStringToNSDate(createdAt))
                        
                        self._repos.append(repo)
                        
                    }
                }
//                print("JSON: \(JSON[0]["id"])")
            }
        
            if self._repos.count == 0 {
                self._repos = oldRepos
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