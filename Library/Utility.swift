//
//  Utility.swift
//  Parle


import UIKit

class Utility: NSObject
{
    class func DisplayAlertWithTitle (_ title:String ,Body:String, onViewcontriller:UIViewController)
    {
        let alertController = UIAlertController(title: title, message: Body, preferredStyle:.alert)

        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler:nil)
        
        alertController.addAction(defaultAction)
        
        onViewcontriller.present(alertController, animated: true, completion: nil)
    }
    
}
