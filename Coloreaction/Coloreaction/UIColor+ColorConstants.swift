//
//  ColorConstants.swift
//  Coloreaction
//
//  Created by Alejandro Zamudio on 4/13/17.
//
//

import Foundation
import UIKit

extension UIColor {
    class func mainColor() -> UIColor {
        return UIColor(red: 123/255, green: 100/255, blue: 130/255, alpha: 1.0)
    }
    
    class func pastelPinkColor() -> UIColor {
        return UIColor(red: 244/255, green: 187/255, blue: 187/255, alpha: 1.0)
    }
    
    class func pastelBlueColor() -> UIColor {
        return UIColor(red: 146/255, green: 185/255, blue: 230/255, alpha: 1.0)
    }
    
    class func pastelGreenColor() -> UIColor {
        return UIColor(red: 132/255, green: 229/255, blue: 208/255, alpha: 1.0)
    }
    
    class func pastelPurpleColor() -> UIColor {
        return UIColor(red: 212/255, green: 177/255, blue: 240/255, alpha: 1.0)
    }
    
    class func correctAnswerColor() -> UIColor {
        return UIColor(red: 133/255, green: 224/255, blue: 133/255, alpha: 1.0)
    }
    
    class func incorrectAnswerColor() -> UIColor {
        return UIColor(red: 255/255, green: 77/255, blue: 77/255, alpha: 1.0)
    }
    
    class func shadowColor() -> UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    }
    
    class func darkerShadowColor() -> UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
    }
    
    class func pastelGrayColor() -> UIColor {
        return UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 0.7)
    }
}
