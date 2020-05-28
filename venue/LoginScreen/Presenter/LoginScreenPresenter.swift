//
//  LoginScreenPresenter.swift
//  venue
//
//  Created by Dmitriy Butin on 17.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import Foundation

/// Вывод информации
protocol LoginScreenProtocol: class {
    
}

// это как мы принимаем информацию
protocol LoginScreenPresenterProtocol: class {
    init(view: LoginScreenProtocol, router: LoginScreenRouterProtocol)
    
   func goAccountScreen()
  
}

class LoginScreenPresenter: LoginScreenPresenterProtocol {
    
    let view: LoginScreenProtocol
    let router: LoginScreenRouterProtocol
    
    required init(view: LoginScreenProtocol, router: LoginScreenRouterProtocol) {
        self.view = view
        self.router = router
    }///////////////////////////////////////////////////
   
  
   
  func goAccountScreen() {
        router.showAccountScreen()
    }




}
