//
//  configUI.swift
//  venue
//
//  Created by Dmitriy Butin on 29.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//

import UIKit

class ConfigUI {
static var shared = ConfigUI()
    
    let greenVenue = UIColor(red: 0, green: 153/255, blue: 0, alpha: 1)

    static func buttonConfig(button: UIButton, titleColor: UIColor, alfa: CGFloat){
        button.layer.cornerRadius = 10
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.backgroundColor = UIColor(white: 1, alpha: alfa)
        button.layer.shadowOpacity = 1
        button.setTitleColor(titleColor, for: .normal)
       // button.layer.masksToBounds = true
    }

    static func segmentControlConfig(sc: UISegmentedControl){
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.shared.greenVenue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)], for: .selected)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        sc.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
    static func changeSystemIconColor(button: UIButton, systemName: String) {
        let origImage = UIImage(systemName: systemName)
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        button.setBackgroundImage(tintedImage, for: .normal)
        button.tintColor = .white
    }
    
    
}
