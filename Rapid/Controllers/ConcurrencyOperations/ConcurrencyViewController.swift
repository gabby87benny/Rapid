//
//  ConcurrencyViewController.swift
//  Rapid
//
//  Created by Joseph Peter, Gabriel Benny Francis on 4/20/20.
//  Copyright © 2020 Gabby. All rights reserved.
//

import UIKit

class ConcurrencyViewController: UIViewController {
    
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func syncronizedTaskInSerialQueue(_ sender: Any) {
        syncronizedTaskInSerialQueue()
    }
    
    @IBAction func syncronizedTaskInConcurrentQueue(_ sender: Any) {
        syncronizedTaskInConcurrentQueue()
    }
    
    @IBAction func asyncronizedTaskInSerialQueue(_ sender: Any) {
        asyncronizedTaskInSerialQueue()
    }
    
    @IBAction func asyncronizedTaskInConcurrentQueue(_ sender: Any) {
        asyncronizedTaskInConcurrentQueue()
    }
    
    @IBAction func dispatchGroupTask(_ sender: Any) {
        dispatchGroupTask()
    }
    
    @IBAction func syncronizedDispatchBarrierWithSerialQueue(_ sender: Any) {
        syncronizedDispatchBarrierWithSerialQueue()
    }
    
    @IBAction func syncronizedDispatchBarrierWithConcurrentQueue(_ sender: Any) {
        syncronizedDispatchBarrierWithConcurrentQueue()
    }
    
    @IBAction func asyncronizedDispatchBarrierWithSerialQueue(_ sender: Any) {
        asyncronizedDispatchBarrierWithSerialQueue()
    }
    
    @IBAction func asyncronizedDispatchBarrierWithConcurrentQueue(_ sender: Any) {
        asyncronizedDispatchBarrierWithConcurrentQueue()
    }
    
    @IBAction func defaultInocationOperation(_ sender: Any) {
        defaultInocationOperation()
    }
    
    @IBAction func defaultBlockOperation(_ sender: Any) {
        defaultBlockOperation()
    }
    
    @IBAction func blockOperationInOtherQueue(_ sender: Any) {
        blockOperationInOtherQueue()
    }
    
    @IBAction func moreThanOneBlockOperationInOtherQueue(_ sender: Any) {
        moreThanOneBlockOperationInOtherQueue()
    }
    
    @IBAction func addDependencesBlockOperationsInOtherQueue(_ sender: Any) {
        addDependencesBlockOperationsInOtherQueue()
    }
    
    @IBAction func dispatchSemaphore(_ sender: Any) {
        dispatchSemaphore()
    }
    
    @IBAction func blockMainQ(_ sender: Any) {
        blockMainQ()
    }
    
    @IBAction func blockSelfCreatedSerialQ(_ sender: Any) {
        blockSelfCreatedSerialQ()
    }
    
    //MARK: Helper
    func calculateShortTime() -> Int {
        var result = 0
        for i in 1...100 {
            result += i
        }
        return result
    }
    
    func calculateLongTime() -> Int {
        var result = 0
        for i in 1...1000000 {
            result += i
        }
        return result
    }
    
    func syncronizedTaskInSerialQueue() {
        let serialQ = DispatchQueue(label: "syncronizedTaskInSerialQueue")
        serialQ.sync {
            let delayTimeLong = calculateLongTime()
            print("Serial sync time long: \(delayTimeLong) on thread: \(Thread.current)")
        }
        
        serialQ.sync {
            let delayTimeShort = calculateShortTime()
            print("Serial sync time short: \(delayTimeShort) on thread: \(Thread.current)")
        }
    }
    
    func syncronizedTaskInConcurrentQueue() {
        let concurrentQ = DispatchQueue(label: "syncronizedTaskInConcurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrentQ.sync {
            let delayTimeLong = calculateLongTime()
            print("Concurrent sync time long: \(delayTimeLong) on thread: \(Thread.current)")
        }
        concurrentQ.sync {
            let delayTimeShort = calculateShortTime()
            print("Concurrent sync time short: \(delayTimeShort) on thread: \(Thread.current)")
        }
    }
    
