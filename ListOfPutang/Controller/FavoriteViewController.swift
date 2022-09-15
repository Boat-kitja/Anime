//
//  FavoriteViewController.swift
//  ListOfPutang
//
//  Created by Kitja  on 27/8/2565 BE.
//

import UIKit
import FirebaseFirestore


class FavoriteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    var currentUser:String?
    let db = Firestore.firestore()
    var dataFromFB:[DataFB2] = []
    var dataFromFbFavorite:[DataFB2] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromFirebase()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layOut = UICollectionViewFlowLayout()
        layOut.itemSize = CGSize(width: 300, height: 350)
        collectionView.collectionViewLayout = layOut
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollectionViewCell")
    }
    
    func fetchDataFromFirebase(){
        db.collection(UserName.sharedInstance.userName!).getDocuments {querySnapshot, error in
            if let e = error{
                print("can not load data from firestore")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    print("save data to filebase completed")
                    self.dataFromFB = []
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let title = data["title"] as? String,
                           let img = data["img"] as? String,
                           let text = data["synopsis"] as? String,
                           let id =  data["ID"] as? Int,
                           let url = data["url"] as? String,
                           let score = data["score"] as? Int{
                            let newData = DataFB2(title:title,
                                                  img:img,
                                                  textBody: text,
                                                  malId: id,
                                                  url: url,
                                                  score: score)
                            self.dataFromFB.append(newData)
                        }
                    }
                }
            }
            self.collectionView.reloadData()
            self.hideCollectionView()
        }
    }
    
    func hideCollectionView() {
        if dataFromFB == [] {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataFromFB.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.nameLabel.text = dataFromFB[indexPath.row].title
        cell.contentLabel.text = dataFromFB[indexPath.row].textBody
        let imgUrl = dataFromFB[indexPath.row].img
        cell.img.downloaded(from: imgUrl )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailOfAnime2") as! DetailOfAnime2
        vc.listOfAnime2 = dataFromFB[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}








