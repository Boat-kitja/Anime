//
//  Singerton.swift
//  ListOfPutang
//
//  Created by Kitja  on 29/8/2565 BE.
//



import Foundation
import FirebaseAuth
import FirebaseFirestore

class Service {
    
    var  listOfAnime = [Data]()
    let db = Firestore.firestore()
    
    static let shareInstance = Service()
    
   
    func ReloadMainController(name:String){
        
        guard let currentUser = UserName.sharedInstance.userName else{
            return}
        
        db.collection(currentUser).getDocuments { [self]  querySnapshot, error in
            if let e = error{
                print("can not load data from firestore")
            }else{
                
                if let snapshotDocuments = querySnapshot?.documents{
                    
                    
                    for doc in snapshotDocuments{
                        if doc.documentID == name {
                            for var i in self.listOfAnime.indices {
                                if self.listOfAnime[i].title == name{
                                    self.listOfAnime[i].mal_id = 2
                                }
                            }
                            
     
                            
                        }
                    }
                }
            }
            
        }
        
    }
}
