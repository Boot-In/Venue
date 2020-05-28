//
//  ModuleBuilder.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit

protocol Builder {
    static func mainScreenConfigure(view: MainScreenViewController)
    static func accountScreen() -> AccountScreenViewController
    static func addMarkerScreen() -> AddMarkerScreenViewController
    static func addLoginScreen() -> LoginScreenViewController
    static func addEventScreen() -> EventScreenViewController
    static func addEventsTableViewScreen() -> EventsTableViewController
}

class ModuleBulder: Builder {
    
    static func mainScreenConfigure(view: MainScreenViewController)  {
        let router = MainScreenRouter(with: view)
        let presenter = MainScreenPresenter(view: view, router: router)
        view.presenter = presenter
    }
    
    
    static func accountScreen() -> AccountScreenViewController {
        let view = AccountScreenViewController()
        let router = AccountScreenRouter(with: view)
        let presenter = AccountScreenPresenter(view: view, router: router)
        view.presenter = presenter
        
        return view
    }
    
    static func addMarkerScreen() -> AddMarkerScreenViewController {
        let view = AddMarkerScreenViewController()
        let router = AddMarkerScreenRouter(with: view)
        let presenter = AddMarkerScreenPresenter(view: view, router: router)
        view.presenter = presenter
        
        return view
    }
    
    static func addLoginScreen() -> LoginScreenViewController {
        let view = LoginScreenViewController()
        let router = LoginScreenRouter(with: view)
        let presenter = LoginScreenPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    static func addEventScreen() -> EventScreenViewController {
        let view = EventScreenViewController()
        let router = EventScreenRouter(with: view)
        let presenter = EventScreenPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    static func addEventsTableViewScreen() -> EventsTableViewController {
        let view = EventsTableViewController()
        let router = EventsTableViewRouter(with: view)
        let presenter = EventsTableViewPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    static func addCategoryTableViewScreen() -> CategoryTableViewController {
        let view = CategoryTableViewController()
        let router = CategoryTableViewRouter(with: view)
        let presenter = CategoryTableViewPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
}
