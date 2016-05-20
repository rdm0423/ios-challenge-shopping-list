//
//  ButtonTableViewCell.swift
//  ShoppingList
//
//  Created by Ross McIlwaine on 5/20/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

@IBDesignable

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    
    // Delegate
    var delegate: ButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func completeButtonTapped(sender: AnyObject) {
        
        if let delegate = delegate {
            delegate.buttonCellButtonTapped(self)
        }
    }
    
    func updateButton(isComplete: Bool) {
        
        if isComplete {
            completeButton.setImage(UIImage(named: "done3"), forState: .Normal)
        } else {
            completeButton.setImage(UIImage(named: "do-1"), forState: .Normal)
        }
    }
}

protocol ButtonTableViewCellDelegate {
    
    func buttonCellButtonTapped(sender: ButtonTableViewCell)
}

extension ButtonTableViewCell {
    
    func updateWithItem(item: Item) {
        
        
        itemLabel.text = item.name
        updateButton(item.isComplete.boolValue)
    }
}