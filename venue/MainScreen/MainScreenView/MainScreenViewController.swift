//
//  ViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit
import GoogleMaps

class MainScreenViewController: UIViewController {
    
    var presenter: MainScreenPresenterProtocol!
    
    @IBOutlet weak var markerButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var intervalSC: UISegmentedControl!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableButton: UIButton!
    @IBOutlet weak var publicEventSC: UISegmentedControl!
    
    
    let infoMarker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        ModuleBulder.mainScreenConfigure(view: self)
        intervalSC.selectedSegmentIndex = 2
        presenter.startLocationService()
        presenter.checkUserLoginStatus()
        infoLabel.textColor = .label
        markerButton.isHidden = true
        publicEventSC.isHidden = true
        ConfigUI.segmentControlConfig(sc: intervalSC)
        ConfigUI.segmentControlConfig(sc: publicEventSC)
        ConfigUI.changeSystemIconColor(button: tableButton, systemName: "table")
        navigationController?.navigationBar.isHidden = true
        mapViewSetup()
        print("старт маркеров на карту")
        presenter.getOnlineMarkers(range: intervalSC.selectedSegmentIndex)
        
        print("DataService>defaultZoom>",DataService.shared.defaultZoom)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear MainScreen")
        checkAccount()
        mapView.clear()
        print("Карта очищена")
        presenter.getOnlineMarkers(range:  intervalSC.selectedSegmentIndex)
        let coordinate = DataService.shared.coordinateEvent
        if coordinate.latitude != 0, coordinate.longitude != 0 {
            mapView.animate(toLocation: coordinate)
            let zoom = DataService.shared.defaultZoom
            mapView.animate(toZoom: zoom)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
      //  NetworkService.stopObservers()
    }

    func checkAccount() {
        if UserDefaults.standard.bool(forKey: "logined"){
            infoLabel.text = ""
            ConfigUI.changeSystemIconColor(button: accountButton, systemName: "person.fill")
            publicEventSC.isHidden = false
            infoLabel.isHidden = true
        } else {
            ConfigUI.changeSystemIconColor(button: accountButton, systemName: "person")
            publicEventSC.isHidden = true
            infoLabel.isHidden = false
            infoLabel.text = "создайте или войдите в свой аккаунт"
        }
    }
    
    func mapViewSetup() {
        mapView.layer.cornerRadius = 25
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.indoorPicker = true
        mapView.animate(toZoom: 11) // поменять !!!
        //mapView.animate(toZoom: DataService.shared.defaultZoom)
    }
    
    
    @IBAction func rangeSCaction(_ sender: UISegmentedControl) {
        mapView.clear()
        presenter.getOfflineMarkers(range:  intervalSC.selectedSegmentIndex)
    }
    
    @IBAction func publicEventCSAction() {
        mapView.clear()
        if publicEventSC.selectedSegmentIndex == 0 {
            DataService.shared.isPrivateUser = false
        } else {
            DataService.shared.isPrivateUser = true
        }
        presenter.getOfflineMarkers(range:  intervalSC.selectedSegmentIndex)
    }
    
    @IBAction func addNewMarkerButtonTap() {
        if DataService.shared.markerDidTapped {
            presenter.goToEventScreen()
        } else { addNewMarker() }
    }
    
    func updateMarkerButton() {
        markerButton.isHidden = false
        if DataService.shared.markerDidTapped {
            markerButton.setTitle("Подробно", for: .normal)
            markerButton.backgroundColor = UIColor(white: 1, alpha: 0.3)
            markerButton.setTitleColor(.white, for: .normal)
        } else {
            markerButton.setTitle("Добавить событие", for: .normal)
            markerButton.backgroundColor = UIColor(white: 1, alpha: 1)
            markerButton.setTitleColor(ConfigUI.shared.greenVenue, for: .normal)
        }
    }
    
    @IBAction func accountButtonTap() {
        presenter.checkUserStatus()
    }
    
    @IBAction func tableViewButtonTap() {
        presenter.goToEventTableView()
    }
    
    
    func addNewMarker() {
        if UserDefaults.standard.bool(forKey: "logined") {
            presenter.goAddMarkerScreen()
        } else {
            infoLabel.text = "создайте или войдите в свой аккаунт"
        }
    }
    
    
} //ViewController

extension MainScreenViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        mapView.clear()
        presenter.getOfflineMarkers(range:  intervalSC.selectedSegmentIndex)
        DataService.shared.markerDidTapped = false
        updateMarkerButton()
        UIPasteboard.general.string = "\(coordinate.latitude) \(coordinate.longitude)"
        DataService.shared.coordinateEvent = coordinate
        DataService.shared.placeEvent = ""
        DataService.shared.event = nil // обнуление события после сохранения
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("\(marker.title ?? "No marker")")
        DataService.shared.markerDidTapped = true
        DataService.shared.marker = marker
        DataService.shared.coordinateEvent = marker.position
        updateMarkerButton()
        UIPasteboard.general.string = "\(marker.position.latitude) \(marker.position.longitude)"
        return false
    }
    
    // Attach an info window to the POI using the GMSMarker.
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        infoMarker.position = location
        infoMarker.title = name
        infoMarker.opacity = 0
        DataService.shared.coordinateEvent = location
        DataService.shared.placeEvent = name
        DataService.shared.markerDidTapped = false
        updateMarkerButton()
        UIPasteboard.general.string = "\(location.latitude) \(location.longitude)"
        infoMarker.map = mapView
        mapView.selectedMarker = infoMarker
    }
    
   
    
}


extension MainScreenViewController: MainScreenProtocol {
    
    func startMap() {  /// настроить запуск после обновления координат
        print("\nSTART MAP")
        if let myLocation = mapView.myLocation {
            print("myLocation", myLocation)
            mapView.animate(toLocation: myLocation.coordinate)
            mapView.animate(toZoom: DataService.shared.defaultZoom)
        }
    }
    
    func mapGoMyLocation(location: CLLocationCoordinate2D){
        mapView.animate(toLocation: location)
    }
    
    func setMarkers(markers: [GMSMarker]) {
        for marker in markers {
            marker.map = mapView
        }
    }
    
    
}
