import Foundation
import Cocoa

var storeListDict = [String:[String:Any]]()

//自定义一个转换协议
protocol TransformDataProtocol {
    
    ///将一个模型 数据转成存储的字典
    func transformDataToStoreWith(propertyName: String) -> Any?
    
    /// 把模型以 属性名字 转为索引类型
    ///
    /// - Parameter propertyName: 属性名字
    /// - Returns: 索引字典
    func transformDataToindex(propertyName: String) -> [String:String]
}

//扩展协议方法，实现一个通用的方法（反射实现）
extension TransformDataProtocol {
    
    /// 把模型以 属性名字 转为索引类型
    func transformDataToindex(propertyName: String) -> [String:String] {
        ///根据实例创建反射结构体Mirror
        let mirror = Mirror(reflecting: self)
        if mirror.children.count <= 0  {
            return [:]
        }
        //创建一个空字典，用于后面添加键值对
        var result: [String:String] = [:]
        //遍历实例的所有属性集合
        for children in mirror.children {
            let propertyNameString = children.label!
            let value = children.value
            if propertyNameString == propertyName {
                result[propertyNameString]   = value as? String
                let typeString = "\(mirror.subjectType)"
                result["type"]               = typeString
            }
        }
        return result
    }
    
    ///将一个模型 数据转成存储的字典
    func transformDataToStoreWith(propertyName: String) -> Any? {
        
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
    
    /// 建立关联，只有id和type、遵循协议的类
    ///
    /// - Parameters:
    ///   - propertyName: 以那个属性作为key
    ///   - any: 任何遵循协议的类
    /// - Returns:
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
    
    
    /// 通过索引去查询还原实体
    ///
    /// - Parameter index: 索引字典
    /// - Returns:
    func transformStoreWithIndex(index:[String: String],key :String) -> Any? {
        guard let id = index[key],
        let type = index["type"] else {
            return nil
        }
        var typeArray = storeListDict[type]
        let object : AnyObject? = NSClassFromString(type)
        let mirror = Mirror(reflecting: typeArray![id]!)
        
        for child in mirror.children {
            let subMirror = Mirror.init(reflecting: child.value)
            if subMirror.subjectType is String.Type {
                object?.setValue(child.value, forKey: child.label!)
            } else {
                object?.setValue(transformStoreWithIndex(index: child.value as! [String: String], key: key), forKey: child.label!)
            }
        }
        return nil
    }
    
    /// 储存
    func saveToStore(propertyName: String) -> Void {
        ///根据实例创建反射结构体Mirror
        let mirror = Mirror(reflecting: self)
        let typeName = "\(mirror.subjectType)"
        
        //获取这个类的字典
        var idkey = ""
        for child in mirror.children {
            if child.label == propertyName {
                idkey = child.value as! String
            }
        }
        if var dict = storeListDict[typeName] {
            if let any = transformDataToStoreWith(propertyName: propertyName) {
//                dict.updateValue(any, forKey: idkey)
                dict[idkey] = any as? [String : Any]
                storeListDict[typeName] = dict
            }
        } else {
            if let any = transformDataToStoreWith(propertyName: propertyName) {
                storeListDict[typeName] = any as? [String : Any]
//                storeListDict.updateValue([idkey:any], forKey: typeName)
            }
        }
    }
}

//扩展可选类型，使其遵循转换协议，可选类型值为nil时，不转化进字典中
extension Optional :TransformDataProtocol {
    //可选类型重写transformDataWith()方法
    func transformDataToStoreWith(propertyName: String) -> Any? {
        if let x = self {
            if let value = x as? TransformDataProtocol {
                return value.transformDataToStoreWith(propertyName: propertyName)
            }
        }
        return nil
    }
    
    func transformDataToindex(propertyName: String) -> [String : String] {
        if let x = self {
            if let value = x as? TransformDataProtocol {
                return value.transformDataToindex(propertyName: propertyName)
            }
        }
        return [:]
    }
}

