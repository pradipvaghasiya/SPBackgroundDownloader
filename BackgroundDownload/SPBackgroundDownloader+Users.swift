//
//  SPBackgroundDownloader+Users.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

protocol SPBackgroundDownloaderAppDelegate{
    var backgroundSessionCompletionHandler : BackgroundSessionCompletionHandler? {get set}
}

@objc protocol SPBackgroundDownloaderDelegate : class{
    optional func fileDownloadedWithURL(url : String)
    optional func errorOccured(url : String, error: NSError)
    optional func noRunningTasks()
}

extension SPBackgroundDownloader{
    func startDownload(){
        guard urlStrings.count > 0 else{
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){ [unowned self] in
            
            for urlString in self.urlStrings{
                if let url = NSURL(string: urlString){
                    guard !self.fileExistsAtWebURL(url) else{
                        dispatch_async(dispatch_get_main_queue()){ [unowned self] in 
                            self.delegate?.fileDownloadedWithURL?(urlString)
                        }
                        continue
                    }
                    
                    let request = NSURLRequest(URL: url)
                    let downloadTask = self.session?.downloadTaskWithRequest(request)
//                    print("\(downloadTask?.taskIdentifier) created.")
                    downloadTask?.resume()
                }
            }
            self.sendRunningTasksStatus()
        }
    }
    
    func cancel(){
        getAllSessionTasks{ tasks in
            for task in tasks{
                task.cancel()
            }
        }
    }
    
    func pause(){
        getAllSessionTasks{ tasks in
            for task in tasks{
                if task.state == .Running{
                    task.suspend()
                }
            }
        }
    }
    
    func resume(){
        getAllSessionTasks{ tasks in
            for task in tasks{
                if task.state == .Suspended{
                    task.resume()
                }
            }
        }
    }
    
    func deleteDownloadedFiles(){
        deleteRootFolder()
    }
}