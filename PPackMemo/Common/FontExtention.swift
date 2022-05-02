//
//  FontExtention.swift
//  PPackMemo
//
//  Created by Hansub Yoo on 2022/05/01.
//

import UIKit

extension UIFont {
    class func FunStory(type: FunStoryType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }
    
    class func BM(type: JuaType, size: CGFloat) -> UIFont! {
        guard let font = UIFont(name: type.name, size: size) else {
            return nil
        }
        return font
    }

    public enum FunStoryType {
        case Bold

        var name: String {
            switch self {
            case .Bold:
                return "tvNEnjoystoriesB"

            }
        }
    }
    
    public enum JuaType {
        case Regular
        
        var name: String {
            switch self {
            case .Regular:
                return "BMJUAOTF"
            }
        }
    }
}
