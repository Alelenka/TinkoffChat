//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManader: SaveInfoProtocol {
    
    let fullPath: URL
    
    init() {
        let fileName = "profile"
        self.fullPath = URL.getDocumentsDirectory().appendingPathComponent(fileName);
    }
    
    func save(profileData: Data, completion: @escaping (_ result: Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try profileData.write(to: self.fullPath, options: .atomic)
                
                DispatchQueue.main.async {
                    completion(true)
                }
                
            } catch {
                print("Couldn't write file")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func readFile(completion: @escaping (_ result: ProfileData?) -> ()) {
        DispatchQueue.global().async {
            do {
                let data = try Data.init(contentsOf: self.fullPath)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let object = json as? [String : String] {
                    let profile = ProfileData.init(with: object)
                    DispatchQueue.main.async {
                        completion(profile)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
                
            } catch {
                print("error reading")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func compareChanges(newData: Data, completion: @escaping (_ saveNeeded: Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data.init(contentsOf: self.fullPath)
                DispatchQueue.main.async {
                    completion(data != newData)
                }
            } catch {
                print("ololo")
                completion(true)
            }
        }
        
    }
}
