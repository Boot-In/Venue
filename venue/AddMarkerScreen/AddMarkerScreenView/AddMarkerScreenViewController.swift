//
//  AddMarkerScreenViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit

class AddMarkerScreenViewController: UIViewController {
    @IBOutlet weak var userNickLabel: UILabel!
    @IBOutlet weak var dateEventTF: UITextField!
    @IBOutlet weak var nameEventTF: UITextField!
    @IBOutlet weak var startEventTF: UITextField! // задействовать с таблицей категорий
    @IBOutlet weak var discriptionEventTV: UITextView!
    @IBOutlet weak var iconEventIV: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var privateSwitch: UISwitch!
    @IBOutlet weak var privateLabel: UILabel!
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var presenter: AddMarkerScreenPresenterProtocol!
    let picker = UIDatePicker()
   // let iconArray = ["marker-icon", "red-marker", "green-marker", "blue-marker"]
   // var i = 0
    var isEdit: Bool = false // true - для режима редактирования
    
    let formatter = DateFormatter()
    var dateComponents = DateComponents()
    let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = false
        ConfigUI.buttonConfig(button: saveButton, titleColor: .white, alfa: 0.3)
        ConfigUI.buttonConfig(button: backButton, titleColor: .white, alfa: 0)
        ConfigUI.buttonConfig(button: categoryButton, titleColor: .white, alfa: 0.3)
        privateSwitch.isOn = false
        privateLabel.adjustsFontSizeToFitWidth = true
        if DataService.shared.isPrivateUser {
            DataService.shared.isPrivateEvent = true
            privateSwitch.isOn = true
            privateLabel.textColor = .red
            privateLabel.font = .boldSystemFont(ofSize: 18)
        } else {
            DataService.shared.isPrivateEvent = false
            privateLabel.textColor = .label
            privateLabel.font = .systemFont(ofSize: 17)
        }
        dateSetting()
        enableTextField()
        infoLabel.text = "Заполните поля"
        infoLabel.textColor = .yellow
        addDoneButtonTo(nameEventTF)
        addDoneButtonToTV(discriptionEventTV)
        loadTextFieldFromEvent()
    }
    
    func dateSetting() {
        formatter.locale = .init(identifier: "Russian")
        dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        dateComponents.hour = 10
        dateComponents.minute = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear AddMarkerScreenViewController")
        categoryLabel.text = DataService.shared.categoryEvent.0
        iconEventIV.image = UIImage(named: DataService.shared.categoryEvent.1)
    }
    
    func observeToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey ] as! NSValue).cgRectValue
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height + kbFrameSize.height)
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc func kbDidHide() {
          (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height)
       }
    
    func disableTextField() {
        dateEventTF.isEnabled = false
        nameEventTF.isEnabled = false
        startEventTF.isEnabled = false
        discriptionEventTV.isSelectable = false
    }
    
    func enableTextField() {
          dateEventTF.isEnabled = true
          nameEventTF.isEnabled = true
          startEventTF.isEnabled = true
          discriptionEventTV.isSelectable = true
      }
    
    func changeIconColor(imageName: String) { ///// !!!!!!!!!!!
        let origImage = UIImage(named: imageName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        iconEventIV.image = tintedImage
        iconEventIV.tintColor = .red
    }
    
    func loadTextFieldFromEvent() {
        if let event = DataService.shared.event {
            presenter.loadTFFromEvent(event: event)
        } else { loadDataForTextField() }
    }
    
    func loadDataForTextField() {
        let userDefault = UserDefaults.standard
        userNickLabel.text = "Организатор: \(userDefault.string(forKey: "nickNameUser") ?? "без названия")"
        //let stringDate = formatter.string(from: Date())
        nameEventTF.text = DataService.shared.placeEvent
        iconEventIV.image = UIImage(named: DataService.shared.categoryEvent.1)
        dateEventTF.text = ""
        //DataService.shared.dateEvent = Date()
        //DataService.shared.dataEventString = stringDate
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressedForDP))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
        target: nil, action: nil)
        toolbar.setItems([flexBarButton, done], animated: true)
        
        dateEventTF.inputAccessoryView = toolbar // вызов тулбара
        dateEventTF.inputView = picker
        picker.datePickerMode = .date
        picker.locale = .init(identifier: "Russian")
    }
    
    @objc func donePressedForDP() {
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        DataService.shared.dateEvent = picker.date
        DataService.shared.dataEventString = dateString
        dateEventTF.text = "\(dateString)"
        
        self.view.endEditing(true)
    }
    
    func createTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressedForTP))
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        toolbar.setItems([flexBarButton, done], animated: true)
        
        startEventTF.inputAccessoryView = toolbar // вызов тулбара
        startEventTF.inputView = picker
        picker.datePickerMode = .time
       
        let date = calendar.date(from: dateComponents)
        picker.setDate(date ?? Date(), animated: true)
        picker.locale = .init(identifier: "Russian")
    }
       
    @objc func donePressedForTP() {
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let timeString = formatter.string(from: picker.date)
        
        startEventTF.text = "\(timeString)"
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonTap() {
        isEdit = false
        self.dismiss(animated: true)
    }
    
    @IBAction func changeIconButtonTap() {
        presenter.showCategory()
//        i += 1
//        if i == iconArray.count {i = 0}
//        iconEventIV.image = UIImage(named: iconArray[i])
        //changeIconColor(imageName: iconArray[i])
        
    }
    
    @IBAction func privateSwitchAction() {
        if privateSwitch.isOn {
            privateLabel.textColor = .red
            privateLabel.font = .boldSystemFont(ofSize: 18)
            privateLabel.adjustsFontSizeToFitWidth = true
            DataService.shared.isPrivateEvent = true
        } else {
            privateLabel.textColor = .label
            privateLabel.font = .systemFont(ofSize: 17)
            privateLabel.adjustsFontSizeToFitWidth = true
            DataService.shared.isPrivateEvent = false
        }
    }
    
    @IBAction func saveButtonTap() {
        guard let _ = dateEventTF.text, dateEventTF.text != "" else {
            infoLabel.text = "Не заполнено поле Дата" ; return }
        guard let name = nameEventTF.text, nameEventTF.text != "" else {
            infoLabel.text = "Не заполнено поле Название" ; return }
        guard let discr = discriptionEventTV.text else { return }
        var startEvent = startEventTF.text
        if startEventTF.text == "" { startEvent = "10:00" }
        //guard let category = categoryEventTF.text else { return }
        DataService.shared.startEvent = startEvent ?? "10:00"
        infoLabel.textColor = .white
        infoLabel.text = "Сохраняем ...."
        if isEdit {
            guard let event = DataService.shared.event else { return }
            presenter.updateEvent(event: event, nameEvent: name, iconEvent: DataService.shared.categoryEvent.1, discrEvent: discr)
            infoLabel.text = "Данные успешно обновлены"
        } else {
            presenter.saveEvent(nameEvent: name, iconEvent: DataService.shared.categoryEvent.1, discrEvent: discr)
            infoLabel.text = "Данные успешно сохранены"
        }
        saveButton.isHidden = true
        disableTextField()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
        // Скрывает клавиатуру, вызванную для любого объекта
    }
    
}


