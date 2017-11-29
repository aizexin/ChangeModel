//
//  SubImageModel.swift
//  testChangeModel
//
//  Created by aizexin on 2017/11/28.
//  Copyright © 2017年 aizexin. All rights reserved.
//

import Cocoa

class SubImageModel: NSObject, TransformDataProtocol {
    @objc var id      :String!
    @objc var subname : String!
    
    required override init() {
        
    }
}
