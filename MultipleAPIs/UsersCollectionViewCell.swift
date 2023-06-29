//
//  UsersCollectionViewCell.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 29/06/23.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var usersView: UIView!
    var identifier = "UsersCollectionViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "UsersCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
