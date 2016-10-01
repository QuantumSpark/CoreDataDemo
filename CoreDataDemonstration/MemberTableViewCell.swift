//
//  MemberTableViewCell.swift
//  CoreDataDemonstration
//
//  Created by James Park on 2016-09-28.
//  Copyright © 2016 James Park. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var joinedDate: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var name: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
