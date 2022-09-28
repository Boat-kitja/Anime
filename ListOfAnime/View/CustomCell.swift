//
//  CustomCell.swift
//  ListOfPutang
//
//  Created by Kitja  on 26/8/2565 BE.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

protocol PassActionToStarBackToMainViewFavorite:AnyObject {
    func passActionBackToMainFavorite(name:String)
}

protocol PassActionToStarBackToMainViewUnFavorite:AnyObject {
    func passActionBackToMainUnFavorite(name:String)
}

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var star: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var imgURL:String = ""
    let db = Firestore.firestore()
    var malID:Int!
    let fireBase = FireBaseModel()
    let currentUser = UserName.sharedInstance.userName
    var url:String!
    var score:Int!
    weak var delegateFavorite:PassActionToStarBackToMainViewFavorite?
    weak var delegateUnFavorite:PassActionToStarBackToMainViewUnFavorite?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func starButtom(_ sender: Any) {
        switch star.currentImage {
        case UIImage(systemName: "star"):
            print("save")
            star.setImage(UIImage(systemName: "star.fill"), for: .normal)
            fireBase.saveItem(name: nameLabel.text!, text: titleLabel.text ?? "", imgUrl: imgURL, id: malID, url: url, score: score)
            delegateFavorite?.passActionBackToMainFavorite(name: nameLabel.text!)
        case UIImage(systemName: "star.fill"):
            print("delete")
            star.setImage(UIImage(systemName: "star"), for: .normal)
            fireBase.deleteItem(name: nameLabel.text!)
            delegateUnFavorite?.passActionBackToMainUnFavorite(name: nameLabel.text!)
        default:
            print("Can not favorite or unfavorite")
        }
    }
}
