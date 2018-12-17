//
//  WebService.swift
//  sampleMyBliss
//
//  Created by Athul on 14/12/18.
//  Copyright © 2018 myBliss. All rights reserved.
//

import UIKit

enum APIMethods: String {
    case GET = "GET"

}

class WebService {
    
    public static func getEpisodesWithPageNumber(_ pageNumber: Int, onSuccess success: @escaping (_ JSONArray: NSArray) -> Void, onFailure failure: @escaping (_ errorMessage: String) -> Void) {
        
        let url : String = Constants.URL.baseURL + Constants.URL.episodesListURL + "\(pageNumber)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = APIMethods.GET.rawValue
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            
            guard error == nil else {
                failure(error?.localizedDescription ?? Constants.Alert.networkUnavailable)
                return
            }
            guard let _ = data else {
                failure(Constants.Alert.serverIssue)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                if let episodes = json?["data"]?["episodes"] as? NSArray {
                    success(episodes)

                } else{
                    failure(Constants.Alert.unknownError)
                }
            } catch {
                failure(Constants.Alert.unknownError)
            }
        })
        
        task.resume()
    }
}



struct Episode {
    var id: UInt
    var title: String
    var subTitle: String
    var desc: String
    var imageUrl: URL?
    var smallImageUrl: URL?
    var date: String
    init(_ dictionary: [String: Any]) {
        self.id = UInt(dictionary["id"] as? Int ?? 0)
        self.title = dictionary["title"] as? String ?? ""
        self.subTitle = dictionary["subTitle"] as? String ?? ""
        self.desc = dictionary["description"] as? String ?? ""
        if let urlString = dictionary["imageUrl"] as? String {
            self.imageUrl = URL(string: urlString)
        }
        if let urlString = dictionary["smallImageUrl"] as? String {
            self.smallImageUrl = URL(string: urlString)
        }
        self.date = dictionary["date"] as? String ?? "01/01/01"
    }
}


