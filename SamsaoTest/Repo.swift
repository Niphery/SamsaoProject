//
//  Repo.swift
//  SamsaoTest
//
//  Created by Robin Somlette on 01-09-2016.
//  Copyright © 2016 Samsao. All rights reserved.
//

import Foundation

class Repo {
    private var _language: String!
    private var _defaultBranch: String!
    private var _forksCount: Int!
    private var _fullName: String!
    private var _lastUpdate: NSDate!
    
    private var _detail: String?
    private var _url: String?
    private var _createdAt: NSDate?
    
    init(fullName: String, lastUpdate: NSDate, language: String, defaultBranch: String, forksCount: Int, detail: String, url: String, createdAt: NSDate) {
        self._fullName = fullName
        self._lastUpdate = lastUpdate
        self._language = language
        self._defaultBranch = defaultBranch
        self._forksCount = forksCount
        self._detail = detail
        self._url = url
        self._createdAt = createdAt
    }
    
    var language: String {
        return _language
    }
    
    var defaultBranch: String {
        return _defaultBranch
    }
    
    var forksCount: Int {
        return _forksCount
    }
    
    var fullName: String {
        return _fullName
    }
    var lastUpdate: NSDate {
        return _lastUpdate
    }
    var detail: String {
        if _detail == nil {
            return ""
        }
        return _detail!
    }
    var url: String {
        if _url == nil {
            return ""
        }
        return _url!
    }
    var createdAt: NSDate {
        if _createdAt == nil {
            return NSDate()
        }
        return _createdAt!
    }
    
    
}