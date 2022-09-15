//
//  DetailOfAnime2.swift
//  ListOfPutang
//
//  Created by Kitja  on 28/8/2565 BE.
//


import UIKit
import FirebaseFirestore
import FirebaseAuth

class DetailOfAnime2: UIViewController {
    let db = Firestore.firestore()
    var listOfAnime2:DataFB2!
    var url:String?
    var firebaseModel = FireBaseModel()
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var allOftext: UILabel!
    @IBOutlet weak var webButtom: UIButton!
    @IBOutlet weak var favoriteButtom: UIButton!
    @IBOutlet weak var unFavoriteButtom: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        unFavoriteButtom.isHidden = false
        favoriteButtom.isHidden = true
        nameLabel.text = listOfAnime2.title
        allOftext.text = listOfAnime2.textBody
        let imgUrl = listOfAnime2.img
        mainImage.downloaded(from: imgUrl)
    }
    
    @IBAction func webBut(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.url = listOfAnime2.url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func unFavoriteBut(_ sender: Any) {
        if let UserName =  UserName.sharedInstance.userName{
            firebaseModel.deleteItem(name: listOfAnime2.title)
            NotificationCenter.default.post(name: .myNotification, object: nil, userInfo: ["title" : listOfAnime2.title])
            self.navigationController?.popViewController(animated:true)
        }
    }
}
 

