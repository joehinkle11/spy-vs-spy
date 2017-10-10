//
//  StarRatingViewer.swift
//  SpyVsSpy
//
//  Created by Candicane on 10/9/17.
//  Copyright © 2017 Joseph Hinkle. All rights reserved.
//

import UIKit

class StarRatingViewer: UIStackView {

    //Variables
    private var ratingButtons = [UIButton]()
    var rating = 3
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0)
        {
        didSet
        {
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5
        {
        didSet
        {
            setupButtons()
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons()
    {
        //Remove any preexisting buttons
        for button in ratingButtons
        {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //Load button images
        let bundle = Bundle(for: type(of: self))
        _ = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        _ = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        //Create buttons
        for _ in 0..<starCount
        {
            //Create button
            let button = UIButton()
            
            //Set images
            button.setImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "filledStar"), for: .selected)
            button.setImage(#imageLiteral(resourceName: "filledStar"), for: .highlighted)
            button.setImage(#imageLiteral(resourceName: "filledStar"), for: [.highlighted, .selected])
            
            //Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //Add button to stack
            addArrangedSubview(button)
            
            //Add button to array
            ratingButtons.append(button)
            
            //Create index for ratingButtons array
            guard let index = ratingButtons.index(of: button) else {
                fatalError("The button, \(button), is not in the array.")
            }
            
            //Fill in necessary buttons
            for _ in 0..<rating
            {
                button.isSelected  = index < rating
            }
        }
    }
}