    func asyncronizedTaskInSerialQueue() {
        let serialQ = DispatchQueue(label: "AsyncronizedTaskInSerialQueue")
        serialQ.async {
            let delayTimeLong = self.calculateLongTime()
            print("Serial Async time long: \(delayTimeLong) on thread: \(Thread.current)")
        }
        serialQ.async {
            let delayTimeShort = self.calculateShortTime()
            print("Serial Async time short: \(delayTimeShort) on thread: \(Thread.current)")
        }
    }
    
    func asyncronizedTaskInConcurrentQueue() {
        let concurrentQ = DispatchQueue(label: "", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        concurrentQ.async {
            let delayTimeLong = self.calculateLongTime()
            print("Concurrent Async time long: \(delayTimeLong) on thread: \(Thread.current)")
        }
        concurrentQ.async {
            let delayTimeShort = self.calculateShortTime()
            print("Concurrent Async time short: \(delayTimeShort) on thread: \(Thread.current)")
        }
    }
    
    func dispatchGroupTask() {
        //WAY 1
        let dGroup = DispatchGroup()
        
        dGroup.enter()
        let delayTimeLong = calculateLongTime()
        print("Concurrent sync time long: \(delayTimeLong) on thread: \(Thread.current)")
        dGroup.leave()
        
        dGroup.enter()
        let delayTimeShort = self.calculateShortTime()
        print("Concurrent Async time short: \(delayTimeShort) on thread: \(Thread.current)")
        dGroup.leave()
        
        //1.1 - if we want the task to get completed to cross this line
        //dGroup.wait()
        
        //1.2 - if we want just to move on and task to be notified later after completion
        dGroup.notify(queue: .main) {
            print("Both functions complete 👍")
        }
        
        //WAY 2
//        let disQueue = DispatchQueue(label: "com.company.app.queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
//        let disGroup = DispatchGroup()
//
//        disQueue.async(group: disGroup, qos: .default, flags: .noQoS) {
//            let delayTimeLong = self.calculateLongTime()
//            print("Concurrent sync time long: \(delayTimeLong) on thread: \(Thread.current)")
//        }
//
//        disQueue.async(group: disGroup, qos: .default, flags: .noQoS) {
//            let delayTimeShort = self.calculateShortTime()
//            print("Concurrent Async time short: \(delayTimeShort) on thread: \(Thread.current)")
//        }
//        //2.1
//        disGroup.notify(queue: disQueue) {
//            print("#3 finished")
//        }
//        //2.2
//        //disGroup.wait()
    }
    
    
// Helper method
    func doSomeAsyncronizedTaskInQueue(queue: DispatchQueue) {
        queue.async {
            for _ in 0..<3 {
                print("group - 01 - \(Thread.current)")
            }
        }
        queue.async {
            for _ in 0..<8 {
                print("group - 02 - \(Thread.current)")
            }
        }
        queue.async {
            for _ in 0..<5 {
                print("group - 03 - \(Thread.current)")
            }
        }
    }
    
    //Dispatch barriers are a group of functions acting as a serial-style bottleneck when working with concurrent queues

    func syncronizedDispatchBarrierWithSerialQueue() {
        let serialQ = DispatchQueue(label: "syncronizedDispatchBarrierWithSerialQueue")
        doSomeAsyncronizedTaskInQueue(queue: serialQ)
        serialQ.sync(flags: .barrier) {
            let delayTimeLong = calculateLongTime()
            print("\(Thread.current) syncro - barrier - serial - \(delayTimeLong)")
        }
        doSomeAsyncronizedTaskInQueue(queue: serialQ)
    }
    
    func syncronizedDispatchBarrierWithConcurrentQueue() {
        let concurrentQ = DispatchQueue(label: "syncronizedDispatchBarrierWithConcurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        doSomeAsyncronizedTaskInQueue(queue: concurrentQ)
        concurrentQ.sync(flags: .barrier) {
            let delayTimeLong = calculateLongTime()
            print("\(Thread.current) syncro - barrier - Concurrent - \(delayTimeLong)")
        }
        doSomeAsyncronizedTaskInQueue(queue: concurrentQ)
    }
    
    func asyncronizedDispatchBarrierWithSerialQueue() {
        let serialQ = DispatchQueue(label: "AsyncronizedDispatchBarrierWithSerialQueue")
        doSomeAsyncronizedTaskInQueue(queue: serialQ)
        serialQ.async(flags: .barrier) {
            let delayTimeLong = self.calculateLongTime()
            print("\(Thread.current) Asyncro - barrier - serial - \(delayTimeLong)")
        }
        doSomeAsyncronizedTaskInQueue(queue: serialQ)
    }
    
    func asyncronizedDispatchBarrierWithConcurrentQueue() {
        let concurrentQ = DispatchQueue(label: "AsyncronizedDispatchBarrierWithConcurrentQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        doSomeAsyncronizedTaskInQueue(queue: concurrentQ)
        concurrentQ.async(flags: .barrier) {
            let delayTimeLong = self.calculateLongTime()
            print("\(Thread.current) Asyncro - barrier - Concurrent - \(delayTimeLong)")
        }
        doSomeAsyncronizedTaskInQueue(queue: concurrentQ)
    }
    
    // Helper method
    func delayUsingDispatchAfter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            print("delayUsingDispatchAfter")
        }

    }
    
    func loopingUsingDispatchApply() {
        //run blocks parallelly and wait till all blocks to complete
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            print("loopingUsingDispatchApply: \(index)")
        }
    }
    
