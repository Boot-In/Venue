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
    var defaultZoom: Int = 16
    var coordinateEvent = CLLocationCoordinate2D()
    var placeEvent = String()
    var dateEvent = Date()
    var dataEventString = String()
    var categoryEvent = String()
    var events = [Event]()
    var oldEventsID: [String]? = []
    var event: Event!
    var eventID = String()
    var localUser: Profile!
    var fallowUsers: [String] = []
    var markerDidTapped = false
    var marker: GMSMarker!
    
    
    static func filtredDateEvents(events: [Event], range: Int) -> [Event] {
        print("В исходном массиве = \(events.count) элементов")
        var eventsFiltred:[Event] = []
        let today = Date().timeIntervalSince1970
        print("Сегодня: ", today, Date(timeIntervalSince1970: today))
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
    
}
