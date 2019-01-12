//
//  InvoiceTVC.swift
//  Bookkeeping
//
//  Created by Name on 25.12.2018.
//  Copyright © 2018 Name. All rights reserved.
//

import UIKit

class InvoiceTVC: UITableViewCell {
    @IBOutlet weak var nameInvoice: UILabel!
    @IBOutlet weak var valueInvoice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
