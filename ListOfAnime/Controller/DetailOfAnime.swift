

import UIKit
import FirebaseFirestore
import FirebaseAuth
import WebKit

protocol PassUnfavoriteToMainControllerForSetStarToNormal{
    func unFavorite(name:String)
}

class DetailOfAnime: UIViewController {
    var malID:Float!
    let db = Firestore.firestore()
    var listOfAnime2:DataToSetTableView!
    let mainView = MainViewController()
    let fireBase = FireBaseModel()
    var webView: WKWebView!
    var currentUser:String?
    var dataFromFB:DataFB2!
    var delegate:PassUnfavoriteToMainControllerForSetStarToNormal?
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var allOftext: UILabel!
    @IBOutlet weak var webButtom: UIButton!
    @IBOutlet weak var favoriteButtom: UIButton!
    @IBOutlet weak var unFavoriteButtom: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = listOfAnime2.title
        allOftext.text = listOfAnime2.synopsis
        unFavoriteButtom.isHidden = true
        let imgUrl = listOfAnime2.images
        mainImage.downloaded(from: imgUrl)
        filterFirebaseToHiddenButton()
        usleep(270000)
    }
    
    func filterFirebaseToHiddenButton(){
        guard let currentUser = UserName.sharedInstance.userName else{
            return
        }
        db.collection(currentUser).getDocuments { querySnapshot, error in
            if let e = error{
                print("can not load data from firestore")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        DispatchQueue.main.async {
                            if doc.documentID == self.nameLabel.text{
                                self.favoriteButtom.isHidden = true
                                self.unFavoriteButtom.isHidden = false
                            }
                                }
                            }
                        }
                    }
                }
            } 

    @IBAction func webBut(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        vc.url = listOfAnime2.url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWeb" {
            if let WebViewController = segue.destination as? WebViewController {
                WebViewController.url = listOfAnime2.url
            }
        }
    }
    
    @IBAction func favoriteBut(_ sender: Any) {
        unFavoriteButtom.isHidden = false
        favoriteButtom.isHidden = true
        fireBase.saveItem(name: listOfAnime2.title,
                          text: listOfAnime2.synopsis ?? "",
                          imgUrl: listOfAnime2.images,
                          id: Int(listOfAnime2.mal_id),
                          url: listOfAnime2.url,
                          score: Int(listOfAnime2.score ?? 0))
    }
        
    @IBAction func unFavoriteBut(_ sender: Any) {
        favoriteButtom.isHidden = false
        unFavoriteButtom.isHidden = true
        delegate?.unFavorite(name: listOfAnime2.title)
        fireBase.deleteItem(name: listOfAnime2.title)
        self.navigationController?.popViewController(animated:true)
    }
}
