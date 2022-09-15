//
//  FireBaseModel.swift
//  ListOfPutang
//
//  Created by Kitja  on 29/8/2565 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FireBaseModel{
    let db = Firestore.firestore()
    var listOfAnime = [Data]()
    var currentUser =  UserName.sharedInstance.userName
    var searchArray:[Data]!
    var dataFromFB:[DataFB2]?
    
    func saveItem(name:String,text:String,imgUrl:String,id:Int,url:String,score:Int){
        if let currentUser =  currentUser {
            db.collection(currentUser).document(name).setData(["synopsis" : text, "img" : imgUrl, "title" : name, "ID" : id, "url": url,"score":score])
            { error in
                if error != nil{
                    print("cannot save data to firestore")
                }else{
                    print("successfully save data")
                }
            }
        }
    }
    
    func deleteItem (name:String!){
        if let currentUser = currentUser{
            db.collection(currentUser).document(name).delete()
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
    func filterDataFromFirebaseForUpdateFavorite(dataTotableView:[DataToSetTableView]) -> [DataToSetTableView] {
        var data = dataTotableView
        if let currentUser = currentUser {
            db.collection(currentUser).getDocuments { querySnapshot, error in
                if error != nil{
                    print("can not load data from firestore")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let titleForFilterToSetFavoriteFromFirebase = doc.documentID
                            for i in data.indices {
                                if data[i].title == titleForFilterToSetFavoriteFromFirebase  {
                                    data[i].favorite = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return data
    }
    
    func favorite(name:String){
        db.collection(currentUser!).document(name).setData(["favorite":true],merge:true)
    }
    
    func unFavorite(name:String){
        db.collection(currentUser!).document(name).setData(["favorite":false],merge:true)
    }
}



