#Swift 2.0 新特性
`var a = "SDsadad";for string in a.characters{} `
##1.错误处理
throws  throw 
do try catch 
ErrorType协议 

```Swift
enum error：ErrorType{
	case 没空
	case 器材损坏
	case 低体力
}
let 剩余时间 ＝ 30.0
let 器械良好 = true
let 体力 ＝ 0.0

// 有先后顺序
func  检查健身实施情况() throws{
	guard 剩余时间 > 0.0 else{
		throw error.没空
	}
	guard 器械良好 else {
		throw error.器材损坏
	}
	guard 低体力 > 0.0 else{
		throw error.低体力
	}
}
func begin(){
	do{
		try 检查健身实施情况(){
			print("健身开始")
		}catch error.没空｛
			print("")
		｝catch error.器材损坏｛
			print("")
		｝catch error.低体力｛
			print("")
		｝catch{
			print("其它原因")
		}
	}
}
```

##2.协议扩展  类间接扩展
```Swift
	protocol Velocity{
		func accelerationTimePer100KM() -> Double
	}

	struct Carola:Velocity{
		var price:Int
		func accelerationTimePer100KM() -> Double{
			return 3.0
		}
	}
	struct Psyche:Velocity{
		var price:Int
		func accelerationTimePer100KM() -> Double{
			return 2.5
		}
	}

	let Carola1 = Carola(price:100000)
	Carola1.accelerationTimePer100KM()

	let Psyche1 = Psyche(price:100000)
	Psyche1.accelerationTimePer100KM()

	extension Velocity{
		var rank:Int{
			get{
				return Int(ccelerationTimePer100KM() * 10)
			}
		}
	}

	//自动获得  rank
	Carola1.rank
	Psyche1.rank

```

##3.有效性检查(API兼容性)
```Swift
	
	if #available(iOS8,*){
		let queryItem = NSURLQueryItem()
	}else{
		// iOS旧版本
	}
```

##4. do while 循环重命名为repeat while 循环
```Swift
	
	var i = 1
	repeat{
		i++
		print(i)
	}while i <= 10

```
## OptionSet:
```Swift
import Foundation

struct Inputs:OptionSetType     {
    let rawValue:Int
    static let user = Inputs(rawValue: 1 << 0)
    static let pass = Inputs(rawValue: 1 << 1)
    static let mail = Inputs(rawValue: 1 << 2)
    
    
}

// judge whether input all
extension Inputs{
    func isAllOK() -> Bool{
//        return self == [.user, .pass, .mail]
//        return self.rawValue == 0b111
        let count = 3
        // serach items
        var found = 0
        
        for time in 0..<count{
            if self.contains(Inputs(rawValue:1 << time)){
                found++
            }
        }
        // 是否全部找到
        return found == count
        
    }
}

let possibleInputs:Inputs = [.user, .pass, .mail]
possibleInputs.isAllOK()
```
将if条件语句提前，并且将if改为where `for time in 0..<count where contains(Inputs(rawValue:1 << time)){//code}`