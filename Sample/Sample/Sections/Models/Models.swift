//
//  Models.swift
//  Sample
//
//  Created by Meniny on 2018-01-31.
//  Copyright © 2018年 Meniny Lab. All rights reserved.
//

import Foundation
import UIKit

public enum Image {
    case named(String)
    case none
    
    public var image: UIImage? {
        switch self {
        case let .named(name):
            return UIImage.init(named: name)
        default:
            return nil
        }
    }
}

public struct Site {
    public let name: String
    public let url: String
    public let icon: Image
}
