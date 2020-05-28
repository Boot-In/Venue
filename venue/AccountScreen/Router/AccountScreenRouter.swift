//
//  AccountScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol AccountScreenRouterProtocol: class {
   
  
}

final class AccountScreenRouter: AccountScreenRouterProtocol {
    
    weak var view: AccountScreenViewController?
    weak var presenter: AccountScreenPresenter?
    
    init(with vc: AccountScreenViewController) {
        self.view = vc
    }
    

    
   
}
