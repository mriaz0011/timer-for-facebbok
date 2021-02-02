//
//  SM.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 05/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit

class AppSettings {
    
    //MARK:- Declare variables here.
    //Storage within app.
    let storageDefaults = UserDefaults.standard
    //Creating instance of database class.
    let db = SQLiteDB.sharedInstance
    //For web view
    var startTime: Date!
    var saveRecord: Bool = false
    //For delete icon
    var selectedIconNumber: Int!
    //Timer
    var timer = Timer()
    var remainingTimeInSeconds: Int = 0
    //Current URL
    var currentURL: String!
    
    //Instance to access declared variables.
    static let shared = AppSettings()
}
