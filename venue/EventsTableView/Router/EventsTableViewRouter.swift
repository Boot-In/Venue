//
//  EventsTableViewRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 22.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol EventsTableViewRouterProtocol: class {
    
    func showEventScreen()
}

final class EventsTableViewRouter: EventsTableViewRouterProtocol {
    
    weak var view: EventsTableViewController?
    weak var presenter: EventsTableViewPresenter?
    
    init(with vc: EventsTableViewController) {
        self.view = vc
    }
    
    func showEventScreen() {
        let addEventScreenVC = ModuleBulder.addEventScreen()
        addEventScreenVC.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(addEventScreenVC, animated: true)
    }
    
    
}
