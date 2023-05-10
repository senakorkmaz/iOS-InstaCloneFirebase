//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Senanur Korkmaz on 3.05.2023.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userMailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonTapped(_ sender: UIButton!) {
        let db = Firestore.firestore()
        
        if var likeCount = Int(likeCountLabel.text!){
            let likeStore = ["likes" : likeCount + 1] as! [String : Any]
            db.collection("posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
}
