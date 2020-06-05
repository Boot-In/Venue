//
//  Extensions.swift
//  venue
//
//  Created by Dmitriy Butin on 26.05.2020.
//  Copyright © 2020 Dmitriy Butin. All rights reserved.
//
import UIKit


extension UIViewController {
    
    func showAlert(with title: String, and message: String, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertMsgWithDelay(title: String?, message: String, delay: Int){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func alertAskConfirmation (title: String, message: String, completion:@escaping (_ result: Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { action in
          completion(true)
      }))

      alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
          completion(false)
      }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension UIImage {
    
    func overlayImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
