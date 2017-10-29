//
//  URLExtension.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

public extension URL {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
