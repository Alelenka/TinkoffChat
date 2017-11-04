//
//  SaveOperation.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 04.11.17.
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
