//
//  DataService.swift
//  my-hood-genxos
//
//  Created by Todd Fields on 2015-12-31.
//  Copyright © 2015 Todd Fields. All rights reserved.
//

import Foundation
import UIKit

class DataService {
  
  static let instance = DataService()
  
  private var _loadedPosts = [Post]()
  
  let KEY_POSTS = "posts"
  var loadedPosts: [Post] {
    
    return _loadedPosts
  }
  
  func savePosts() {
    
    let postsData = NSKeyedArchiver.archivedDataWithRootObject(_loadedPosts)
    NSUserDefaults.standardUserDefaults().setObject(postsData, forKey: KEY_POSTS)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  func loadPosts() {
    
    if let postsData = NSUserDefaults.standardUserDefaults().objectForKey(KEY_POSTS) as? NSData {
      
      if let postsArray = NSKeyedUnarchiver.unarchiveObjectWithData(postsData) as? [Post] {
        
        _loadedPosts = postsArray
      }
    }
    
    NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "postsLoaded", object: nil))
  }
  
  func saveImageAndCreatePath(image: UIImage) -> String {
    
    let imgData = UIImagePNGRepresentation(image)
    let imgPath = "image\(NSDate.timeIntervalSinceReferenceDate()).png"
    let fullPath = documentsPathForFilename(imgPath)
    imgData?.writeToFile(fullPath, atomically: true)
    
    return imgPath
  }
  
  func imageForPath(path: String) -> UIImage? {
    
    let fullPath = documentsPathForFilename(path)
    let image = UIImage(named: fullPath)
    return image
  }
  
  func addPost(post: Post) {
    _loadedPosts.append(post)
    savePosts()
    loadPosts()
  }
  
  func documentsPathForFilename(name: String) -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let fullPath = paths[0] as? NSString
    return (fullPath?.stringByAppendingPathComponent(name))!
  }
  
}