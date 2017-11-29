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

 let printmodel = model.transformDataToindex(propertyName: "id")
// print(printmodel)

model.saveToStore(propertyName: "id")

let model2  = ProductModel()
model2.id   = "2"
model2.name = "aizexin222"

model2.saveToStore(propertyName: "id")

//for (key,value) in storeListDict {
//    print("key = \(key),value= \(value.debugDescription)\n")
//}
//print(model.transformDataToindex(propertyName: "id"))

let model3 = model.transformStoreWithIndex(index: model.transformDataToindex(propertyName: "id"), key: "id")
print(model3)
