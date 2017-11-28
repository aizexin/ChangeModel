//
//  main.swift
//  转换模型
//
//  Created by aizexin on 2017/11/27.
//  Copyright © 2017年 aizexin. All rights reserved.
//

import Foundation

let model  = ProductModel()
model.id   = "1"
model.name = "aizexin"

let image  = ImageModel()
image.id   = "image1"
image.url  = "www.baidu.com"


let subImage = SubImageModel()
subImage.id  = "subImage1"
subImage.subname = "subname"

image.subImage  = subImage

model.image = image

print("---------")
//_ = TransformDataTool.ai_propertyList(className: model.className)
//TransformDataTool.test(obj: model)
if let printmodel = model.transformDataWith(propertyName: "id") {
    print(printmodel)
} else {
    
}
//for (key,value) in storeListDict {
//    print("key = \(key),value= \(value.debugDescription)\n")
//}

