//
//  YBCell.swift
//  Jolly
//
//  Created by Venkatesh Jujjavarapu on 3/9/17.
//  Copyright © 2017 Venkatesh Jujjavarapu. All rights reserved.
//

import UIKit

class YBCell: UITableViewCell {

    @IBOutlet weak var ybImage: UIImageView!
    @IBOutlet weak var ybName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
