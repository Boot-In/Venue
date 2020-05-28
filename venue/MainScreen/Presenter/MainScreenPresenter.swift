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
                UserDefaults.standard.set(true, forKey: "logined")
                NetworkService.loadMyProfile(userId: user!.uid)
                print("данные пользователя загружены")
            } else {
                UserDefaults.standard.set(false, forKey: "logined")
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
            marker.snippet = "Желающих: \(event.followEventUsers.count)\nКатегория: \(event.snipetEvent)"
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
    

}
