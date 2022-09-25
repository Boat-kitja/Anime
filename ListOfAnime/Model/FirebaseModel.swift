//
//  modelFirebase.swift
//  ListOfPutang
//
//  Created by Kitja  on 5/9/2565 BE.
//

import Foundation

struct DataFormFireBase {
    let dataFB = [DataFB2]()
}

struct DataFB2:Equatable{
    let title:String
    let img:String
    let textBody:String
    let malId:Int
    let url:String
    let score:Int
}


