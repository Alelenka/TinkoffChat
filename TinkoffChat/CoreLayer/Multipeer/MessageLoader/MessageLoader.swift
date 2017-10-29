//
//  MessageLoader.swift
//  TinkoffChat
//
//  Created by Alyona Belyaeva on 29.10.17.
//  Copyright © 2017 AB. All rights reserved.
//

import Foundation

protocol IMessageLoader {
    var parser: IMessageParser { get set }
    var maker: IMessageMaker { get set }
}

class MessageLoader: IMessageLoader{
    
    var parser: IMessageParser
    var maker: IMessageMaker
    
    init(parser: IMessageParser, maker: IMessageMaker) {
        self.parser = parser
        self.maker = maker
    }
}
