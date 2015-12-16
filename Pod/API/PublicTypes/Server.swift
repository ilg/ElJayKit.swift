//
//  Server.swift
//  ElJayKit
//
//  Created by Isaac Greenspan on 12/10/15.
//  Copyright © 2015 Isaac Greenspan. All rights reserved.
//

import Foundation

extension API {
    public struct Server {
        let host: String
        
        public static let LiveJournal = Server(host: "www.livejournal.com")
        public static let Blurty = Server(host: "www.blurty.com")
        public static let blogonline_ru = Server(host: "www.blogonline.ru")
        public static let DeadJournal = Server(host: "www.deadjournal.com")
        public static let InsaneJournal = Server(host: "www.insanejournal.com")
        public static let CrazyLife = Server(host: "www.crazylife.org")
        public static let LJ_Rossia_org = Server(host: "lj.rossia.org")
        public static let Scribbld = Server(host: "www.scribbld.com")
        public static let Inksome = Server(host: "www.inksome.com")
        public static let LiveLogCity = Server(host: "www.livelogcity.com")
        public static let IziBlog = Server(host: "www.iziblog.net")
        public static let CommieJournal = Server(host: "www.commiejournal.com")
        public static let LostJournal = Server(host: "www.lostjournal.com")
        public static let JournalFen = Server(host: "www.journalfen.net")
        public static let DreamWidth = Server(host: "www.dreamwidth.org")
        public static let Asks = Server(host: "www.asks.jp")
        public static let BootieJournal = Server(host: "bj.bootie.org")
        public static let Ivanovo = Server(host: "www.lj.ivanovo.ru")
        public static let OpenWeblog = Server(host: "www.openweblog.com")
        public static let Kraslan = Server(host: "lj.kraslan.ru")
        public static let GreatestJournal = Server(host: "www.greatestjournal.com")
        
        var xmlrpcEndpoint: String {
            return "http://\(self.host)/interface/xmlrpc"
        }
        
        var cookieDomain: String {
            var host = self.host
            let wwwRange = host.rangeOfString("www.")
            if let wwwRange = wwwRange
                where wwwRange.startIndex == host.startIndex {
                    host.removeRange(wwwRange)
            }
            return ".\(host)"
        }
    }
}
