//
//  DataManager.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/8.
//

import UIKit
import GPUImage
import SwifterSwift
 
struct ProfileItem: Codable {
    var thumb: String?
    var big: String?
}
 
struct HilightItem: Codable {
    var thumb: String?
    var big: String?
}

struct HilightBundle: Codable {
    var previewName: String = ""
    var itemList: [HilightItem] = []
    
}

class DataManager: NSObject {
    static let `default` = DataManager()
    var stickerList : [ProfileItem] {
        return DataManager.default.loadJson([ProfileItem].self, name: "sticker") ?? []
    }
    var emojiList: [ProfileItem] {
        return DataManager.default.loadJson([ProfileItem].self, name: "emoji") ?? []
    }
     
    var bgColorList: [ProfileItem] {
        return DataManager.default.loadJson([ProfileItem].self, name: "bgColor") ?? []
    }
     
    var hilightList: [HilightBundle] {
        return DataManager.default.loadJson([HilightBundle].self, name: "hilightList") ?? []
    }
    
    
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        
        
        
        
    }
    
}

extension DataManager {
    func loadJson<T: Codable>(_: T.Type, name: String, type: String = "json") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                return try! JSONDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        return nil
    }
    
    func loadJson<T: Codable>(_:T.Type, path:String) -> T? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            do {
                return try PropertyListDecoder().decode(T.self, from: data)
            } catch let error as NSError {
                print(error)
            }
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func loadPlist<T: Codable>(_:T.Type, name:String, type:String = "plist") -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            return loadJson(T.self, path: path)
        }
        return nil
    }
    
}


// filter
extension DataManager {
    func filterOriginalImage(image: UIImage, lookupImgNameStr: String) -> UIImage? {
        
        if let gpuPic = GPUImagePicture(image: image), let lookupImg = UIImage(named: lookupImgNameStr), let lookupPicture = GPUImagePicture(image: lookupImg) {
            let lookupFilter = GPUImageLookupFilter()
            
            gpuPic.addTarget(lookupFilter, atTextureLocation: 0)
            lookupPicture.addTarget(lookupFilter, atTextureLocation: 1)
            lookupFilter.intensity = 0.7
            
            lookupPicture.processImage()
            gpuPic.processImage()
            lookupFilter.useNextFrameForImageCapture()
            let processedImage = lookupFilter.imageFromCurrentFramebuffer()
            return processedImage
        } else {
            return nil
        }
        return nil
    }
}


