//
//  EventsTableViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 22.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit

class EventsTableViewController: UIViewController {
    
    var presenter: EventsTableViewPresenterProtocol!
    
    @IBOutlet weak var removeOldButton: UIButton!
    @IBOutlet weak var rangeSC: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var backToMapButton: UIButton!
    @IBOutlet weak var myEventsButton: UIButton!
    var isMyEvents = false
    
    var eventsForTableView = DataService.shared.events
    var eventsFiltred: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeSC.selectedSegmentIndex = 3
        eventsFiltred = DataService.filtredDateEvents(events: eventsForTableView, range: rangeSC.selectedSegmentIndex)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.backgroundColor = .clear
        eventsTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        searchBar.delegate = self
        searchBar.barTintColor = view.backgroundColor
        print("Элементов для таблицы = ", eventsFiltred.count)
        
        ConfigUI.buttonConfig(button: removeOldButton, titleColor: .red, alfa: 0.8)
        ConfigUI.segmentControlConfig(sc: rangeSC)
        ConfigUI.buttonConfig(button: backToMapButton, titleColor: .systemBlue, alfa: 1)
    
        if DataService.shared.localUser != nil && DataService.shared.localUser.userID == DataService.shared.userAdmin {
            removeOldButton.isHidden = false
            print("user = ", DataService.shared.localUser.userID)
        } else {
            removeOldButton.isHidden = true }
        print("admin = ", DataService.shared.userAdmin)
        print("мои координаты = ", LocationService.shared.latitude, LocationService.shared.longitude)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkStatusMyEvensButton()
        
        eventsForTableView = DataService.shared.events
        eventsFiltred = DataService.filtredDateEvents(events: eventsForTableView, range: rangeSC.selectedSegmentIndex)
        eventsTableView.reloadData()
        removeOldButton.setTitle("  🗑 Old(\(DataService.shared.oldEventsID?.count ?? 0))  ", for: .normal)
        print("отработал viewWillAppear EventsTableViewController")
    }
    
    func checkStatusMyEvensButton() {
        if isMyEvents {
            myEventsButton.setBackgroundImage(UIImage(systemName: "person.fill"), for: .normal)
            rangeSC.isHidden = true
            showAlertMsgWithDelay(title: "ВНИМАНИЕ !", message: "Показаны только Ваши события", delay: 2)
        } else {
            myEventsButton.setBackgroundImage(UIImage(systemName: "person.2"), for: .normal)
            rangeSC.isHidden = false
        }
    }
    
    
    @IBAction func rangeSCAction(_ sender: UISegmentedControl) {
        self.view.endEditing(true)
        eventsFiltred = DataService.filtredDateEvents(events: eventsForTableView, range: sender.selectedSegmentIndex)
        eventsTableView.reloadData()
    }
    
    @IBAction func removeOldEvents() {
        if let oldEvents = DataService.shared.oldEventsID, oldEvents.count > 0 { NetworkService.removeOldEvent(eventsID: oldEvents)
            DataService.shared.oldEventsID?.removeAll()
            removeOldButton.setTitle("  🗑 Old(\(DataService.shared.oldEventsID?.count ?? 0))  ", for: .normal)
        } else { print("Старых событий нет.") }
    }
    
    @IBAction func backButtonTap() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func myEventButtonTap() {
        isMyEvents.toggle()
        checkStatusMyEvensButton()
        eventsFiltred = DataService.filtreUserEvents(events: eventsForTableView, isMy: isMyEvents)
        eventsTableView.reloadData()
    }
    
}

extension EventsTableViewController: EventsTableViewProtocol {
    //////
}

extension EventsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsFiltred.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        cell.backgroundColor = .clear
        let event = eventsFiltred[indexPath.row]
        cell.nameEventLabel.text = "\(event.dateEventString) \(event.nameEvent)"
        cell.discriptionEventLabel.text = event.discriptionEvent
        cell.nickNameEventLabel.text = "Организатор: \(event.userNick)"
        cell.eventImage.image = UIImage(named: event.iconEvent)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService.shared.event = eventsFiltred[indexPath.row]
        DataService.shared.eventID = eventsFiltred[indexPath.row].eventID
        presenter.goToEventScreen()
    }
    
}

extension EventsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        eventsFiltred = eventsForTableView
        
        if searchText.isEmpty == false {
            eventsFiltred = eventsForTableView.filter({ $0.nameEvent.lowercased().contains(searchText.lowercased()) })
        }
        eventsTableView.reloadData()
    }
    
    
}
