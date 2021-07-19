//
//  Label.swift
//  Fortnightly
//
//  Created by Ciprian Cojan on 11/07/21.
//

import UIKit

public class Label: UILabel {
    convenience init(text: String? = nil,
                     numberOfLines: Int = 1,
                     textAlignment: NSTextAlignment = NSTextAlignment.left,
                     textColor: UIColor = .black) {
        self.init(frame: CGRect.zero)
        self.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.textColor = textColor
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
        sizeToFit()
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}


