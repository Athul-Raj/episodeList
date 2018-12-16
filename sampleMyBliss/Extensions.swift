//
//  Extensions.swift
//  sampleMyBliss
//
//  Created by Athul on 17/12/18.
//  Copyright © 2018 myBliss. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func cacheImage(url: URL){
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            if data != nil {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: url.absoluteString as AnyObject)
                    self.image = imageToCache
                }
            }
            }.resume()
    }
}

