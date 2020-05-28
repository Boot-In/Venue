//
//  MainScreenRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 10.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//
import UIKit

protocol MainScreenRouterProtocol: class {
    func showAccountScreen()
    func showAddMarkerScreen()
    func showLoginScreen()
    func showEventScreen()
    func showTableViewScreen()
}

final class MainScreenRouter: MainScreenRouterProtocol {
    
    weak var view: MainScreenViewController?
    weak var presenter: MainScreenPresenter?
    
    init(with vc: MainScreenViewController) {
        self.view = vc
    }
    
    func showAccountScreen() {
        let accountScreenVC = ModuleBulder.accountScreen()
      //  view?.navigationController?.pushViewController(accountScreenVC, animated: true)
         accountScreenVC.modalPresentationStyle = .fullScreen
         view?.navigationController?.present(accountScreenVC, animated: true)
    }
    
    func showAddMarkerScreen() {
        let addMarkerScreenVC = ModuleBulder.addMarkerScreen()
        addMarkerScreenVC.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(addMarkerScreenVC, animated: true)
    }
    
    func showLoginScreen() {
        let loginScreenVC = ModuleBulder.addLoginScreen()
        
        let nc = UINavigationController(rootViewController: loginScreenVC)
        nc.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(nc, animated: true)
        //view?.navigationController?.pushViewController(loginScreenVC, animated: true)
    }
    
    func showEventScreen() {
        let addEventScreenVC = ModuleBulder.addEventScreen()
        addEventScreenVC.modalPresentationStyle = .fullScreen
        view?.navigationController?.present(addEventScreenVC, animated: true)
    }
    
    func showTableViewScreen() {
        let tableViewScreen = ModuleBulder.addEventsTableViewScreen()
        view?.navigationController?.pushViewController(tableViewScreen, animated: true)
    }
    
}
