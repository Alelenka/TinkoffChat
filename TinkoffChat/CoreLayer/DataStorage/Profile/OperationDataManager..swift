//
//  OperationDataManager..swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

class OperationDataManager: IProfileProtocol {
    
    let fullPath: URL
    
    init() {
        let fileName = "profile"
        self.fullPath = URL.getDocumentsDirectory().appendingPathComponent(fileName);
    }
    
    func save(profile: ProfileData, completion: @escaping (_ result: Bool) -> ()) {
        let queue = OperationQueue()
        queue.name = "tinkoffChat.saveOperation"
        
        let saveOperation = SaveOperation(data:profile.getSavingData(), fullPath: fullPath) { success in
            OperationQueue.main.addOperation {
                completion(success)
            }
        }
        
        queue.addOperation(saveOperation)
    }
    
    func load(completion: @escaping (ProfileData?) -> Void) {
        
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
