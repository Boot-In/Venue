//
//  EventScreenViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 21.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit

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
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("до удаления:", DataService.shared.events[index].followEventUsers)
        DataService.shared.events[index].followEventUsers.removeValue(forKey: DataService.shared.localUser.userID)
        print("После удаления:", DataService.shared.events[index].followEventUsers)
        displayWarningLabel(withText: "Жаль, что передумали ...")
        //checkFollowUserStatus()
    }
    

    @IBAction func closeWindow() {
        DataService.shared.event = nil
        self.dismiss(animated: true)
    }
    
    @IBAction func editButtonAction() {
        presenter.goToEdit()
    }
    
    @IBAction func removeEventButtonTap() {
        guard let event = DataService.shared.event else { return }
        print("нажали кнопку удалять:", event.eventID)
        NetworkService.removeEvent(event: event)
        DataService.shared.event = nil /// сделать после обработки удаления !
        print("событие обнулено!")
        DataService.shared.events.remove(at: self.index)
        print("событие удалено из массива!")
        self.dismiss(animated: true)
    }
    
    @IBAction func goButtonTap() {
        NetworkService.followMe()
        displayWarningLabel(withText: "Ваш голос принят !")
        goButton.isHidden = true
        cancelFollowButton.isHidden = false
        print("До добавления:", DataService.shared.events[index].followEventUsers)
        DataService.shared.events[index].followEventUsers[DataService.shared.localUser.userID] = DataService.shared.localUser.niсkNameUser
        print("После добавления:", DataService.shared.events[index].followEventUsers)
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
    
    func setTextToView(nickName: String, eventData: String, eventName: String, eventCategory: String, eventDiscription: String, index: Int) {
        
        nickNameLabel.text = nickName
        eventDataLabel.text = "Дата проведения: \(eventData)"
        eventNameLabel.text = "Название: \(eventName)"
        eventCategoryLabel.text = "Категория: \(eventCategory)"
        
        let count = DataService.shared.event.followEventUsers.count
        if count > 0 {
            eventDiscriptionTV.text = "Желающих посетить: \(count) чел. \n\n\(eventDiscription)"
        } else { eventDiscriptionTV.text = eventDiscription }
        
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
    
}
