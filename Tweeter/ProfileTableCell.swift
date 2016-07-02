//
//  ProfileTableCell.swift
//  Tweeter
//
//  Created by Alexina Boudreaux-Allen on 6/30/16.
//  Copyright © 2016 Alexina Boudreaux-Allen. All rights reserved.
//

import UIKit

class ProfileTableCell: UITableViewCell {

    @IBOutlet weak var profileFavorite: UILabel!
    
    @IBOutlet weak var profileRetweets: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profilePostsLabel: UILabel!
    @IBOutlet weak var profileUsername: UILabel!
    @IBOutlet weak var profileTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
