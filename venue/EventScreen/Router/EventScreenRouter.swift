//
//  EventScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 21.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol EventScreenRouterProtocol: class {
    
    func showAddMarkerScreen()
}

final class EventScreenRouter: EventScreenRouterProtocol {
    
    weak var view: EventScreenViewController?
    weak var presenter: EventScreenPresenter?
    
    init(with vc: EventScreenViewController) {
        self.view = vc
    }
    
    func showAddMarkerScreen() {
        let addMarkerScreenVC = ModuleBulder.addMarkerScreen()
        addMarkerScreenVC.modalPresentationStyle = .fullScreen
        addMarkerScreenVC.isEdit = true
        view?.present(addMarkerScreenVC, animated: true)
    }
    
   
}
