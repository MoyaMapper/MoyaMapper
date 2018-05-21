# MoyaMapper

[![CI Status](https://img.shields.io/travis/LinXunFeng/MoyaMapper.svg?style=flat)](https://travis-ci.org/LinXunFeng/MoyaMapper)
[![Version](https://img.shields.io/cocoapods/v/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper)
[![License](https://img.shields.io/cocoapods/l/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper)
[![Platform](https://img.shields.io/cocoapods/p/MoyaMapper.svg?style=flat)](https://cocoapods.org/pods/MoyaMapper)

<br><br>

![MoyaMapper](https://github.com/LinXunFeng/MoyaMapper/raw/master/Screenshots/MoyaMapper.png)



<br><br>MoyaMapper是基于Moya和SwiftyJSON封装的工具，以Moya的plugin的方式来实现间接解析，支持RxSwift

## Usage

### 一、注入插件 

1. 定义一个遵守ModelableParameterType协议的结构体

```swift
// 所返回的JSON数据对照
struct NetParameter : ModelableParameterType {
    static var successValue: String { return "false" }
    static var statusCodeKey: String { return "error" }
    static var tipStrKey: String { return "" }
    static var modelKey: String { return "results" }
}
```

2. 以plugin的方式传递给MoyaProvider

```swift
let lxfNetTool = MoyaProvider<LXFNetworkTool>(plugins: [MoyaMapperPlugin(NetParameter.self)])
```

### 二、定义模型

1. 创建一个遵守Modelable协议的结构体

```swift
struct MyModel: Modelable {
    
    var _id = ""
    ......
    
    init?(_ json: JSON) {
        
    }
    
    mutating func mapping(_ json: JSON) {
        self._id = json["_id"].stringValue
        ......
    }
}
```



### 三、解析

这里只贴出主要代码

- Normal

```swift
lxfNetTool.request(.data(type: .all, size: 10, index: 1)) { result in
    guard let response = result.value else { return }
    
    // Models
    guard let models = try? response.mapArray(MyModel.self) else {return}
    for model in models {
        print("id -- \(model._id)")
    }
    
    // 使用自定义模型参数类
    /*
    guard let models = try? response.mapArray(MyModel.self, params: { () -> (ModelableParameterType) in
        return CustomParameter()
    }) else {return}
    */
}
```

- Rx

```swift
// let rxRequest: Single<Response>

// MARK: Rx
let rxRequest = lxfNetTool.rx.request(.data(type: .all, size: 10, index: 1))

// Models
rxRequest.mapArray(MyModel.self).subscribe(onSuccess: { models in
    for model in models {
        print("id -- \(model._id)")
    }
}).disposed(by: dispseBag)

// Models + Result
rxRequest.mapArrayResult(MyModel.self).subscribe(onSuccess: { (result, models) in
    print("isSuccess --\(result.0)")
    print("tipStr --\(result.1)")
    print("models count -- \(models.count)")
}).disposed(by: dispseBag)

// 获取指定路径的值
rxRequest.fetchString(keys: [0, "_id"]).subscribe(onSuccess: { str in
    print("str -- \(str)")
}).disposed(by: dispseBag)
```



<hr>



### JSON数据对照

为方便理解，这里给出具体使用`JSON数据图`，结合 `Example`食用更佳～

![JSON数据对照](https://github.com/LinXunFeng/MoyaMapper/raw/master/Screenshots/JSON数据对照.png)



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



## License

MoyaMapper is available under the MIT license. See the LICENSE file for more info.



## Author

LinXunFeng

- email: 598600855@qq.com
- Blogs
  - [linxunfeng.top](http://linxunfeng.top/)
  - [掘金](https://juejin.im/user/58f8065e61ff4b006646c72d/posts)
  -  [简书](https://www.jianshu.com/u/31e85e7a22a2)