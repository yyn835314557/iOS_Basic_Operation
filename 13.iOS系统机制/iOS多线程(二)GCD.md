# iOS 多线程（二）GCD

##GCD

>  概念
 - Grand Central Dispatch: "伟大的中枢调度器"
 - GCDGCD是苹果公司为多核的并行运算提出的解决方案
 - 纯C语言，提供了非常多强大的函数

#### 优势
1. GCD会自动利用更多的CPU内核(如何双核、四核)
2. GCD会自动管理线程的生命周期(创建线程、调度任务、销毁线程)
3. 只需要告诉GCD想要执行什么任务，不需要编写任何线程管理代码

##基本概念

**任务和队列**

 1. 任务: 执行什么操作
 2. 队列(queue): 用来存放任务
	
####任务

- 执行任务
- 同步的方式执行任务
	 - `dispatch_sync(dispatch_get_global_queue(QOS_CLASS_INITIATED,0){//code})`
- 异步的方式执行任务
	 - `dispatch_async(dispatch_get_global_queue(QOS_CLASS_INITIATED,0){ // 比较耗时的操作 })`
- 用来执行任务的函数，前面的任务执行结束后才执行，它后面的任务等它执行完成之后才会执行
	 - `dispatch_barrier_async(concurrentPhotoQueue) { // 1}`

**注意** 
 - 同步:
 	 只能在当前线程中执行任务，不具备开启新线程的能力
 - 异步: 
 	 可以在新的线程中执行任务，具备开启新线程的能力

>	QOS: quality of service
 * QOS_CLASS_USER_INTERACTIVE 0x21,              用户交互(希望尽快完成，用户对结果很期望，不要放太耗时操作)
 * QOS_CLASS_USER_INITIATED 0x19,                用户期望(不要放太耗时操作)
 * QOS_CLASS_DEFAULT 0x15,                        默认(不是给程序员使用的，用来重置对列使用的)
 * QOS_CLASS_UTILITY 0x11,                        实用工具(耗时操作，可以使用这个选项)
 * QOS_CLASS_BACKGROUND 0x09,                     后台
 * QOS_CLASS_UNSPECIFIED 0x00,                    未指定

 	int64_t delta 单位为纳秒
 * var NSEC_PER_SEC: UInt64 { get }   			每秒有多少纳秒(10^9)
 * var NSEC_PER_MSEC: UInt64 { get }			每毫秒有多少纳秒(10^6)
 * var USEC_PER_SEC: UInt64 { get }				每秒有多少微秒(10^6)
 * var NSEC_PER_USEC: UInt64 { get }			每微秒有多少纳秒(10^3)


####队列
- 并发队列（Concurrent Dispatch Queue）
`func dispatch_queue_create(label: UnsafePointer<Int8>, attr: dispatch_queue_attr_t!) -> dispatch_queue_t!`
	 - 可以让多个任务并发（同时）执行（自动开启多个线程同时执行任务）
	 - 并发功能只有在异步（dispatch_async）函数下才有效

	 >  dispatch_async() 



- 串行队列（Serial Dispatch Queue）
 	 - 让任务一个接着一个地执行（一个任务执行完毕后，再执行下一个任务）
- 各种队列的执行效果

> 
Compare:
 1.同步和异步主要影响：能不能开启新的线程
	 - 同步：只是在当前线程中执行任务，不具备开启新线程的能力
	 - 异步：可以在新的线程中执行任务，具备开启新线程的能力
 2.并发和串行主要影响：任务的执行方式
	 - 并发：多个任务并发（同时）执行
	 - 串行：一个任务执行完毕后，再执行下一个任务


###GCD运用
 - 线程间通信：

 - 延时执行
 	 `dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
     // 2秒后异步执行这里的代码...
 	 });`
 - 一次性代码
	 `// 使用dispatch_once函数能保证某段代码在程序运行过程中只被执行1次
	 static dispatch_once_t onceToken;
	 dispatch_once(&onceToken, ^{
	    // 只执行1次的代码(这里面默认是线程安全的)
	 });`
 - 快速迭代
	 ` // 使用dispatch_apply函数能进行快速迭代遍历
 	 dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t index){
     // 执行10次代码，index顺序不确定
	 });`
 - 队列组
	 ```// 分别异步执行2个耗时的操作、2个异步操作都执行完毕后，再回到主线程执行操作
	 dispatch_group_t group =  dispatch_group_create();
	 dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	    // 执行1个耗时的异步操作
	 });
	 dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	    // 执行1个耗时的异步操作
	 });
	 dispatch_group_notify(group, dispatch_get_main_queue(), ^{
	    // 等前面的异步操作都执行完毕后，回到主线程...
	 });
	```

###单例模式

> 
 - 可以保证在程序运行过程，一个类只有一个实例，而且该实例易于供外界访问。从而方便地控制了实例个数，并节约系统资源;
 - 在整个应用程序中，共享一份资源（这份资源只需要创建初始化1次）

- 实现过程
	 - 重写实现：
	 - 宏实现: 

	
###源码
```
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY,0),{
	// 花费大量时间的代码
	for var i = 0;i<100000;i++ {
		print("异步执行，这里要花费大量的时间，GCD")
	}
	dispathch_async(dispatch_get_main_queue(),{
		// 需要主线程的执行代码
		print("这里返回主线程，写需要主线程执行的代码"")
	})
})
```
	
> GCD中并发队列只有global的三个是并发处理栈内任务。自己创建的和main属性的都是串发的，栈与栈之前是并发的;GCD是通过BSD级别，在多核环境中对多线程并发的替代方案，不能单纯的用线程去做比较


***

下一篇:

[多线程(三)NSOperation](/13.iOS系统机制/iOS多线程(三)NSOperation.md)
	