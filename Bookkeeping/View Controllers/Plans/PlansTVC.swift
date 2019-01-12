//
//  PlansTVC.swift
//  Bookkeeping
//
//  Created by Name on 09.01.2019.
//  Copyright © 2019 Name. All rights reserved.
//

import UIKit

class PlansTVC: UITableViewCell {

    @IBOutlet weak var namePlan: UILabel!
    @IBOutlet weak var valueCosts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
