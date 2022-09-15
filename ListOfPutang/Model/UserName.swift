//
//  File.swift
//  ListOfPutang
//
//  Created by Kitja  on 29/8/2565 BE.
//

import Foundation

struct UserName {
    static var sharedInstance = UserName()
       private init() {}
       var userName: String?  
}
