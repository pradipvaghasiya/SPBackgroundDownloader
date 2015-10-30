//
//  SPBackgroundDownloader+Delegate.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit


extension SPBackgroundDownloader{
    func backgroundSession() -> NSURLSession?{
        dispatch_once(&Static.token){ [unowned self] in
            let configuration : NSURLSessionConfiguration
            
            if #available(iOS 8.0, *) {
                configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(kSPBackgroundDownloaderSessionIdentifier)
            } else {
                configuration = NSURLSessionConfiguration.backgroundSessionConfiguration(kSPBackgroundDownloaderSessionIdentifier)
            }
            
            Static.session = NSURLSession(configuration:configuration, delegate: self, delegateQueue: self.getConcurrentQueue())
        }
        
        return Static.session
        
    }
    
    func getConcurrentQueue() -> NSOperationQueue{
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        
        return queue
    }
    
    func getAllSessionTasks(result: GetTasksResult){
        if #available(iOS 9.0, *) {
            session?.getAllTasksWithCompletionHandler(result)
        } else {
            session?.getTasksWithCompletionHandler{dataTasks, uploadTasks, downloadTasks in
                result(downloadTasks)
            }
        }
    }
    
}