//
//  MainScreenPresenter.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import Foundation
import GoogleMaps
import Firebase

/// Вывод информации
protocol MainScreenProtocol: class {
    func setMarkers(markers: [GMSMarker])
}

// это как мы принимаем информацию
protocol MainScreenPresenterProtocol: class {
    init(view: MainScreenProtocol, router: MainScreenRouterProtocol)
    func createMarkers(eventsForMarker: [Event])
    func startLocationService()
    func goAddMarkerScreen()
    func goLoginScreen()
    func goToEventScreen()
    func goToEventTableView()
    func checkUserLoginStatus()
    func checkUserStatus()
    func getOnlineMarkers(range: Int)
    func getOfflineMarkers(range: Int)
}

class MainScreenPresenter: MainScreenPresenterProtocol {
    
    let view: MainScreenProtocol
    let router: MainScreenRouterProtocol
    
    var ref: DatabaseReference!
    var user: User?
    
    required init(view: MainScreenProtocol, router: MainScreenRouterProtocol) {
        self.view = view
        self.router = router
    }///////////////////////////////////////////////////
   
    func startLocationService() {
        LocationService.shared.start()
        print("LocationService запущен")
    }
    
    func checkUserLoginStatus () {
        print("...checkUserLoginStatus")
        Auth.auth().addStateDidChangeListener({[weak self] (auth, user) in
            if user != nil {
                self?.user = user
                NetworkService.loadMyProfile(userId: user!.uid)
                print("данные пользователя загружены")
            }
        })
    }
    
    func checkUserStatus() {
        if self.user != nil {
            print("...user?.uid", user?.uid ?? "")
            self.router.showAccountScreen()
        } else {
            self.router.showLoginScreen()
        }
    }
    
    func goToEventScreen(){
        router.showEventScreen()
    }
    
    func goLoginScreen() {
        router.showLoginScreen()
    }
    
    func goAddMarkerScreen() {
        router.showAddMarkerScreen()
    }
    
    func goToEventTableView() {
        router.showTableViewScreen()
    }
    
    func createMarkers(eventsForMarker: [Event]) {
        let events = eventsForMarker
        var markers: [GMSMarker] = []
        print("Для создания маркеров доступно \(events.count) элементов")
        for event in events {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: event.latEvent, longitude: event.lngEvent) )
            marker.icon = UIImage(named: event.iconEvent)
            marker.title = "\(event.dateEventString) \(event.nameEvent)"
            marker.snippet = event.snipetEvent
            markers.append(marker)
        }
        view.setMarkers(markers: markers)
    }
    
    func getOfflineMarkers(range: Int){
        let events = DataService.shared.events
        let filtredEvents = DataService.filtredDateEvents(events: events, range: range)
        self.createMarkers(eventsForMarker: filtredEvents)
    }
    
    func getOnlineMarkers(range: Int) {
        NetworkService.loadAllEvents(completion: { list, success in
            if success {
                let filtredEvents = DataService.filtredDateEvents(events: list, range: range)
                self.createMarkers(eventsForMarker: filtredEvents)
            }
        })
    }
    
//    func markerFiltred(events: [Event], range: Int) {
//        print("В исходном массиве = \(events.count) элементов")
//        var eventsFiltred:[Event] = []
//        //eventsFiltred.removeAll()
//        let today = Date().timeIntervalSince1970
//        print("Сегодня: ", today, Date(timeIntervalSince1970: today))
//        var interval = 0.0
//        
//        switch range {
//        case 0: interval = today + 86400           //день
//        case 1: interval = today + (86400*7)       //неделя
//        case 2: interval = today + (86400*30)      //месяц
//        default: interval = today + (86400*365)    //год
//        }
//        for event in events {
//            if interval - event.dateEventTI > 0 && (event.dateEventTI + event.lifeTimeEvent - today) > 0 {
//                eventsFiltred.append(event)
//            }
//            if event.dateEventTI + event.lifeTimeEvent < today {
//                DataService.shared.oldEventsID?.append(event.eventID)
//            }
//        }
//        print("В отфильтрованном массиве \(eventsFiltred.count) элементов")
//        print("Старых событий = \(String(describing: DataService.shared.oldEventsID?.count)) ")
//        createMarkers(eventsForMarker: eventsFiltred)
//    }
    

}