    func cancelGCDBlocks() {
        let workItem = DispatchWorkItem {
            print("created work item")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: workItem)
        workItem.cancel()
    }
    
    func suspendDispatchTasks() {
        let serialQ = DispatchQueue(label: "suspendDispatchTasks")
        serialQ.suspend()
        serialQ.resume()
    }
    
    func operationContent()
    {
        print("operation content in thread - \(Thread.current)")
    }
    
    func defaultInocationOperation() {
        print("No NSInvocation or NSInovatonOperation in swift. instead use block operation")
    }
    
    func defaultBlockOperation() {
        let blockOperation = BlockOperation {
            self.operationContent()
        }
        
        for i in 0..<3 {
            blockOperation.addExecutionBlock {
                Thread.sleep(forTimeInterval: 1.0)
                print("execution block - \(i) - \(Thread.current)")
            }
        }
        blockOperation.start()
        print("end thread 2 - \(Thread.current)")
    }
    
    func blockOperationInSelfCreatedQueue() {
        let opQ = OperationQueue()
        let blockOperation = BlockOperation {
            self.operationContent()
        }
        
        for i in 0..<3 {
            blockOperation.addExecutionBlock {
                Thread.sleep(forTimeInterval: 1.0)
                print("execution block - \(i) - \(Thread.current)")
            }
        }
        opQ.addOperation(blockOperation)
        print("end thread 3 - \(Thread.current)");
    }
    
    func blockOperationInOtherQueue() {
        let opQ = OperationQueue()
        opQ.maxConcurrentOperationCount = 1
        let blockOperation = BlockOperation {
            self.operationContent()
        }
        
        for i in 0..<3 {
            opQ.addOperation {
                Thread.sleep(forTimeInterval: 1.0)
                print("operation block - \(i) - \(Thread.current)")
            }
        }
        opQ.addOperation(blockOperation)
        print("end thread 4 - \(Thread.current)");
    }
    
    func moreThanOneBlockOperationInOtherQueue() {
        let opQ = OperationQueue()
        opQ.maxConcurrentOperationCount = 1
        let blockOperation1 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 1 - \(Thread.current)")
        }
        
