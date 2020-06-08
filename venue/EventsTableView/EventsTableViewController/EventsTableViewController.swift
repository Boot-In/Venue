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
    @IBOutlet weak var rangeStepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    var isMyEvents = false
    var stepValue: Double = 0
    var segmentIndex: Int = 0
    
    var eventsForTableView = DataService.shared.events
    var eventsFiltred: [Event]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataService.shared.localUser != nil {
            myEventsButton.isHidden = false
        } else { myEventsButton.isHidden = true }
        
        if DataService.shared.isPrivateUser {
            eventsForTableView = DataService.shared.privateEvents
            myEventsButton.isHidden = true
        }
        
        segmentIndex = UserDefaults.standard.integer(forKey: "segmentIndex")
        rangeSC.selectedSegmentIndex = segmentIndex
        
        eventsFiltred = DataService.filtredDateEvents(events: eventsForTableView, range: rangeSC.selectedSegmentIndex)
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.backgroundColor = .clear
        eventsTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        rangeStepper.minimumValue = 0
        rangeStepper.maximumValue = 9
    
        /// текущее значение через DefaultSetting
        stepValue = UserDefaults.standard.double(forKey: "stepValue")
        rangeStepper.value = stepValue
        
        searchBar.delegate = self
        searchBar.barTintColor = view.backgroundColor
        print("Элементов для таблицы = ", eventsFiltred.count)
        
        ConfigUI.buttonConfig(button: removeOldButton, titleColor: .red, alfa: 0.3)
        ConfigUI.segmentControlConfig(sc: rangeSC)
        ConfigUI.buttonConfig(button: backToMapButton, titleColor: .white, alfa: 0.0)
    
        if DataService.shared.localUser != nil && DataService.shared.localUser.userID == DataService.shared.userAdmin {
            removeOldButton.isHidden = false
            print("user = ", DataService.shared.localUser.userID)
        } else {
            removeOldButton.isHidden = true
        }
        
        print("admin = ", DataService.shared.userAdmin)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataService.shared.isPrivateUser {
            eventsForTableView = DataService.shared.privateEvents
            isMyEvents = true
            rangeSC.isHidden = true
            rangeStepper.isHidden = true
            myEventsButton.isHidden = true
            stepperLabel.text = "личные (приватные) события"
        } else {
            eventsForTableView = DataService.shared.events
        }

        checkStatusMyEvensButton()
        
        if isMyEvents { eventsFiltred = DataService.filtredUserEvents(events: eventsForTableView)
        } else {
            filtredStepper(stepVal: Int(stepValue))
        }
        eventsTableView.reloadData()
        removeOldButton.setTitle(" 🗑 (\(DataService.shared.oldEventsID?.count ?? 0)) ", for: .normal)
        print("отработал viewWillAppear EventsTableViewController")
    }
    
    func checkStatusMyEvensButton() {
        if isMyEvents {
            myEventsButton.setBackgroundImage(UIImage(systemName: "person.fill"), for: .normal)
            rangeSC.isHidden = true
            rangeStepper.isHidden = true
        } else {
            myEventsButton.setBackgroundImage(UIImage(systemName: "person.2"), for: .normal)
            rangeSC.isHidden = false
            rangeStepper.isHidden = false
        }
    }
    
    
    @IBAction func rangeSCAction(_ sender: UISegmentedControl) {
        segmentIndex = sender.selectedSegmentIndex
        UserDefaults.standard.set(segmentIndex, forKey: "segmentIndex")
        self.view.endEditing(true)
        filtredStepper(stepVal: Int(stepValue))

    }
    
    @IBAction func removeOldEvents() {
        if let oldEvents = DataService.shared.oldEventsID, oldEvents.count > 0 { NetworkService.removeOldEvent(eventsID: oldEvents)
            DataService.shared.oldEventsID?.removeAll()
            removeOldButton.setTitle(" 🗑 (\(DataService.shared.oldEventsID?.count ?? 0)) ", for: .normal)
        } else { print("Старых событий нет.") }
    }
    
    @IBAction func backButtonTap() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func rangeStepperAction(_ sender: UIStepper) {
        stepValue = sender.value
        UserDefaults.standard.set(stepValue, forKey: "stepValue")
        filtredStepper(stepVal: Int(stepValue))
    }
    
    func filtredStepper(stepVal: Int) {
        eventsFiltred = DataService.filtredDateEvents(events: eventsForTableView, range: rangeSC.selectedSegmentIndex)
        
        let rs = DataService.filtredRadiusEvents(events: eventsFiltred, radius: stepVal).1
        if rs == 0 { stepperLabel.text = "Радиус событий: \nБез ограничений" } else { stepperLabel.text = "Радиус событий:\n\(rs) км." }
        eventsFiltred = DataService.filtredRadiusEvents(events: eventsFiltred, radius: stepVal).0
        eventsTableView.reloadData()
    }
    
    @IBAction func myEventButtonTap() {
        isMyEvents.toggle()
        checkStatusMyEvensButton()
        if isMyEvents {
            stepperLabel.text = "отфильтрованы все Ваши события"
            eventsFiltred = DataService.filtredUserEvents(events: eventsForTableView)
            eventsTableView.reloadData()
        } else {
            filtredStepper(stepVal: Int(stepValue))
        }
    }
    
}


