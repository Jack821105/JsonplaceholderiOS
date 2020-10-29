//
//  Network.swift
//  jsonplaceholderiOS
//
//  Created by 許自翔 on 2020/10/28.
//

import Foundation
import UIKit

class Network{
    
    static let shared = Network()
    let imageCache = NSCache<NSURL, UIImage>()
    //GetAllData
    func fetchData(limit:Int?,pages:Int?,completion:@escaping ([Photo]) -> Void) {
        guard let limit = limit, let pages = pages,let url = URL(string:compostRequest(urlString: API.photos.rawValue, limit: limit, pages: pages))  else {
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = HttpMethod.get.rawValue
        req.setValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error{
                print("error:\(error.localizedDescription)")
            }else if let response = response, let data = data{
                if let decoder = try? JSONDecoder().decode([Photo].self, from: data){
                    completion(decoder)
                }
            }
        }.resume()
        
    }
    
    private func compostRequest(urlString: String?, limit:Int?,pages:Int?) -> String {
        guard let urlString = urlString,let limit = limit,let pages = pages else {
            return NSError().localizedDescription
        }
        let url = urlString.appending("?_limit=\(limit)&_page=\(pages)")
        return url
    }
    
    /*----------------------------------------------------------------------------------*/
    
    func fetchImage(url:URL,completion:@escaping (UIImage?) -> Void) {
        guard url != nil else {
            return
        }
        if let image = imageCache.object(forKey: url as NSURL) {
            completion(image)
            return
        }
        var req = URLRequest(url: url)
        req.httpMethod = HttpMethod.get.rawValue
        req.addValue(ContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                print("error:\(error.localizedDescription)")
            }else if let response = response, let data = data , let image = UIImage(data: data){
                self.imageCache.setObject(image, forKey: url as NSURL)
                completion(image)
            }else {
                completion(nil)
            }
        }.resume()
        
    }
    /*----------------------------------------------------------------------------------*/
}



extension Network {
    
    enum API:String {
        case photos = "https://jsonplaceholder.typicode.com/photos"
        
        
    }
    
    enum HttpMethod:String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    enum ContentType:String {
        case json = "application/json"
    }
    
    
}
