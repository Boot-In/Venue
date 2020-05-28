//
//  CategoryTableViewPresenter.swift
//  venue
//
//  Created by Dmitriy Butin on 26.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import Foundation
/// Вывод информации
protocol CategoryTableViewProtocol: class {
    
}

// это как мы принимаем информацию
protocol CategoryTableViewPresenterProtocol: class {
    init(view: CategoryTableViewProtocol, router: CategoryTableViewRouterProtocol)
    
}

class CategoryTableViewPresenter: CategoryTableViewPresenterProtocol {
    
    let view: CategoryTableViewProtocol
    let router: CategoryTableViewRouterProtocol
    
    required init(view: CategoryTableViewProtocol, router: CategoryTableViewRouterProtocol) {
        self.view = view
        self.router = router
    }///////////////////////////////////////////////////
   

    
    
}
