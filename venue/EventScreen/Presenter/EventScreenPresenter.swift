//
//  EventScreenPresenter.swift
//  venue
//
//  Created by Dmitriy Butin on 21.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import GoogleMaps
import Firebase
/// Вывод информации
protocol EventScreenProtocol: class {
    
    func hideFollowButton()
    func removeButtonSetting(hide: Bool)
    func setTextToView(nickName: String, eventData: String, eventName: String, eventCategory: String, eventDiscription: String, index: Int)
}

// это как мы принимаем информацию
protocol EventScreenPresenterProtocol: class {
    init(view: EventScreenProtocol, router: EventScreenRouterProtocol)
    
    func loadEventInfo(event: Event)
    func markerToEvent()
    func goToEdit()

}

class EventScreenPresenter: EventScreenPresenterProtocol {
    
    let view: EventScreenProtocol
    let router: EventScreenRouterProtocol
    
    required init(view: EventScreenProtocol, router: EventScreenRouterProtocol) {
        self.view = view
        self.router = router
    }///////////////////////////////////////////////////
   
    func loadEventInfo(event: Event) {
        print("eventID: ", event.eventID)
        let index = DataService.searchIndexEvent(event: event)
        view.setTextToView(nickName: "Организатор: \(event.userNick)", eventData: event.dateEventString, eventName: event.nameEvent, eventCategory: event.snipetEvent, eventDiscription: event.discriptionEvent, index: index)
        
        guard DataService.shared.localUser != nil else {
            view.removeButtonSetting(hide: true)
            view.hideFollowButton(); return }
        
        if event.userID == DataService.shared.localUser.userID {
            view.removeButtonSetting(hide: false)
        } else { view.removeButtonSetting(hide: true) }
    }

    func markerToEvent() {
        guard let marker = DataService.shared.marker else { return }
        guard let event = searchEvent(marker: marker) else { return }
        loadEventInfo(event: event)
    }
    
    func searchEvent(marker: GMSMarker) -> Event? {
        let events = DataService.shared.events
        var events_ = events
        var i = (events_.count - 1)
        while i >= 0 {
            if marker.title != "\(events_[i].dateEventString) \(events_[i].nameEvent)" {
                events_.remove(at: i)
            } else if marker.position.latitude != events_[i].latEvent && marker.position.longitude != events_[i].lngEvent {
                events_.remove(at: i)
            }
            i -= 1
        }
        print("Мероприятий = ", events_.count)
        if let event = events_.last {
            DataService.shared.eventID = event.eventID
            DataService.shared.event = event
        }
        return events_.last
    }
    
    
    func goToEdit() {
        router.showAddMarkerScreen()
    }

    
    
}