        let blockOperation2 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 2 - \(Thread.current)")
        }
        
        let blockOperation3 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 3 - \(Thread.current)")
        }
        
        let blockOperation4 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 4 - \(Thread.current)")
        }

        opQ.addOperations([blockOperation1, blockOperation2, blockOperation3, blockOperation4], waitUntilFinished: true)
        print("end thread 5 - \(Thread.current)");
    }
    
    func addDependencesBlockOperationsInOtherQueue() {
        let opQ = OperationQueue()
        opQ.maxConcurrentOperationCount = 1
        let blockOperation1 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 1 - \(Thread.current)")
        }
        
        let blockOperation2 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 2 - \(Thread.current)")
        }
        
        let blockOperation3 = BlockOperation {
            Thread.sleep(forTimeInterval: 1.0)
            print("operation 3 - \(Thread.current)")
        }

        blockOperation2.addDependency(blockOperation1)
        blockOperation3.addDependency(blockOperation2)
        opQ.addOperations([blockOperation1, blockOperation2, blockOperation3], waitUntilFinished: false)
        print("end thread 5 - \(Thread.current)")
    }
    
    func dispatchSemaphore() {
        let semaphore = DispatchSemaphore(value: 1)
        DispatchQueue.global().async {
           print("Kid 1 - wait")
           semaphore.wait()
           print("Kid 1 - wait finished")
           sleep(1) // Kid 1 playing with iPad
           semaphore.signal()
           print("Kid 1 - done with iPad")
        }
        DispatchQueue.global().async {
           print("Kid 2 - wait")
           semaphore.wait()
           print("Kid 2 - wait finished")
           sleep(1) // Kid 1 playing with iPad
           semaphore.signal()
           print("Kid 2 - done with iPad")
        }
        DispatchQueue.global().async {
           print("Kid 3 - wait")
           semaphore.wait()
           print("Kid 3 - wait finished")
           sleep(1) // Kid 1 playing with iPad
           semaphore.signal()
           print("Kid 3 - done with iPad")
        }
        
        /*
         let queue = DispatchQueue(label: "com.gcd.myQueue", attributes: .concurrent)
         let semaphore = DispatchSemaphore(value: 3)
         for i in 0 ..> 15 {
            queue.async {
               let songNumber = i + 1
               semaphore.wait()
               print("Downloading song", songNumber)
               sleep(2) // Download take ~2 sec each
               print("Downloaded song", songNumber)
               semaphore.signal()
            }
         }
         */
    }
    
    //Below all methods will create Deadlock
    /*
    crashes.. REASON:
     dispatch_sync does two things:
     queue a block
     blocks the current thread until the block has finished running
     Given that the main thread is a serial queue (which means it uses only one thread), the following statement:
     dispatch_sync(dispatch_get_main_queue(), ^(){...});
     will cause the following events:
     dispatch_sync queues the block in the main queue.
     dispatch_sync blocks the thread of the main queue until the block finishes executing.
     dispatch_sync waits forever because the thread where the block is supposed to run is blocked.
     
     */
    func blockMainQ() {
        print("b4 sync thread now - \(Thread.current)")
        DispatchQueue.main.sync {
            print("inside sync thread  - \(Thread.current)")
        }
        print("after sync thread  - \(Thread.current)")
    }
    
    func blockSelfCreatedSerialQ() {
        let serialQ = DispatchQueue(label: "serialQueue")
        serialQ.async {
            print("b4 sync thread now - \(Thread.current)")
            serialQ.sync {
                print("inside sync thread  - \(Thread.current)")
            }
            print("after sync thread  - \(Thread.current)")
        }
        print("thread  - \(Thread.current)")
    }
    
    func deadLockCase3() {
        print("1")
        let globalQ = DispatchQueue.global(qos: .userInitiated)
        globalQ.async {
            print("2")
        }
        print("3")
    }
    
    func deadLockCase4() {
        print("1")
        let globalQ = DispatchQueue.global(qos: .userInitiated)
        globalQ.async {
            print("2")
            DispatchQueue.main.sync {
                print("3")
            }
            print("4")
        }
        print("5")
    }
    
    //Dispatch source
    
    func dispatchSourceTimerDemo() {
        let queue = DispatchQueue(label: "com.firm.app.timer",
                                  attributes: DispatchQueue.Attributes.concurrent)
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)),
                                                   queue: queue)

        timer.schedule(deadline: .now(),
                       repeating: .seconds(5),
                       leeway: .seconds(1)
        )
        timer.setEventHandler {[weak self] in
            print("event fired")
        }
        timer.resume()
    }
    
    func runBackgroundTask()
    {
        self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            if let identifier = self.backgroundTaskIdentifier
            {
                UIApplication.shared.endBackgroundTask(identifier)
            }
        })
    }

    func endBackgroundTask()
    {
        if let identifier = self.backgroundTaskIdentifier
        {
            UIApplication.shared.endBackgroundTask(identifier)
        }
    }
    
}
