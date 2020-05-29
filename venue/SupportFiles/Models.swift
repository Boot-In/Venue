//
//  Models.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import GoogleMaps
import Firebase

struct Event {
    let userID: String
    let userNick: String
    let nameEvent: String
    let latEvent: Double
    let lngEvent: Double
    var dateEventTI: Double
    var eventID: String = ""
    var dateEventString: String = ""
    var snipetEvent: String = ""
    var discriptionEvent: String = ""
    var iconEvent: String = "marker-icon"
    var lifeTimeEvent: Double = 86400
    var followEventUsers = [String : String]()
    let ref: DatabaseReference?
    
    init(userID: String, userNick: String, nameEvent: String, coordinate: CLLocationCoordinate2D, date: Date ) {
        self.userID = userID
        self.userNick = userNick
        self.nameEvent = nameEvent
        self.latEvent = coordinate.latitude
        self.lngEvent = coordinate.longitude
        self.dateEventTI = date.timeIntervalSince1970
        self.ref = nil
    }
        init(snapshot: DataSnapshot) {
            let snapshotValue = snapshot.value as! [String: AnyObject]
            userID = snapshotValue["userID"] as! String
            userNick = snapshotValue["userNick"] as! String
            nameEvent = snapshotValue["nameEvent"] as! String
            latEvent = snapshotValue["latEvent"] as! Double
            lngEvent = snapshotValue["lngEvent"] as! Double
            dateEventTI = snapshotValue["dateEventTI"] as! Double
            eventID = snapshotValue["eventID"] as! String
            dateEventString = snapshotValue["dateEventString"] as! String
            snipetEvent = snapshotValue["snipetEvent"] as! String
            discriptionEvent = snapshotValue["discriptionEvent"] as! String
            iconEvent = snapshotValue["iconEvent"] as! String
            lifeTimeEvent = snapshotValue["lifeTimeEvent"] as! Double
            
            if snapshotValue["followEventUsers"] != nil {
                followEventUsers = snapshotValue["followEventUsers"] as! [String: String]
            }
            
            ref = snapshot.ref
        }
}


struct Profile {
    let userID: String
    let userMail: String
    var password: String = ""
    
    let firstUserName: String
    let secondNameUser: String
    let niсkNameUser: String
}

