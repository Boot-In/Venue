//
//  AddMarkerScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol AddMarkerScreenRouterProtocol: class {
   func showCategoryModule(addMarkerView: AddMarkerScreenProtocol)
  
}

final class AddMarkerScreenRouter: AddMarkerScreenRouterProtocol {
    
    weak var view: AddMarkerScreenViewController?
    weak var presenter: AddMarkerScreenPresenter?
    
    init(with vc: AddMarkerScreenViewController) {
        self.view = vc
    }
    
    func showCategoryModule(addMarkerView: AddMarkerScreenProtocol) {
        let categoryModuleVC = ModuleBulder.addCategoryTableViewScreen()
        categoryModuleVC.addMarkerView = addMarkerView
        //addEventScreenVC.modalPresentationStyle = .fullScreen
        view?.present(categoryModuleVC, animated: true)
    }
    
   
}
