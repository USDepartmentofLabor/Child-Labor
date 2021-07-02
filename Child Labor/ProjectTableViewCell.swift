//
//  ProjectTableViewCell.swift
//  Child Labor
//
//  Created by Gnanendra Kumar on 28/06/21.
//  Copyright © 2021 U.S. Department of Labor. All rights reserved.
//

import UIKit

class ProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var link: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
