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
    
    init(fullName: String, lastUpdate: NSDate, language: String, defaultBranch: String, forksCount: Int) {
        self._fullName = fullName
        self._lastUpdate = lastUpdate
        self._language = language
        self._defaultBranch = defaultBranch
        self._forksCount = forksCount
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
    
}