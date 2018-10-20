![MoyaMapper](https://github.com/LinXunFeng/MoyaMapper/raw/master/Screenshots/MoyaMapper.png)



<center>
[![](https://img.shields.io/badge/author-LinXunFeng-blue.svg)](https://cocoapods.org/pods/MoyaMapper) [![Version](https://img.shields.io/cocoapods/v/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper)[![License](https://img.shields.io/github/license/LinXunFeng/MoyaMapper.svg)](https://cocoapods.org/pods/MoyaMapper)[![Platform](https://img.shields.io/cocoapods/p/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper)

</center>

>  MoyaMapper是基于Moya和SwiftyJSON封装的工具，以Moya的plugin的方式来实现间接解析，支持RxSwift



详细的使用 手册 [https://MoyaMapper.github.io](https://moyamapper.github.io/)



如果接口请求后 `json` 的数据结构与下图类似，则使用 `MoyaMapper` 是最合适不过了



## Usage



### Model



支持模型自动映射，不需要考虑源json数据的真实类型，这里统一按`Model`中属性声明的类型进行转换



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





### Response --> Model

![success-obj](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/success-obj.png)



```swift
// Normal
let model = response.mapObject(MMModel.self, modelKey: "retBody")
print("name -- \(model.name)")
print("github -- \(model.github)")

// Rx
rxRequest.mapObject(MMModel.self, modelKey: "retBody")
    .subscribe(onSuccess: { (model) in
        print("name -- \(model.name)")
        print("github -- \(model.github)")
    }).disposed(by: disposeBag)
```

![success-array](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/success-array.png)

```swift
// Normal
let models = response.mapArray(MMModel.self, modelKey: "retBody")
let name = models[0].name
print("count -- \(models.count)")
print("name -- \(name)")

// Rx
rxRequest.mapArray(MMModel.self, modelKey: "retBody")
    .subscribe(onSuccess: { models in
        let name = models[0].name
        print("count -- \(models.count)")
        print("name -- \(name)")
    }).disposed(by: disposeBag)
```

![fail](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/fail.png)



```swift
// Normal
let (isSuccess, tipStr) = response.mapResult {  CustomNetParameter() }
print("isSuccess -- \(isSuccess)")
print("tipStr -- \(tipStr)")

// Rx
rxRequest.mapResult { CustomNetParameter() }
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