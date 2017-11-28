import Foundation
import Cocoa

var storeListDict = [String:[String:Any]]()

//自定义一个转换协议
protocol TransformDataProtocol {
    func transformDataWith(propertyName: String) -> Any?
}
//扩展协议方法，实现一个通用的toJSONModel方法（反射实现）
extension TransformDataProtocol {
    //将模型数据转成可用的字典数据，Any表示任何类型，除了方法类型
    func transformDataWith(propertyName: String) -> Any? {
        
        ///根据实例创建反射结构体Mirror
        let mirror = Mirror(reflecting: self)
        if mirror.children.count > 0  {
            //创建一个空字典，用于后面添加键值对
            var result: [String:Any] = [:]
            //这个用来放实体，遇到model只记录id
            var data: [String: Any] = [:]
            
            var propertyValue  = ""
            //遍历实例的所有属性集合
            for children in mirror.children {
                let propertyNameString = children.label!
                let value = children.value
                
                print("propertyNameString = \(propertyNameString)")
                
                if propertyNameString == propertyName {
                    
                    data[propertyNameString]   = value
                    propertyValue              = value as! String
                    let typeString = "\(mirror.subjectType)"
                    data["type"]               = typeString
                    
                } else if let transformValue = value as? TransformDataProtocol {
                    //判断value的类型是否遵循transform协议，进行深度递归调用
                    data[propertyNameString] = transformValue.buildConnection(propertyName: propertyName, any: transformValue)
                } else {
                    data[propertyNameString] = value
                }
            }
            result[propertyValue]     = data
            
            return result
        }
        return self
    }
    
    func buildConnection(propertyName: String,any :TransformDataProtocol) -> Any? {
        ///根据实例创建反射结构体Mirror
        let mirror = Mirror(reflecting: any)
        if mirror.children.count > 0  {
            
            //这个用来放实体，遇到model只记录id
            var data: [String: Any] = [:]
            //遍历实例的所有属性集合
            for children in mirror.children {
                let propertyNameString = children.label!
                let value = children.value
                if propertyNameString == propertyName {
                    data[propertyNameString]   = value
                    let typeString = "\(mirror.subjectType)"
                    data["type"]               = typeString
                    
                } else if let transformValue = value as? TransformDataProtocol {
                    //判断value的类型是否遵循transform协议，进行深度递归调用
                    if propertyNameString == "some" && mirror.children.count == 1 {
                        if let value = transformValue.buildConnection(propertyName: propertyName,any: transformValue) as? [String : Any] {
                            data = value
                        }
                    } else {
                        data[propertyNameString] = transformValue.buildConnection(propertyName: propertyName,any: transformValue)
                    }
                }
            }
            return data
        }
        return any
        
    }
    
}

//扩展可选类型，使其遵循转换协议，可选类型值为nil时，不转化进字典中
extension Optional :TransformDataProtocol {
    //可选类型重写transformDataWith()方法
    func transformDataWith(propertyName: String) -> Any? {
        if let x = self {
            if let value = x as? TransformDataProtocol {
                return value.transformDataWith(propertyName: propertyName)
            }
        }
        return nil
    }
}

