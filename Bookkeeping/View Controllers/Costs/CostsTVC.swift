//
//  CostsTVC.swift
//  Bookkeeping
//
//  Created by Name on 24.11.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit

class CostsTVC: UITableViewCell {

    @IBOutlet weak var nameCategory: UILabel!
    @IBOutlet weak var valueCost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
