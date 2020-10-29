//
//  Jsonplaceholder.swift
//  jsonplaceholderiOS
//
//  Created by 許自翔 on 2020/10/28.
//

import Foundation

struct Photos:Codable {
    let albumId:Int
    let id:Int
    let title:String
    let url:String
    let thumbnailUrl:String
    var url150:URL{
        return URL(string: url)!
    }
    var url600:URL{
        return URL(string: thumbnailUrl)!
    }
    
}
