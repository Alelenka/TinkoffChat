//
//  OperationDataManager..swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation


class SaveOperation: Operation {
    var data: Data
    let completion: (Bool) -> ()
    let fullPath : URL
    
    init(data: Data, fullPath: URL, completion: @escaping (_ success: Bool) -> ()) {
        self.completion = completion
        self.data = data
        self.fullPath = fullPath
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        do {
            try data.write(to: self.fullPath, options: .atomic)
            completion(true)
        } catch {
            print("Couldn't write file in operation")
            completion(false)
        }
        
        completion(false)
    }
}

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

class OperationDataManager: SaveInfoProtocol {
    
    let fullPath: URL
    
    init() {
        let fileName = "profile"
        self.fullPath = URL.getDocumentsDirectory().appendingPathComponent(fileName);
    }
    
    func save(profileData: Data, completion: @escaping (_ result: Bool) -> ()) {
        let queue = OperationQueue()
        queue.name = "tinkoffChat.saveOperation"
        
        let saveOperation = SaveOperation(data:profileData, fullPath: fullPath) { success in
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        queue.addOperation(saveOperation)
    }
    
    func readFile(completion: @escaping (_ result: ProfileData?) -> ()) {
        let queue = OperationQueue()
        queue.name = "tinkoffChat.loadOperation"
        
        let loadOperation = LoadOperation(fullPath: fullPath) { profile in
            OperationQueue.main.addOperation {
                completion(profile)
            }
        }
        
        queue.addOperation(loadOperation)
    }
}
