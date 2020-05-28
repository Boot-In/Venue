//
//  NetworkService.swift
//  venue
//
//  Created by Dmitriy Butin on 24.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import Firebase
import GoogleMaps
//import CoreLocation

class NetworkService {
    static let shared = NetworkService()
    
    static func stopObservers(){
        let ref = Database.database().reference()
        ref.removeAllObservers()
        print("Наблюдатель удалён")
    }
    
    static func removeEvent(event: Event) {
        let ref = Database.database().reference()
        let eventRef = ref.child("events").child(event.eventID)
        eventRef.removeValue()
        print("Event removed!")
    }
    static func saveNewEvent(event: Event) {
        
        func getEventID() -> String {
            var iD = ""
            iD += String(event.userID[event.userID.startIndex]).lowercased()
            iD += String(Int(event.dateEventTI))
            iD += String(event.userID[event.userID.index(before: event.userID.endIndex)]).lowercased()
            iD += String(event.nameEvent.count)
            iD += String(Int(event.latEvent))+String(Int(event.lngEvent))
            return iD
        }
        
        let ref = Database.database().reference()
        let eventRef = ref.child("events").child(getEventID())
        eventRef.setValue([
            "userID" : event.userID,
            "eventID" : getEventID(),
            "userNick": event.userNick,
            "nameEvent" : event.nameEvent,
            "latEvent" : event.latEvent,
            "lngEvent" : event.lngEvent,
            "dateEventString" : event.dateEventString,
            "dateEventTI" : event.dateEventTI,
            "snipetEvent" : event.snipetEvent,
            "discriptionEvent" : event.discriptionEvent,
            "iconEvent" : event.iconEvent,
            "lifeTimeEvent" : event.lifeTimeEvent
        ])
        print("saveEvent Complete !")
        print("EventID = \(getEventID())")
    }
    
    static func updateEvent(event: Event) {
        let ref = Database.database().reference()
        let eventRef = ref.child("events").child(event.eventID)
        eventRef.updateChildValues([
            "userID" : event.userID,
            "eventID" : event.eventID,
            "userNick": event.userNick,
            "nameEvent" : event.nameEvent,
            "latEvent" : event.latEvent,
            "lngEvent" : event.lngEvent,
            "dateEventString" : event.dateEventString,
            "dateEventTI" : event.dateEventTI,
            "snipetEvent" : event.snipetEvent,
            "discriptionEvent" : event.discriptionEvent,
            "iconEvent" : event.iconEvent,
            "lifeTimeEvent" : event.lifeTimeEvent
        ])
        print("saveUpdateEvent Complete !")
        print("EventID = \(event.eventID)")
    }

    
    static func removeOldEvent(eventsID: [String]) {
        print("Запущен процесс удаления старых событий")
        let ref = Database.database().reference()
        for eventID in eventsID {
            let eventRef = ref.child("events").child(eventID)
            eventRef.removeValue()
        }
    }

    static func loadAllEvents( completion: @escaping (_ list: [Event], _ success: Bool) -> Void) {
        let ref = Database.database().reference().child("events")
        print("... loadAllEvents > events")
        var eventsFromNet = [Event]()
       // DataService.shared.events.removeAll()
        
       // ref.observe(.value, with: { (snapshot) in //реагирует на любое изменение в Базе Данных
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                let event = Event(snapshot: item as! DataSnapshot)
                eventsFromNet.append(event) 
            }
            eventsFromNet.sort {$0.dateEventTI < $1.dateEventTI }
            DataService.shared.events = eventsFromNet
            print("загружено \(eventsFromNet.count) элементов")
            print("Элементы помещены в массив \(DataService.shared.events.count)")
            completion(eventsFromNet, true)
        }) { (error) in
            print(error.localizedDescription)
            completion(eventsFromNet, false)
        }
    }
    
    
    static func loadMyProfile (userId: String) {
        print("loadMyProfile>userId>",userId)
        let ref = Database.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print("loadMyProfile")
            let firstUserName = value?["firstUserName"] as? String ?? ""
            let nickNameUser = value?["nickNameUser"] as? String ?? ""
            let secondNameUser = value?["secondNameUser"] as? String ?? ""
            let userMail = value?["userMail"] as? String ?? ""
            let profile = Profile(userID: userId, userMail: userMail, firstUserName: firstUserName, secondNameUser: secondNameUser, niсkNameUser: nickNameUser)
            DataService.shared.localUser = profile
            print("Сохранён профиль для ", profile.firstUserName)
            UserDefaults.standard.set(nickNameUser, forKey: "nickNameUser")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func followMe() {
        print("\n--- Выполнение Follow Me ----")
        let eventID = DataService.shared.eventID
        guard let localUser = DataService.shared.localUser else { return }
        print("eventID = ", eventID, "\nUserID = ", localUser.userID, "\nniсkNameUser = ", localUser.niсkNameUser)
        let ref = Database.database().reference()
        let eventRefKey = ref.child("events").child(eventID).child("followEventUsers")
        let update = ["\(localUser.userID)": localUser.niсkNameUser]
        eventRefKey.updateChildValues(update)
        print("--- save Follow Event Complete ! ---\n")
    }
    
    static func removeFollow() {
        print("\n--- Удаление Follow ----")
        let eventID = DataService.shared.eventID
        guard let localUser = DataService.shared.localUser else { return }
        print("eventID = ", eventID, "\nUserID = ", localUser.userID, "\nniсkNameUser = ", localUser.niсkNameUser)
        let ref = Database.database().reference()
        let eventRefKey = ref.child("events").child(eventID).child("followEventUsers").child(localUser.userID)
        eventRefKey.removeValue()
        print("--- Follow removed! ---\n")
    }
    
    
}

