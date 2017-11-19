//
//  ImageListParser.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

struct ImageListModel {
    let urlString: String
}

class ImageListParser: IParser {
    
    typealias Model = [ImageListModel]
    
    func parse(data: Data) -> [ImageListModel]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let hits = json["hits"] as? [[String: AnyObject]] else {
                return nil
            }
            
            var urls: [ImageListModel] = []
            
            for hit in hits {
                guard let url = hit["webformatURL"] as? String else {
                    continue
                }
                urls.append(ImageListModel(urlString: url))
            }
                        
            return urls
        } catch {
            print("Error converting data to json: \(error.localizedDescription)")
            return nil
        }
    }
}
