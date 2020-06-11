//
//  EventScreenViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 21.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit
import GoogleMaps

class EventScreenViewController: UIViewController {
    
    var presenter: EventScreenPresenterProtocol!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var eventDataLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventCategoryLabel: UILabel!
    @IBOutlet weak var eventDiscriptionTV: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var cancelFollowButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var goToMapButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeButton.isHidden = true ///пока не задействована
        
        goButton.isHidden = false
        cancelFollowButton.isHidden = true
        
        eventDiscriptionTV.backgroundColor? = UIColor(white: 1, alpha: 0.3)
        eventDiscriptionTV.textColor = .label
        
        ConfigUI.buttonConfig(button: goButton, titleColor: ConfigUI.shared.greenVenue, alfa: 1)
        ConfigUI.buttonConfig(button: cancelFollowButton, titleColor: .red, alfa: 1)
        ConfigUI.buttonConfig(button: editButton, titleColor: .orange, alfa: 0.3)
        ConfigUI.buttonConfig(button: removeButton, titleColor: .systemRed, alfa: 0.3)
        ConfigUI.buttonConfig(button: backButton, titleColor: .white, alfa: 0)
        
        infoLabel.alpha = 0
        eventDiscriptionTV.isEditable = false
        if let event = DataService.shared.event {
            presenter.loadEventInfo(event: event)
        } else { presenter.markerToEvent() }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let event = DataService.shared.event {
            presenter.loadEventInfo(event: event )
            print("отработал viewWillAppear EventScreen")
        }
    }
    
    func checkFollowUserStatus() {
        if let event = DataService.shared.event {
            print("...event>Name>", event.nameEvent)
            print("...event>followEventUsersCount>", event.followEventUsers.count)
            
            for nick in event.followEventUsers {
                if DataService.shared.localUser != nil && nick.key == DataService.shared.localUser.userID {
                    goButton.isHidden = true
                    cancelFollowButton.isHidden = false
                    self.displayWarningLabel(withText: "Ваш голос принят !")
                }
                print("key>",nick.key, "   value>", nick.value)
            }
        }
    }
    
    
    @IBAction func cancelFollowAction() {
        NetworkService.removeFollow()
        goButton.isHidden = false
        cancelFollowButton.isHidden = true
        //print("до удаления:", DataService.shared.events[index].followEventUsers)
        if DataService.shared.isPrivateUser {
            DataService.shared.privateEvents[index].followEventUsers.removeValue(forKey: DataService.shared.localUser.userID)
        } else {
            DataService.shared.events[index].followEventUsers.removeValue(forKey: DataService.shared.localUser.userID)
        }
       // print("После удаления:", DataService.shared.events[index].followEventUsers)
        displayWarningLabel(withText: "Ваш голос убран")
        //checkFollowUserStatus()
    }
    
    @IBAction func subscribeButtonTap() {
        alertAskConfirmation(title: "ВНИМАНИЕ !", message: "Вы хотите подписаться на данного организатора ?") { (result) in
            if result {
                /////code
            }
        }
    }
    
    @IBAction func closeWindow() {
        DataService.shared.event = nil
        self.dismiss(animated: true)
    }
    
    @IBAction func editButtonAction() {
        self.alertAskConfirmation(title: "ВНИМАНИЕ !", message: "Вы действительно хотите редактировать событие ?") { (result) in
            if result { print ("Редактирование")
                self.presenter.goToEdit()
            } else { print ("Отмена") }
        }
    }
    
    @IBAction func removeEventButtonTap() {
        alertAskConfirmation(title: "ВНИМАНИЕ !", message: "Вы действительно хотите удалить событие ?") { (result) in
            if result { print ("Удаление")
                guard let event = DataService.shared.event else { return }
                print("нажали кнопку удалять:", event.eventID)
                NetworkService.removeEvent(event: event)
                DataService.shared.event = nil /// сделать после обработки удаления !
                print("событие обнулено!")
                if DataService.shared.isPrivateUser {
                   DataService.shared.privateEvents.remove(at: self.index)
                } else {
                    DataService.shared.events.remove(at: self.index)
                }
                print("событие удалено из массива!")
                self.dismiss(animated: true)
            } else { print ("Отмена") }
        }
    }
    
    
    @IBAction func goToMapButtonTap() {
        guard let event = DataService.shared.event else { return }
        let lat = event.latEvent
        let lng = event.lngEvent
        DataService.shared.coordinateEvent = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        DataService.shared.defaultZoom = 17
        displayWarningLabel(withText: "Вернувшись на карту, данное событие будет в фокусе")
    }
    
    @IBAction func goButtonTap() {
        NetworkService.followMe()
        displayWarningLabel(withText: "Ваш голос принят !")
        goButton.isHidden = true
        cancelFollowButton.isHidden = false
        //print("До добавления:", DataService.shared.events[index].followEventUsers)
        if DataService.shared.isPrivateUser {
            DataService.shared.privateEvents[index].followEventUsers[DataService.shared.localUser.userID] = DataService.shared.localUser.niсkNameUser
        } else {
        DataService.shared.events[index].followEventUsers[DataService.shared.localUser.userID] = DataService.shared.localUser.niсkNameUser
        }
        /// добавляем событие в календарь
        alertAskConfirmation(title: "Внимание!", message: "Хотите добавить событие в календарь ?") { (result) in
            if result {
                self.presenter.addEventToCalendar()
            }
        }
        checkFollowUserStatus()
    }
    
    func animeOffLabel() {
        UIView.animate(withDuration: 2, delay: 0,
                       animations: { self.infoLabel.alpha = 0 })
    }
    
    func displayWarningLabel(withText text: String) {
        self.infoLabel.alpha = 0
        infoLabel.text = text
        infoLabel.textColor = .yellow
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.infoLabel.alpha = 1
        })
        //        { [weak self] complete in
        //            self?.animeOffLabel()
        //        }
    }
    
    
}


extension EventScreenViewController: EventScreenProtocol {
    
    func setTextToView(nickName: String, eventData: String, eventName: String, eventCategory: String, icon: String, eventDiscription: String, index: Int) {
        
        nickNameLabel.text = nickName
        eventDataLabel.text = "Начало: \(eventData)"
        eventNameLabel.text = "Название: \(eventName)"
        eventCategoryLabel.text = "Категория: \(eventCategory)"
        eventDiscriptionTV.text = eventDiscription
        let imageForButton = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
        goToMapButton.setImage(imageForButton, for: .normal)
        goToMapButton.tintColor = .white
        
        let count = DataService.shared.event.followEventUsers.count
        if count > 0 {
            eventCategoryLabel.text! += "\nЖелающих посетить: \(count) чел."
        }
        self.index = index;   print("index = ", index)
        checkFollowUserStatus()
    }
    
    func removeButtonSetting(hide: Bool) {
        if hide {
            removeButton.isHidden = true
            editButton.isHidden = true
        } else {
            removeButton.isHidden = false
            editButton.isHidden = false
        }
    }
    
    func hideFollowButton() {
        goButton.isHidden = true
    }
    
    func showAlert() {
        DispatchQueue.main.sync {
            displayWarningLabel(withText: "Календарь Вам напомнит за 2 часа")
        }
    }
    
}
