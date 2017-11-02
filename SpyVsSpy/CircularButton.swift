//
//  CircularButton.swift
//  SpyVsSpy
//
//  Created by Candicane on 11/1/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

@IBDesignable
class CircularButton: UIButton
{
    
    @IBInspectable var fillColor: UIColor = UIColor.blue
    @IBInspectable var cornerRadius: CGFloat = 0

    override func draw(_ rect: CGRect)
    {
        layer.cornerRadius = cornerRadius
        layer.backgroundColor = fillColor.cgColor
    }

}
