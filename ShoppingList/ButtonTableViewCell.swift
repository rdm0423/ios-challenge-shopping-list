//
//  ButtonTableViewCell.swift
//  ShoppingList
//
//  Created by Ross McIlwaine on 5/20/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var itemLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func completeButtonTapped(sender: AnyObject) {
        
    }
    
    

}
