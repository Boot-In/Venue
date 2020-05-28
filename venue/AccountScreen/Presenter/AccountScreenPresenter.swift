//
//  AccountScreenPresenter.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//
import Foundation
import Firebase

/// Вывод информации
protocol AccountScreenProtocol: class {
    func sendMessage(text: String)
}

// это как мы принимаем информацию
protocol AccountScreenPresenterProtocol: class {
    init(view: AccountScreenProtocol, router: AccountScreenRouterProtocol)
    
    func createUser(email: String, password: String, fName: String, sName: String, nik: String)
    func getProfile() -> Profile?
    func clearLocalUserData()
}

class AccountScreenPresenter: AccountScreenPresenterProtocol {
    let view: AccountScreenProtocol
    let router: AccountScreenRouterProtocol
    
    var ref: DatabaseReference!
    
    required init(view: AccountScreenProtocol, router: AccountScreenRouterProtocol) {
        self.view = view
        self.router = router
        
        ref = Database.database().reference(withPath: "users")
    }///////////////////////////////////////////////////
   
    func getProfile() -> Profile? {
        print("...getProfile>")
        return DataService.shared.localUser
    }
           
    func getUID() -> String {
        guard let user = Auth.auth().currentUser else { return "No user ID"}
        print("UserID = \(user.uid)")
        UserDefaults.standard.set(user.uid, forKey: "userID")
        UserDefaults.standard.set(user.email, forKey: "userMail")
        UserDefaults.standard.set(true, forKey: "logined")
        return user.uid
    }
    
    func clearLocalUserData() {
        UserDefaults.standard.set(false, forKey: "logined")
        UserDefaults.standard.set("", forKey: "userMail")
      //  UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set("", forKey: "nameUser")
        UserDefaults.standard.set("", forKey: "secondNameUser")
        UserDefaults.standard.set("", forKey: "nickNameUser")
        UserDefaults.standard.set("", forKey: "userID")
    }
    
    func createUser(email: String, password: String, fName: String, sName: String, nik: String) {
       // UserDefaults.standard.set(email, forKey: "email")
       // UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(fName, forKey: "nameUser")
        UserDefaults.standard.set(sName, forKey: "secondNameUser")
        UserDefaults.standard.set(nik, forKey: "nickNameUser")
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] (user, error) in
            
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                self?.view.sendMessage(text: error!.localizedDescription)
                return
            }
            
            guard let newUser = Auth.auth().currentUser else { return }
            let userRef = self?.ref.child(newUser.uid)
            userRef?.setValue([
                "userMail" : newUser.email,
               // "password" : password,
                "firstUserName" : fName,
                "secondNameUser" : sName,
                "nickNameUser": nik
            ])
            
        })
        
        let user = Profile(userID: getUID(), userMail: email, firstUserName: fName, secondNameUser: sName, niсkNameUser: nik)
        print("Пользователь \(user.userID) успешно создан !")
        DataService.shared.localUser = user
        self.view.sendMessage(text: "Данные сохранены !")
    }

}