extension AddMarkerScreenViewController: AddMarkerScreenProtocol {
    
    func fieldInfo(nik: String, name: String, caregiry: String, icon: String, discription: String) {
//        for ico in 0..<iconArray.count {
//            if iconArray[ico] == icon { i = ico }
//        }
        userNickLabel.text = "Организатор: \(nik)"
        nameEventTF.text = name
        dateEventTF.text = ""
        //dateEventTF.text = formatter.string(from: Date())
        startEventTF.text = caregiry
        iconEventIV.image = UIImage(named: DataService.shared.categoryEvent.1)
        discriptionEventTV.text = discription
        infoLabel.text = "Внесите изменения, проверьте дату"
        //DataService.shared.dateEvent = Date()
        //DataService.shared.dataEventString = formatter.string(from: Date())
    }
    
}

extension AddMarkerScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.view.endEditing(true) // Скрывает клавиатуру по Enter
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == startEventTF {
            createTimePicker()
        } else if textField == dateEventTF {
            createDatePicker()
        }
    }
    
}

extension AddMarkerScreenViewController {
    
    // Метод для отображения кнопки "Готово" на клавиатуре
    private func addDoneButtonTo(_ textFields: UITextField...) {
        
        textFields.forEach { textField in
            let keyboardToolbar = UIToolbar()
            textField.inputAccessoryView = keyboardToolbar
            keyboardToolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title:"Готово",
                                             style: .done,
                                             target: self,
                                             action: #selector(didTapDone))
            
            let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            keyboardToolbar.items = [flexBarButton, doneButton]
        }
    }
    
    private func addDoneButtonToTV(_ textView: UITextView...) {
         
         textView.forEach { textView in
             let keyboardToolbar = UIToolbar()
             textView.inputAccessoryView = keyboardToolbar
             keyboardToolbar.sizeToFit()
             
             let doneButton = UIBarButtonItem(title:"Готово",
                                              style: .done,
                                              target: self,
                                              action: #selector(didTapDone))
             
             let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
             
             keyboardToolbar.items = [flexBarButton, doneButton]
         }
     }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
    
}
