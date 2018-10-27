![MoyaMapper](https://github.com/LinXunFeng/MoyaMapper/raw/master/Screenshots/MoyaMapper.png)



<center>

[![Author](https://img.shields.io/badge/author-LinXunFeng-blue.svg)](https://cocoapods.org/pods/MoyaMapper) [![Build Status](https://travis-ci.org/MoyaMapper/MoyaMapper.svg?branch=master)](https://travis-ci.org/MoyaMapper/MoyaMapper)  [![Version](https://img.shields.io/cocoapods/v/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper) [![License](https://img.shields.io/github/license/LinXunFeng/MoyaMapper.svg)](https://cocoapods.org/pods/MoyaMapper) [![Platform](https://img.shields.io/cocoapods/p/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper)

</center>

>  MoyaMapper是基于Moya和SwiftyJSON封装的工具，以Moya的plugin的方式来实现间接解析，支持RxSwift
>
>  📖 详细的使用请查看手册 [https://MoyaMapper.github.io](https://moyamapper.github.io/)



## Feature

- 支持`json` 转 `Model ` 自动映射 与 自定义映射
- 无视 `json` 中值的类型，`Model` 中属性声明的是什么类型，它就是什么类型
- 支持 `json` 字符串转`Model`
- 插件方式，全方位保障`Moya.Response`，拒绝各种网络问题导航 `Response` 为 `nil`
- Optional - 支持数据随意缓存( `JSON` `Number` 、`String`、 `Bool`、 `Moya.Response` )
- Optional - 支持网络请求缓存 



## Usage



#####  一、插件

![success-obj](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/success-obj.png)

定义适用于项目接口的 `ModelableParameterType`

```swift
// statusCodeKey、tipStrKey、 modelKey 可以任意指定级别的路径，如： "error>used"
struct NetParameter : ModelableParameterType {
    var successValue = "000"
    var statusCodeKey = "retStatus"
    var tipStrKey = "retMsg"
    var modelKey = "retBody"
}
```

在 `MoyaProvider` 中使用 `MoyaMapperPlugin` 插件，并指定 `ModelableParameterType`

```swift
let lxfNetTool = MoyaProvider<LXFNetworkTool>(plugins: [MoyaMapperPlugin(NetParameter())])
```



❗ 使用 `MoyaMapperPlugin` 插件是整个 `MoyaMapper`  的核心所在！



##### 二、Model声明

> 1、`MoyaMapper` 支持模型自动映射
>
> 2、不需要考虑源json数据的真实类型，这里统一按 `Model` 中属性声明的类型进行转换



一般情况下如下写法即可

```swift
struct CompanyModel: Modelable {
    
    var name : String = ""
    var catchPhrase : String = ""
    
    init() { }
}
```



如果键名需要自定义，则可以实现方法 `mutating func mapping(_ json: JSON)`

```swift
struct CompanyModel: Modelable {
    
    var name : String = ""
    var catchPhrase : String = ""
    
    init() { }
    mutating func mapping(_ json: JSON) {
        self.name = json["nickname"].stringValue
    }
}
```



支持模型嵌套

```swift
struct UserModel: Modelable {
    
    var id : String = ""
    var name : String = ""
    var company : CompanyModel = CompanyModel()
    
    init() { }
}
```



##### 三、Response --> Model



> 1、以下示例皆使用了 `MoyaMapperPlugin` ，所以不需要指定 `解析路径`
>
> 2、如果没有使用 `MoyaMapperPlugin` 则需要指定 `解析路径`，否则无法正常解析
>
> ps:  `解析路径` 可以使用 `a>b` 这种形式来解决多级路径的问题



如果接口请求后 `json` 的数据结构与下图类似，则使用 `MoyaMapper` 是最合适不过了

![success-obj](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/success-obj.png)



```swift
// Normal
let model = response.mapObject(MMModel.self)
print("name -- \(model.name)")
print("github -- \(model.github)")

// 打印json
print(response.fetchJSONString())

// Rx
rxRequest.mapObject(MMModel.self)
    .subscribe(onSuccess: { (model) in
        print("name -- \(model.name)")
        print("github -- \(model.github)")
    }).disposed(by: disposeBag)
```

![success-array](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/success-array.png)

```swift
// Normal
let models = response.mapArray(MMModel.self)
let name = models[0].name
print("count -- \(models.count)")
print("name -- \(name)")

// 打印 json 模型数组中第一个的name
print(response.fetchString(keys: [0, "name"]))

// Rx
rxRequest.mapArray(MMModel.self)
    .subscribe(onSuccess: { models in
        let name = models[0].name
        print("count -- \(models.count)")
        print("name -- \(name)")
    }).disposed(by: disposeBag)
```

![fail](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/fail.png)



```swift
// Normal
let (isSuccess, tipStr) = response.mapResult()
print("isSuccess -- \(isSuccess)")
print("tipStr -- \(tipStr)")

// Rx
rxRequest.mapResult()
    .subscribe(onSuccess: { (isSuccess, tipStr) in
        print("isSuccess -- \(isSuccess)") // 是否为 "000"
        print("retMsg -- \(retMsg)")
    }).disposed(by: disposeBag)
```





## CocoaPods

- 默认安装

MoyaMapper默认只安装Core下的文件

```ruby
pod 'MoyaMapper'
```

- RxSwift拓展

```ruby
pod 'MoyaMapper/Rx'
```

- 缓存拓展

```ruby
pod 'MoyaMapper/MMCache'
```

- Rx缓存

```ruby
pod 'MoyaMapper/RxCache'
```



## License

MoyaMapper is available under the MIT license. See the LICENSE file for more info.



## Author

LinXunFeng

- email: 598600855@qq.com
- Blogs
  - [linxunfeng.top](http://linxunfeng.top/)
  - [掘金](https://juejin.im/user/58f8065e61ff4b006646c72d/posts)
  -  [简书](https://www.jianshu.com/u/31e85e7a22a2)
