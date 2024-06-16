//
//  PostCell.swift
//  SocialMediaApp
//
//  Created by Hikmet Tütüncü on 15.06.2024.
//

import UIKit
import SDWebImage
import FirebaseFirestore

class PostCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var documentID = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.layer.cornerRadius = 20
        postImageView.clipsToBounds = true
        postImageView.contentMode = .scaleToFill
        
        postImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likePost))
        gestureRecognizer.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func configure(post: Post) {
        userNameLabel.text = post.userName
        descriptionLabel.text = post.postDescription
        likesLabel.text = String(post.likes)
        postImageView.sd_setImage(with: URL(string: post.imageUrl), placeholderImage: UIImage(named: "selectimage"))
        self.documentID = post.documentId
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likeBtn(_ sender: Any) {
        likePost()
    }
    
    @objc func likePost() {
        let firestore = Firestore.firestore()
        if let likeCount = Int(likesLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            firestore.collection("Posts").document(self.documentID).setData(likeStore, merge: true)
        }
    }
}
