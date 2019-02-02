//
//  ProfileTableViewCell.swift
//  MyGateTestApp
//
//  Created by Naresh on 02/02/19.
//  Copyright © 2019 Naresh. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var passcodeLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.viewShadow(radius: 5)
        profileImageView.roundedIamge()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
