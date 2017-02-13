//
//  Extentions.swift
//  gameofchat
//
//  Created by Oleg Pavlichenkov on 27/01/2017.
//  Copyright © 2017 Oleg Pavlichenkov. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
  
  func  loadImageWith(urlString: String) {
    
    self.image = nil
    
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      
      self.image = cachedImage
      
    } else {
      
      let url = URL(string: urlString)
      URLSession.shared.dataTask(with: url!) { (data, response, error) in
        
        if error != nil {
          print("===[NewMessageController]\(error)\n")
          return
        }
        
        DispatchQueue.main.async {
          if let downloadedImage = UIImage(data: data!) {
            imageCache.setObject(downloadedImage, forKey: urlString as NSString)
            self.image = downloadedImage
          }
        }
      }.resume()      
    }
    

  }
}
