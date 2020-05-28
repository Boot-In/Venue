//
//  CategoryTableViewRouter.swift
//  venue
//
//  Created by Dmitriy Butin on 26.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

protocol CategoryTableViewRouterProtocol: class {
    
}

final class CategoryTableViewRouter: CategoryTableViewRouterProtocol {
    
    weak var view: CategoryTableViewController?
    weak var presenter: CategoryTableViewPresenter?
    
    init(with vc: CategoryTableViewController) {
        self.view = vc
    }
    
    
    
}
