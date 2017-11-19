//
//  IParser.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 19.11.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}
