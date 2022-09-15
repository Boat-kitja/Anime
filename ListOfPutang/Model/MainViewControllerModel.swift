//
//  DataToSetTableView.swift
//  ListOfPutang
//
//  Created by Kitja  on 10/9/2565 BE.
//

import Foundation

struct DataToSetTableView {
        var mal_id:Float
        var url:String
        var images:String
        var synopsis:String?
        var title:String
        var score:Float?
        var rank:Float?
        var favorite:Bool?
    
    static func createDataToSetTableView(datas: [Data]) -> [DataToSetTableView] {
        var dataToSetTableViews = [DataToSetTableView]()
        for data in datas{
            let animeForTableView =
            DataToSetTableView (mal_id:data.mal_id,
                                    url: data.url,
                                    images: data.images["webp"]!.large_image_url,
                                    synopsis: data.synopsis,
                                    title: data.title,
                                    score: data.score,
                                    favorite: false)
            dataToSetTableViews.append(animeForTableView)
        }
        return dataToSetTableViews
    }
}




   
