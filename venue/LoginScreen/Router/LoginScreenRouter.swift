//
//  LoginScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 17.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol LoginScreenRouterProtocol: class {
   func showAccountScreen()
  
}

final class LoginScreenRouter: LoginScreenRouterProtocol {
    
    weak var view: LoginScreenViewController?
    weak var presenter: LoginScreenPresenter?
    
    init(with vc: LoginScreenViewController) {
        self.view = vc
    }
    
func showAccountScreen() {
    let accountScreenVC = ModuleBulder.accountScreen()
    view?.navigationController?.pushViewController(accountScreenVC, animated: true)
   // accountScreenVC.modalPresentationStyle = .fullScreen
   // view?.present(accountScreenVC, animated: true)
}
    
   
}
