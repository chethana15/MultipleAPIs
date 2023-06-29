//
//  PostsTableViewCell.swift
//  MultipleAPIs
//
//  Created by Cumulations Technologies Private Limited on 29/06/23.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bgView: UIView!
    var identifier = "PostsTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "PostsTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
