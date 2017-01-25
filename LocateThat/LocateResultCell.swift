//
//  LocateResultCell.swift
//  LocateThat
//
//  Created by Michael De La Cruz on 1/24/17.
//  Copyright © 2017 Michael De La Cruz. All rights reserved.
//

import UIKit

class LocateResultCell: UITableViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
