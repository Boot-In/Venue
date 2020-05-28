//
//  AddMarkerScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 11.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol AddMarkerScreenRouterProtocol: class {
   // func showSecondModule(result: Int)
  
}

final class AddMarkerScreenRouter: AddMarkerScreenRouterProtocol {
    
    weak var view: AddMarkerScreenViewController?
    weak var presenter: AddMarkerScreenPresenter?
    
    init(with vc: AddMarkerScreenViewController) {
        self.view = vc
    }
    
//    func showSecondModule(result: Int) {
//        let secondModuleVC = ModuleBulder.secondModule()
//        secondModuleVC.resultCalc = result
//        view?.navigationController?.pushViewController(secondModuleVC, animated: true)
//    }
    
   
}