extension EventsTableViewController: EventsTableViewProtocol {
    
}

extension EventsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsFiltred.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventTableViewCell
        cell.backgroundColor = .clear
        let event = eventsFiltred[indexPath.row]
        
        cell.nameEventLabel.text = "\(DataService.dateTItoString(dateTI: event.dateEventTI).0) \(event.nameEvent)"
        cell.nickNameEventLabel.text = "Организатор: \(event.userNick)"
        cell.startEventLabel.text = "Начало: \(DataService.dateTItoString(dateTI: event.dateEventTI).1)"
        cell.eventImage.image = UIImage(named: event.iconEvent)?.overlayImage(color: .white)
        if DataService.checkMyFollow(event: eventsFiltred[indexPath.row]) {
            cell.flagLabel.text = "\(event.followEventUsers.count) ⚑ "
        } else { cell.flagLabel.text = "\(event.followEventUsers.count) ⚐ " }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataService.shared.event = eventsFiltred[indexPath.row]
        presenter.goToEventScreen()
    }
    
    //    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    //        tableView.isEditing = false
    //        return .none
    //    }
    
    // свайп влево  (удаление)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let event = eventsFiltred[indexPath.row]
        let delete = deleteProperty(at: indexPath)
        guard DataService.shared.localUser != nil, DataService.shared.localUser.userID == event.userID else { return nil }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    //Declare this method in Viewcontroller Main and modify according to your need
    
    func deleteProperty(at indexPath: IndexPath) -> UIContextualAction {
        let event = eventsFiltred[indexPath.row]
        let events = DataService.shared.isPrivateUser ? DataService.shared.privateEvents : DataService.shared.events
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completion) in
            
            self.alertAskConfirmation(title: "ВНИМАНИЕ !", message: "Вы действительно хотите удалить событие ?") { (result) in
                if result { print ("Удаление")
                    //Removing from array at selected index
                    NetworkService.removeEvent(event: event)  //Вернуть !!!
                    let index = DataService.searchIndexEvent(event: event, fromEvents: events)
                    
                    if DataService.shared.isPrivateUser { // проверка на приватность
                        DataService.shared.privateEvents.remove(at: index)
                    } else {
                        DataService.shared.events.remove(at: index) // из основного
                    }
                    
                    self.eventsFiltred.remove(at: indexPath.row) //из отфильтрованного
                    print("событие удалено из массива!")
                    self.eventsTableView.deleteRows(at: [indexPath], with: .automatic)
                    completion(true)
                    
                } else { print ("Отмена")
                    self.eventsTableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        action.backgroundColor = .red //cell background color
        return action
    }
    
    /// свайп вправо (Редактирование)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let event = eventsFiltred[indexPath.row]
        let edit = editProperty(at: indexPath)
        guard DataService.shared.localUser != nil, DataService.shared.localUser.userID == event.userID else { return nil }
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func editProperty(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Изменить") { (action, view, completion) in
            
            self.alertAskConfirmation(title: "ВНИМАНИЕ !", message: "Вы действительно хотите редактировать событие ?") { (result) in
                if result { print ("Редактирование")
                    DataService.shared.event = self.eventsFiltred[indexPath.row]
                    self.presenter.goToEdit()
                    completion(true)
                } else { print ("Отмена")
                    self.eventsTableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
        action.backgroundColor = .orange
        return action
    }
    
}

extension EventsTableViewController: UISearchBarDelegate {
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        eventsFiltred = eventsForTableView
        
        if searchText.isEmpty == false {
            eventsFiltred = eventsForTableView.filter({ $0.nameEvent.lowercased().contains(searchText.lowercased()) || $0.snipetEvent.lowercased().contains(searchText.lowercased()) || $0.userNick.lowercased().contains(searchText.lowercased()) })
        }
        eventsTableView.reloadData()
    }
    
}
