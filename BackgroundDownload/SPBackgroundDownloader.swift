//
//  SPBackgroundDownloader.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

let kSPBackgroundDownloaderSessionIdentifier = "com.speedui.SPBackgroundDownloader.Backgroundsessionidentifier"

struct ItemToDownloadInBackground{
    var url : String
    var fileToSaveURL : String   // If there is already a file at this URL with same name downloader wont download it again.
    var item : Any?
    var taskIdentifier : Int?
    
    init (urlString: String, fileToSaveURLString: String){
        url = urlString
        fileToSaveURL = fileToSaveURLString
    }
}

typealias BackgroundSessionCompletionHandler = () -> Void

protocol SPBackgroundDownloaderAppDelegate{
    var backgroundSessionCompletionHandler : BackgroundSessionCompletionHandler? {get set}
}

protocol SPBackgroundDownloaderDelegate : class{
    func allDownloadCompleted()
}

class SPBackgroundDownloader : NSObject{
    
    static let downloader = SPBackgroundDownloader()
    var session : NSURLSession?
    
    var items : [ItemToDownloadInBackground]?
    weak var delegate : SPBackgroundDownloaderDelegate?
    
    struct Static{
        static var session : NSURLSession?
        static var token: dispatch_once_t = 0
    }

    override init() {
        super.init()
        session = backgroundSession()
    }
    
    private func backgroundSession() -> NSURLSession?{
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
    
    private func getConcurrentQueue() -> NSOperationQueue{
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount
        
        return queue
    }
    
    func startDownload(){
        guard let items = items where items.count > 0 else{
            return
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){ [unowned self] in
            
            for item in items{
                if let url = NSURL(string: item.url){
                    guard !self.fileExistsAtWebURL(url) else{
                        continue
                    }
                    
                    let request = NSURLRequest(URL: url)
                    let downloadTask = self.session?.downloadTaskWithRequest(request)
                    print("\(downloadTask?.taskIdentifier) created.")
                    downloadTask?.resume()
                }
            }
            self.sendCompletionMessageIfAllDownloaded()
        }
    }
    
    func reset(){
        if #available(iOS 9.0, *) {
            session?.getAllTasksWithCompletionHandler{ tasks in
                for task in tasks{
                    task.cancel()
                }
            }
        } else {
            session?.getTasksWithCompletionHandler{dataTasks, uploadTasks, downloadTasks in
                for task in downloadTasks{
                    task.cancel()
                }
            }
        }
    }
    
    private func fileExistsAtWebURL(url : NSURL) -> Bool{
        guard let path = documentsURLFromWebURL(url)?.path else{
            return false
        }
        
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }
    
    private func documentsURLFromWebURL(url : NSURL) -> NSURL?{
        guard let webURLPath = url.urlIncludingHost()?.path else{
            return nil
        }
        
        guard let toURL = NSFileManager.defaultManager().documentsDirectory()?.URLByAppendingPathComponent(webURLPath) else{
            return nil
        }
        
        return toURL
    }
    
    private func sendCompletionMessageIfAllDownloaded(){
        if #available(iOS 9.0, *) {
            session?.getAllTasksWithCompletionHandler{ tasks in
                if tasks.count <= 1{
                    dispatch_async(dispatch_get_main_queue()){
                        self.delegate?.allDownloadCompleted()
                    }
                }
            }
        } else {
            session?.getTasksWithCompletionHandler{dataTasks, uploadTasks, downloadTasks in
                let pendingTasks = dataTasks.count + uploadTasks.count + downloadTasks.count
                if pendingTasks <= 1{
                    dispatch_async(dispatch_get_main_queue()){
                        self.delegate?.allDownloadCompleted()
                    }
                }
            }
        }
    }
    
}

extension SPBackgroundDownloader : NSURLSessionDownloadDelegate{
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        //print("didResumeAtOffset : \(fileOffset) ")
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        //print("bytesWritten : \(bytesWritten) totalBytesWritten : \(totalBytesWritten) ")
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL downloadURL: NSURL){
        do{
            guard let originalHTTPURL = downloadTask.originalRequest?.URL else{
                return
            }
            
            guard let toURL = documentsURLFromWebURL(originalHTTPURL) else{
                return
            }
                        
            try NSFileManager.defaultManager().copyItemAtURL(downloadURL, toURL: toURL, override: false)
        }catch{
            print("Error while saving file \(downloadTask.taskIdentifier)")
        }
    }

    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        print("\(task.taskIdentifier): Task completed \(task.taskIdentifier) with error: \(error)")
        sendCompletionMessageIfAllDownloaded()
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession){
        print("All tasks completed")        
        if var appDelegte = UIApplication.sharedApplication().delegate as? SPBackgroundDownloaderAppDelegate{
            guard let completionHandler = appDelegte.backgroundSessionCompletionHandler else{
                return
            }

            dispatch_async(dispatch_get_main_queue()){
                completionHandler()
            }
            
            appDelegte.backgroundSessionCompletionHandler = nil
        }
        
        sendCompletionMessageIfAllDownloaded()
    }
}


