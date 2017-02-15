//
//  FeedCell.swift
//  AC3.2-Final
//
//  Created by Ilmira Estil on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var imageComment: UITextView!
    @IBOutlet weak var feedImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
