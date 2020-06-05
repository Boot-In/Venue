//
//  DataService.swift
//  venue
//
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import GoogleMaps
//import CoreLocation

class DataService {
    static var shared = DataService()
    
    var userAdmin: String = "No Admin"
    var defaultZoom: Float = 16
    var coordinateEvent = CLLocationCoordinate2D()
    var placeEvent = String()
    var dateEvent = Date()
    var dataEventString = String()
    var categoryEvent = String()
   // var categoryEvent = ("Без категории", "marker-icon")
    var events = [Event]()
    var privateEvents = [Event]()
    var isPrivateEvent = false
    var isPrivateUser = false
    var oldEventsID: [String]? = []
    var event: Event!
    var eventID = String()
    var localUser: Profile!
    var markerDidTapped = false
    var marker: GMSMarker!
    
    let categoryArray = [("Спорт", "sport-marker"), ("Игры", "table_games"), ("Концерты", "music-marker"), ("Детское мероприятие", "baby-marker"), ("Вечеринка","party-marker"), ("Природа","forest-marker"), ("Обучение","learning-marker"), ("Красота","beuty-marker"), ("Бизнес","busines-marker"), ("Еда","food-marker"), ("Городское мероприятие","city-marker")]
    
    static func filtredRadiusEvents(events: [Event], radius: Int) -> ([Event], Int) {
        print("В исходном массиве = \(events.count) элементов")
        var eventsFiltred:[Event] = []
        let lat = LocationService.shared.latitude
        let lng = LocationService.shared.longitude
        var interval = 0.0
        var intRad = 0
        
        switch radius {
        case 1: interval = 5/111.11 ; intRad = 5          //5 км
        case 2: interval = 10/111.11 ; intRad = 10        //10 км
        case 3: interval = 15/111.11 ; intRad = 15        //15 км
        case 4: interval = 20/111.11 ; intRad = 20        //20 км
        case 5: interval = 25/111.11 ; intRad = 25        //25 км
        case 6: interval = 50/111.11 ; intRad = 50        //50 км
        case 7: interval = 100/111.11 ; intRad = 100      //100 км
        case 8: interval = 250/111.11 ; intRad = 250      //250 км
        case 9: interval = 500/111.11 ; intRad = 500      //500 км
        default: interval = 0 ; intRad = 0                // all
        }
        
        var latMin = lat - interval
        if latMin < -90 { latMin = -90 }
        var latMax = lat + interval
        if latMax > 90 { latMax = 90 }
        
        var lngMin = lng - interval
        if lngMin < -180 { lngMin = 180 + (lng-interval + 180) }
        var lngMax = lng + interval
        if lngMax > 180 { lngMax = -180 + (lng+interval - 180) }
        print("lngMin = ",lngMin, "lngMax = ", lngMax)
        print("latMin = ",latMin, "latMax = ", latMax)
        
        for event in events {
            guard event.latEvent < latMax, event.latEvent > latMin else { continue }
            guard event.lngEvent < lngMax, event.lngEvent > lngMin else { continue }
            eventsFiltred.append(event)
        }
        if interval == 0 { eventsFiltred = events }
        eventsFiltred.sort { $0.dateEventTI < $1.dateEventTI }
        print("В отфильтрованном массиве \(eventsFiltred.count) элементов")
        print("Старых событий = \(String(describing: DataService.shared.oldEventsID?.count)) ")
        return (eventsFiltred, intRad)
    }
    
    static func filtredDateEvents(events: [Event], range: Int) -> [Event] {
        print("В исходном массиве = \(events.count) элементов")
        var eventsFiltred:[Event] = []
        let today = Date().timeIntervalSince1970
        print("Сегодня: ", today, Date(timeIntervalSince1970: today))
        DataService.shared.oldEventsID?.removeAll()
        var interval = 0.0
        
        switch range {
        case 0: interval = today + 86400           //день
        case 1: interval = today + (86400*7)       //неделя
        case 2: interval = today + (86400*30)      //месяц
        default: interval = today + (86400*365)    //год
        }
        for event in events {
            if interval - event.dateEventTI > 0 && (event.dateEventTI + event.lifeTimeEvent - today) > 0 {
                eventsFiltred.append(event)
            }
            if event.dateEventTI + event.lifeTimeEvent < today {
                DataService.shared.oldEventsID?.append(event.eventID)
            }
        }
        eventsFiltred.sort { $0.dateEventTI < $1.dateEventTI }
        print("В отфильтрованном массиве \(eventsFiltred.count) элементов")
        print("Старых событий = \(String(describing: DataService.shared.oldEventsID?.count)) ")
        return eventsFiltred
    }
    
    static func filtredUserEvents(events: [Event]) -> [Event] {
        print("В исходном массиве = \(events.count) элементов")
        var eventsFiltred:[Event] = []
        guard DataService.shared.localUser != nil else { return events }
       // guard isMy else { return events }
        for event in events {
            if event.userID == DataService.shared.localUser.userID {
                eventsFiltred.append(event)
            }
        }
        
        eventsFiltred.sort { $0.dateEventTI < $1.dateEventTI }
        print("В отфильтрованном массиве \(eventsFiltred.count) элементов")
       
        return eventsFiltred
    }
    
    static func searchIndexEvent(event: Event, fromEvents: [Event]) -> Int {
        var index = 0
        let events = fromEvents
        for i in 0..<events.count {
            if events[i].eventID == event.eventID {
                index = i
            }
        }
        return index
    }
    
    static func getEventID(event: Event) -> String {
        var iD = ""
        iD += String(event.userID[event.userID.startIndex]).lowercased()
        iD += String(Int(event.dateEventTI))
        iD += String(event.userID[event.userID.index(before: event.userID.endIndex)]).lowercased()
        iD += String(event.nameEvent.count)
        iD += String(Int(abs(event.latEvent))) + String(Int(abs(event.lngEvent)))
        return iD
    }
    
   static func checkMyFollow(event: Event) -> Bool {
        for nick in event.followEventUsers {
            if DataService.shared.localUser != nil && nick.key == DataService.shared.localUser.userID {
                return true
            }
        }
        return false
    }
    
    static func dateTItoString(dateTI: Double) -> (String, String){
        let date = Date(timeIntervalSince1970: dateTI)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateDMY = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let dateHM = dateFormatter.string(from: date)
        return(dateDMY, dateHM)
    }
    
    static func iconColor(count: Int) -> UIColor {
        switch count {
        case 0: return .systemGreen
        case 1...5: return .systemBlue
        case 6...10: return .blue
        case 11...25: return .darkGray
        case 26...50: return .purple
        case 51...100: return .orange
        case 101...500: return .red
        default: return .black
        }
    }
    
}
