//
//  ImageModel.swift
//  转换模型
//
//  Created by aizexin on 2017/11/27.
//  Copyright © 2017年 aizexin. All rights reserved.
//

import Cocoa

class ImageModel :NSObject ,TransformDataProtocol {
    @objc var id  :String!
    @objc var url :String!
    var subImage : SubImageModel?
    
    required override init() {
        
    }
//    override var description: String {
//         return """
//                id  = \(id)
//                urll = \(url)
//                """
//    }
//    var debugDescription: String {
//        return """
//        id = \(id)
//        url = \(url)
//        """
//    }

}


