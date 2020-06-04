//
//  AddMarkerScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol AddMarkerScreenRouterProtocol: class {
   func showCategoryModule()
  
}

final class AddMarkerScreenRouter: AddMarkerScreenRouterProtocol {
    
    weak var view: AddMarkerScreenViewController?
    weak var presenter: AddMarkerScreenPresenter?
    
    init(with vc: AddMarkerScreenViewController) {
        self.view = vc
    }
    
    func showCategoryModule() {
        let categoryModuleVC = ModuleBulder.addCategoryTableViewScreen()
        //addEventScreenVC.modalPresentationStyle = .fullScreen
        view?.present(categoryModuleVC, animated: true)
    }
    
   
}
