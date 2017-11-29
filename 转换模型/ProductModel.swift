//
//  ProductModel.swift
//  转换模型
//
//  Created by aizexin on 2017/11/27.
//  Copyright © 2017年 aizexin. All rights reserved.
//

import Cocoa

class ProductModel: NSObject, TransformDataProtocol {
    @objc var id    : String!
    @objc var name  : String!
    var image : ImageModel?
    
    
//    override init() {
//        
//    }
    
//    override var description: String {
//        return """
//                id = \(id)
//                name = \(name)
//               """
//    }
}

