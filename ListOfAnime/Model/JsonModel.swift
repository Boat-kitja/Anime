//
//  DataFromJson.swift
//  ListOfPutang
//
//  Created by Kitja  on 25/8/2565 BE.
//

import Foundation

struct DataFromJson:Codable{
    let data: [Data]
}

struct Data:Codable {
    var mal_id:Float
    let url:String
    let images:Dictionary<String, JPG>
    let synopsis:String?
    let title:String
    let score:Float?
    var rank:Float?
}

struct JPG:Codable {
    let image_url:String
    let small_image_url:String
    let large_image_url:String
}




