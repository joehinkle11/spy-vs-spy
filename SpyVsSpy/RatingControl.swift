//
//  RatingControl.swift
//
//  Created by Candace on 10/2/17.
//

import UIKit

@available(iOS 9.0, *)
class RatingControl: UIStackView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons() {
        // Create the button
        let button = UIButton()
        button.backgroundColor = UIColor.red
        
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        // Add the button to the stack
        addArrangedSubview(button)
    }
}
