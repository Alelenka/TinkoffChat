//
//  SaveInfoProtocol.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 15.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IProfileProtocol {
    func save(profile: ProfileData, completion: @escaping (_ result: Bool) -> ())
    func load(completion: @escaping (ProfileData?) -> Void)
}
