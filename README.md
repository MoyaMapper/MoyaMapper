![MoyaMapper](https://github.com/LinXunFeng/MoyaMapper/raw/master/Screenshots/MoyaMapper.png)

<p align="center">
  <a href="https://github.com/LinXunFeng">
    <img src="https://img.shields.io/badge/author-LinXunFeng-blue.svg" alt="Author" />
  </a>
  <a href="https://travis-ci.org/MoyaMapper/MoyaMapper">
    <img src="https://travis-ci.org/MoyaMapper/MoyaMapper.svg?branch=master" alt="Build Status" />
  </a>
  <a href="https://cocoapods.org/pods/MoyaMapper">
    <img src="https://img.shields.io/cocoapods/v/MoyaMapper.svg?style=flat" alt="Version" />
  </a>
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage" />
  </a>
  <a href="https://cocoapods.org/pods/MoyaMapper">
    <img src="https://img.shields.io/github/license/LinXunFeng/MoyaMapper.svg" alt="License" />
  </a>
  <a href="https://cocoapods.org/pods/MoyaMapper">
    <img src="https://img.shields.io/cocoapods/p/MoyaMapper.svg?style=flat" alt="Platform" />
  </a>
</p>


>  MoyaMapper是基于Moya和SwiftyJSON封装的工具，以Moya的plugin的方式来实现间接解析，支持RxSwift
>
>  📖 详细的使用请查看手册 [https://MoyaMapper.github.io](https://moyamapper.github.io/)



## Feature

- 支持`json` 转 `Model ` 自动映射 与 自定义映射
- 无视 `json` 中值的类型，`Model` 中属性声明的是什么类型，它就是什么类型
- 支持 `json字符串` 转`Model`
- 支持定义默认值策略、解析策略
- 插件方式，全方位保障`Moya.Response`，拒绝各种网络问题导致 `Response` 为 `nil`
- Optional - 支持数据随意缓存( `JSON`、 `Number` 、`String`、 `Bool`、 `Moya.Response` )
- Optional - 支持网络请求缓存 



## Usage

### 映射

#####  一、插件

![success-obj](https://github.com/MoyaMapper/MoyaMapper.github.io/raw/master/img/code/success-obj.png)

1、定义适用于项目接口的 `ModelableParameterType`

```swift
// statusCodeKey、tipStrKey、 modelKey 可以任意指定级别的路径，如： "error>used"
struct NetParameter : ModelableParameterType {
    var successValue = "000"
    var statusCodeKey = "retStatus"
    var tipStrKey = "retMsg"
    var modelKey = "retBody"
}
```

2、在 `MoyaProvider` 中使用 `MoyaMapperPlugin` 插件，并指定 `ModelableParameterType`

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
    
    mutating func mapping(_ json: JSON) {
       	
    }
}
```



如果键名需要自定义，则可以在方法 `mutating func mapping(_ json: JSON)` 中实现

```swift
struct CompanyModel: Modelable {
    
    var name : String = ""
    var catchPhrase : String = ""
    
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
    
    mutating func mapping(_ json: JSON) {
        
    }
}
```



##### 三、Response 解析



> 1、以下示例皆使用了 `MoyaMapperPlugin` ，所以不需要指定 `解析路径`
>
> 2、如果没有使用 `MoyaMapperPlugin` 则需要指定 `解析路径`，否则无法正常解析
>
> ps:  `解析路径` 可以使用 `a>b` 这种形式来解决多级路径的问题



解析方法如下列表所示

|      方法       | 描述 (支持RxSwift)                                           |
| :-------------: | :----------------------------------------------------------- |
|     toJSON      | Response 转 JSON ( [toJSON](https://moyamapper.github.io/core/toJSON/) \|  [rx.toJSON](https://moyamapper.github.io/rx/toJSON/)) |
|   fetchString   | 获取指定路径的字符串( [fetchString](https://moyamapper.github.io/core/fetchString/) \|  [rx.fetchString](https://moyamapper.github.io/rx/fetchString/)) |
| fetchJSONString | 获取指定路径的原始json字符串 ( [fetchJSONString](https://moyamapper.github.io/core/fetchJSONString/) \|  [rx.fetchJSONString](https://moyamapper.github.io/rx/fetchJSONString/) ) |
|    mapResult    | Response -> MoyaMapperResult   `(Bool, String)` ( [mapResult](https://moyamapper.github.io/core/mapResult/) \|  [rx.mapResult](https://moyamapper.github.io/rx/mapResult/) ) |
|    mapObject    | Response -> Model ( [mapObject](https://moyamapper.github.io/core/mapObject/) \|  [rx.mapObject](https://moyamapper.github.io/rx/mapObject/)) |
|  mapObjResult   | Response -> (MoyaMapperResult, Model) ( [mapObjResult](https://moyamapper.github.io/core/mapObjResult/) \|  [rx.mapObjResult](https://moyamapper.github.io/rx/mapObjResult/)) |
|    mapArray     | Response -> [Model]( [mapArray](https://moyamapper.github.io/core/mapArray/) \|  [rx.mapArray](https://moyamapper.github.io/rx/mapArray/)) |
| mapArrayResult  | Response -> (MoyaMapperResult, [Model]) ( [mapArrayResult](https://moyamapper.github.io/core/mapArrayResult/) \|  [rx.mapArrayResult](https://moyamapper.github.io/rx/mapArrayResult/)) |

❗除了 `fetchJSONString` 的默认解析路径是`根路径`之外，其它方法的默认解析路径为插件对象中的 `modelKey`



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



### 缓存

```
// 缓存
@discardableResult
MMCache.shared.cache`XXX`(value : XXX, key: String, cacheContainer: MMCache.CacheContainer = .RAM)  -> Bool
// 取舍
MMCache.shared.fetch`XXX`Cache(key: String, cacheContainer: MMCache.CacheContainer = .RAM)
```



缓存成功与否都会返回一个 `Bool` 值，但不会强制接收

| XXX 所支持类型 |             |
| -------------- | ----------- |
| Bool           | -           |
| Float          | -           |
| Double         | -           |
| String         | -           |
| JSON           | -           |
| Modelable      | [Modelable] |
| Moya.Response  | -           |
| Int            | UInt        |
| Int8           | UInt8       |
| Int16          | UInt16      |
| Int32          | UInt32      |
| Int64          | UInt64      |

> 其中，除了 `Moya.Response` 之外，其它类型皆是通过 `JSON` 来实现缓存



所以，如果你想清除这些类型的缓存，只需要调用如下方法即可

```swift
@discardableResult
func removeJSONCache(_ key: String, cacheContainer: MMCache.CacheContainer = .RAM) -> Bool

@discardableResult
func removeAllJSONCache(cacheContainer: MMCache.CacheContainer = .RAM) -> Bool
```



清除 `Moya.Response` 则使用如下两个方法

```swift
@discardableResult
func removeResponseCache(_ key: String) -> Bool

@discardableResult
func removeAllResponseCache() -> Bool
```



再来看看MMCache.CacheContainer

```swift
enum CacheContainer {
    case RAM 	// 只缓存于内存的容器
    case hybrid // 缓存于内存与磁盘的容器
}
```

> 这两种容器互不相通，即 即使 `key` 相同，使用 `hybrid` 来缓存后，再通过 `RAM` 取值是取不到的。

- RAM : 仅缓存于内存之中，缓存的数据在APP使用期间一直存在
- hybrid ：缓存于内存与磁盘中，APP重启后也可以获取到数据



##### 缓存网络请求

> 内部缓存过程：
>
> 1. APP首次启动并进行网络请求，网络数据将缓存起来
> 2. APP再次启动并进行网络请求时，会先加载缓存，再加载网络数据
> 3. 其它情况只会加载网络数据
> 4. 每次成功请求到数据都会进行数据更新



```swift
// Normal
func cacheRequest(
    _ target: Target, 
    cacheType: MMCache.CacheKeyType = .default, 
    callbackQueue: DispatchQueue? = nil, 
    progress: Moya.ProgressBlock? = nil, 
    completion: @escaping Moya.Completion
) -> Cancellable

// Rx
func cacheRequest(
    _ target: Base.Target, 
    callbackQueue: DispatchQueue? = nil, 
    cacheType: MMCache.CacheKeyType = .default
) -> Observable<Response>
```



>  可对 `Moya` 请求后的 `Response` 进行缓存。 其实与 `Moya` 自带的方法相比较只多了一个参数 `cacheType: MMCache.CacheKeyType` ，定义着缓存中的 `key` ，默认为 `default` 



下面是 `MMCache.CacheKeyType` 的定义

```
/**
 let cacheKey = [method]baseURL/path
 
 - default : cacheKey + "?" + parameters
 - base : cacheKey
 - custom : cacheKey + "?" + customKey
 */
public enum CacheKeyType {
    case `default`
    case base
    case custom(String)
}
```



> 如果你想缓存`多页`列表数据的`最新一页`的数据，则可以使用 `base` 或者 `custom(String)` 



```swift
/*
 * APP第一次启动并进行网络请求，网络数据将缓存起来
 * APP再次启动并进行网络请求时，会先加载缓存，再加载网络数据
 * 其它情况只会加载网络数据
 * 每次成功请求到数据都会进行数据更新
 */
lxfNetTool.rx.cacheRequest(.data(type: .all, size: 10, index: 1))
    .subscribe(onNext: { response in
        log.debug("statusCode -- \(response.statusCode)")
        log.debug(" ===== cache =====")
    }).disposed(by: disposeBag)

// 传统方式
/*
let _ = lxfNetTool.cacheRequest(.data(type: .all, size: 10, index: 1)) { result in
    guard let resp = result.value else { return }
    log.debug("statusCode -- \(resp.statusCode)")
}
*/
```



打印结果

```
// 第一次使用
statusCode -- 200

// 关闭并重新打开APP，再请求一下
statusCode -- 230
statusCode -- 200

// 然后再请求一下
statusCode -- 200
```



## Installation

| Swift | MoyaMapper | Moya     |
| ----- | ---------- | -------- |
| 5.X   | >=3.0.0    | >=14.0.0 |
| 5.X   | >=2.0.0    | >=11.0.0 |
| 4.x   | <=1.2.3    | >=11.0.0 |



### CocoaPods

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



### Carthage

在你的 `Cartfile` 文件中添加如下内容:

```
github "MoyaMapper/MoyaMapper"
```

接着运行  `carthage update --no-use-binaries --platform ios`.



## License

MoyaMapper is available under the MIT license. See the LICENSE file for more info.



## Author

- LinXunFeng
- email: [xunfenghellolo@gmail.com](mailto:xunfenghellolo@gmail.com)
- Blogs:  [LinXunFeng‘s Blog](http://linxunfeng.top/)  | [掘金](https://juejin.im/user/58f8065e61ff4b006646c72d/posts) | [简书](https://www.jianshu.com/u/31e85e7a22a2)



| <img src="https://github.com/LinXunFeng/site/raw/master/source/images/others/wx/wxQR_tip.png" style="width:200px;height:200px;"></img> | <img src="https://github.com/LinXunFeng/site/raw/master/source/images/others/pay/alipay_tip.png" style="width:200px;height:200px;"></img> | <img src="https://github.com/LinXunFeng/site/raw/master/source/images/others/pay/wechat_tip.png" style="width:200px;height:200px;"></img> |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
|                                                              |                                                              |                                                              |

