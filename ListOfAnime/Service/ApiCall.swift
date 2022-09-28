//
//  File.swift
//  ListOfPutang
//
//  Created by Kitja  on 25/8/2565 BE.
//

import Foundation
import Alamofire

protocol PassDataToViewDelegate{
    func passDataToview(data:DataFromJson)
}

struct ApiCall {
    var delegate: PassDataToViewDelegate?
    let url = "https://api.jikan.moe/v4/anime"
    
    func fetchAnime(animeName: String) {
        var urlString = ""
        if animeName.count == 0 {
            urlString = "\(url)"
        } else {
            urlString = "\(url)?q=\(animeName)"
        }
        apiCaller(animeString: urlString)
    }
    
    func apiCaller(animeString:String){
        AF.request(animeString).responseString { response in
            do{
                guard let data = response.data else {
                    return
                }
                let responseModel = try JSONDecoder().decode(DataFromJson.self, from: data)
                self.delegate?.passDataToview(data: responseModel)
            }catch let error{
                print (error)
            }
        }
    }
}


