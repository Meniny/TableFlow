//
//  TextTableViewCell.swift
//  Pods-Sample
//
//  Created by 李二狗 on 2018/2/1.
//

import UIKit

open class TextTableViewCell: UITableViewCell, DeclarativeCell {
    public var _onChange: ((String) -> Void)?
    
    public var model: String?
    
    public func configure(_ i: String, path: IndexPath) {
        self.model = i
        self.textLabel?.text = self.model
    }
    
    public typealias T = String

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textLabel?.numberOfLines = 0
        self.textLabel?.font = UIFont.systemFont(ofSize: 16)
        self.textLabel?.textColor = UIColor.darkText
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
    }

}

public typealias TextRow = Row<TextTableViewCell>

public extension Row where Cell == TextTableViewCell {
    public convenience init(text: String) {
        self.init(model: text)
    }
}
