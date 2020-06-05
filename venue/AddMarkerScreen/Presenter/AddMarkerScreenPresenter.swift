//
//  AddMarkerScreenPresenter.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

/// Вывод информации
protocol AddMarkerScreenProtocol: class {
    func fieldInfo(nik: String, name: String, category: String, icon: String, discription: String)
    func setCategory(name: String, imageName: String)
}

// это как мы принимаем информацию
protocol AddMarkerScreenPresenterProtocol: class {
    init(view: AddMarkerScreenProtocol, router: AddMarkerScreenRouterProtocol)
    
    func saveEvent(nameEvent: String, iconEvent: String, discrEvent: String)
    func updateEvent(event: Event, nameEvent: String, iconEvent: String, discrEvent: String)
    func loadTFFromEvent(event: Event)
    func showCategory()
}

class AddMarkerScreenPresenter: AddMarkerScreenPresenterProtocol {
    
    let view: AddMarkerScreenProtocol
    let router: AddMarkerScreenRouterProtocol
    
    required init(view: AddMarkerScreenProtocol, router: AddMarkerScreenRouterProtocol) {
        self.view = view
        self.router = router
       
    }///////////////////////////////////////////////////
   
    func loadTFFromEvent(event: Event) {
        let coordinate = CLLocationCoordinate2D(latitude: event.latEvent, longitude: event.lngEvent)
        DataService.shared.coordinateEvent = coordinate
        view.fieldInfo(nik: event.userNick, name: event.nameEvent, category: event.snipetEvent, icon: event.iconEvent, discription: event.discriptionEvent)
    }
    
    func saveEvent(nameEvent: String, iconEvent: String, discrEvent: String) {
        let coordinate = DataService.shared.coordinateEvent
        let date = DataService.shared.dateEvent
        guard let user = Auth.auth().currentUser else { return }
        let userNick = DataService.shared.localUser.niсkNameUser
        var event = Event(userID: user.uid, userNick: userNick, nameEvent: nameEvent, coordinate: coordinate, date: date)
        event.dateEventString = DataService.shared.dataEventString
        event.iconEvent = iconEvent
        event.discriptionEvent = discrEvent
        event.snipetEvent = DataService.shared.categoryEvent
        event.eventID = DataService.getEventID(event: event)
        /// Сохранение в сеть и добавление локально
        NetworkService.saveNewEvent(event: event)
        ///
        DataService.shared.event = event
        
        if DataService.shared.isPrivateEvent {
            DataService.shared.privateEvents.append(event)
        } else {
            DataService.shared.events.append(event)
        }
        print("Добавлено событие EventID: ", DataService.shared.event.eventID)
    }
    
//    func getEventID(event: Event) -> String {
//        var iD = ""
//        iD += String(event.userID[event.userID.startIndex]).lowercased()
//        iD += String(Int(event.dateEventTI))
//        iD += String(event.userID[event.userID.index(before: event.userID.endIndex)]).lowercased()
//        iD += String(event.nameEvent.count)
//        iD += String(Int(abs(event.latEvent))) + String(Int(abs(event.lngEvent)))
//        return iD
//    }
    
    func updateEvent(event: Event, nameEvent: String, iconEvent: String, discrEvent: String) {
        let date = DataService.shared.dateEvent
        var events = DataService.shared.events
        var eventUpd = event
        eventUpd.dateEventString = DataService.shared.dataEventString
        eventUpd.nameEvent = nameEvent
        eventUpd.iconEvent = iconEvent
        eventUpd.discriptionEvent = discrEvent
        eventUpd.snipetEvent = DataService.shared.categoryEvent
        eventUpd.dateEventTI = date.timeIntervalSince1970
        /// Сохранение
        NetworkService.updateEvent(event: eventUpd)
        DataService.shared.event = eventUpd
        /// Замена в локальном массиве.
        if DataService.shared.isPrivateEvent {
            events = DataService.shared.privateEvents
        }
        let i = DataService.searchIndexEvent(event: event, fromEvents: events)
        if DataService.shared.isPrivateEvent {
            DataService.shared.privateEvents[i] = eventUpd
        } else {
            DataService.shared.events[i] = eventUpd
        }
    }

    func showCategory() {
        router.showCategoryModule(addMarkerView: self.view)
    }

}
