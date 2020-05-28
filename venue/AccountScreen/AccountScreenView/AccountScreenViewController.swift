//
//  AccountScreenViewController.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountScreenViewController: UIViewController {
    
    var presenter: AccountScreenPresenterProtocol!
    
    // let picker = UIDatePicker()
    // let calendar = Calendar.current
    
    @IBOutlet weak var nameUserTF: UITextField!
    @IBOutlet weak var secondNameUserTF: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nickNameUserTF: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableTF()
        logOutButton.isHidden = true
        infoLabel.textColor = .red
        saveButton.isHidden = false
        if let profile = presenter.getProfile() {
            print("...profile", profile.firstUserName)
            updateProfileInfo(profile: profile)
            disableTF()
        }
    }
    
    func updateProfileInfo(profile: Profile) {
        print("updateProfileInfo")
        nameUserTF.text = profile.firstUserName
        secondNameUserTF.text = profile.secondNameUser
        nickNameUserTF.text = profile.niсkNameUser
        emailTextField.text = profile.userMail
        passwordTextField.text = profile.password
        rePasswordTextField.text = profile.password
        logOutButton.isHidden = false
        infoLabel.text = ""
        saveButton.isHidden = true
    }
    
    func disableTF() {
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        rePasswordTextField.isEnabled = false
        nameUserTF.isEnabled = false
        secondNameUserTF.isEnabled = false
        nickNameUserTF.isEnabled = false
    }
    
    func enableTF() {
         emailTextField.isEnabled = true
         passwordTextField.isEnabled = true
         rePasswordTextField.isEnabled = true
         nameUserTF.isEnabled = true
         secondNameUserTF.isEnabled = true
         nickNameUserTF.isEnabled = true
     }
    
    @IBAction func closeWindow() {
        dismiss(animated: false)
    }
    
    @IBAction func logOut() {
        do {
            try Auth.auth().signOut()
            print("Log Out")
        } catch {
            print(error.localizedDescription)
            infoLabel.text = error.localizedDescription
        }
        presenter.clearLocalUserData()
        self.dismiss(animated: true)
    }
    
    @IBAction func saveButtonTap() {
        
        guard let firstUN = nameUserTF.text, nameUserTF.text != "" else {
            infoLabel.text = "Не заполнено поле Имя" ; return }
        guard let secondUN = secondNameUserTF.text, secondNameUserTF.text != "" else {
        infoLabel.text = "Не заполнено поле Фамилия" ; return }
        guard let nickUN = nickNameUserTF.text, nickNameUserTF.text != "" else {
               infoLabel.text = "Не заполнено поле Ник" ; return }
        guard let email = emailTextField.text, emailTextField.text != "" else {
            infoLabel.text = "Не заполнено поле E-mail" ; return
        }
        guard let password = passwordTextField.text, passwordTextField.text != "" else {
            infoLabel.text = "Не заполнено поле Password" ; return
        }
        if password.count < 6 {
            infoLabel.text = "Пароли менее 6-ти символов !"; return
        }
        if passwordTextField.text != rePasswordTextField.text {
            infoLabel.text = "Пароли не совпадают" ; return
        }
        infoLabel.textColor = .systemBlue
        infoLabel.text = "Подождите....."
        
        presenter.createUser(email: email, password: password, fName: firstUN, sName: secondUN, nik: nickUN)
        
        logOutButton.isHidden = false
        saveButton.isHidden = true
        disableTF()
    }
    
}


extension AccountScreenViewController: AccountScreenProtocol {
    
    func sendMessage(text: String) {
        infoLabel.text = text
    }
    
}

extension AccountScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true) // Скрывает клавиатуру по Enter
    }
}
