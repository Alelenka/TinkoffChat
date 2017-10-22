//
//  SaveInfoProtocol.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol SaveInfoProtocol {
    func save(profileData: Data, completion: @escaping (_ result: Bool) -> ())
}
