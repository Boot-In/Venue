//
//  EventsTableViewRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 22.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol EventsTableViewRouterProtocol: class {
    
    func showEventScreen(index: Int)
}

final class EventsTableViewRouter: EventsTableViewRouterProtocol {
    
    weak var view: EventsTableViewController?
    weak var presenter: EventsTableViewPresenter?
    
    init(with vc: EventsTableViewController) {
        self.view = vc
    }
    
    func showEventScreen(index: Int) {
        let addEventScreenVC = ModuleBulder.addEventScreen()
        addEventScreenVC.modalPresentationStyle = .fullScreen
        addEventScreenVC.index = index
        view?.navigationController?.present(addEventScreenVC, animated: true)
    }
    
    
}
