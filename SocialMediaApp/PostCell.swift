//
//  PostCell.swift
//  SocialMediaApp
//
//  Created by Hikmet Tütüncü on 15.06.2024.
//

import UIKit
import SDWebImage

class PostCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.layer.cornerRadius = 20
        postImageView.clipsToBounds = true
        postImageView.contentMode = .scaleToFill
    }
    
    func configure(userName: String, postImageUrl: String, postDesc: String, likes: String) {
        userNameLabel.text = userName
        descriptionLabel.text = postDesc
        likesLabel.text = likes
        postImageView.sd_setImage(with: URL(string: postImageUrl), placeholderImage: UIImage(named: "selectimage"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func likeBtn(_ sender: Any) {
    }
}
