//
//  EntryTableViewCell.swift
//  JustKidding
//
//  Created by Henok Weldemicael on 3/15/15.
//  Copyright (c) 2015 Henok WeldeMicael. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel! = UILabel()
    @IBOutlet var usernameLabel: UILabel! = UILabel()
    @IBOutlet var likesCountLabel: UILabel! = UILabel()
    @IBOutlet var jokeLabel: UITextView! = UITextView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
