//
//  Method.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/10/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation

extension API {
    /// Method for LiveJournal's XML-RPC interface.
    enum Method: String {
        /// Checks to see if your Friends list has been updated since a specified time.
        case checkFriends = "checkfriends"
        
        /// Run an administrative command.
        case consoleCommand = "consolecommand"
        
        /// Edit or delete a user's past journal entry
        case editEvent = "editevent"
        
        /// Edit the user's defined groups of friends.
        case editFriendGroups = "editfriendgroups"
        
        /// Add, edit, or delete friends from the user's Friends list.
        case editFriends = "editfriends"
        
        /// Returns a list of which other LiveJournal users list this user as their friend.
        case friendOf = "friendof"
        
        /// Generate a server challenge string for authentication.
        case getChallenge = "getchallenge"
        
        /// This mode retrieves the number of journal entries per day.
        case getDayCounts = "getdaycounts"
        
        /// Download parts of the user's journal. See also syncitems mode.
        case getEvents = "getevents"
        
        /// Returns a list of which other LiveJournal users this user lists as their friend.
        case getFriends = "getfriends"
        
        /// Retrieves a list of the user's defined groups of friends.
        case getFriendGroups = "getfriendgroups"
        
        /// Retrieves a list of the user's defined tags.
        case getUserTags = "getusertags"
        
        /// validate user's password and get base information needed for client to function
        case login = "login"
        
        /// The most important mode, this is how a user actually submits a new log entry to the server.
        case postEvent = "postevent"
        
        /// Expires session cookies.
        case sessionExpire = "sessionexpire"
        
        /// Generate a session cookie.
        case sessionGenerate = "sessiongenerate"
        
        /// Returns a list of all the items that have been created or updated for a user.
        case syncItems = "syncitems"
        
        /// The full method name string.
        var methodName: String {
            return "LJ.XMLRPC.\(self.rawValue)"
        }
    }
}
