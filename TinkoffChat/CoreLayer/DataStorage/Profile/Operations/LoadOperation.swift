//
//  LoadOperation.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class LoadOperation: Operation {
    
    var profile: (ProfileData?) -> ()
    let fullPath : URL
    
    
    init(fullPath: URL, profile: @escaping (_ profile:ProfileData?) -> ()) {
        self.profile = profile
        self.fullPath = fullPath
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        do {
            let data = try Data.init(contentsOf: self.fullPath)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let object = json as? [String : String] {
                profile(ProfileData.init(with: object))
            } else {
                profile(nil)
            }
            
        } catch {
            print("error reading in operation")
            profile(nil)
        }
    }
}
