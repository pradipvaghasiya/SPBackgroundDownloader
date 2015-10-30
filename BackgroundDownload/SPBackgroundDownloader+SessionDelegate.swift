//
//  SPBackgroundDownloader+SessionDelegate.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

extension SPBackgroundDownloader : NSURLSessionDownloadDelegate{
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64){
        //print("didResumeAtOffset : \(fileOffset) ")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        //print("bytesWritten : \(bytesWritten) totalBytesWritten : \(totalBytesWritten) ")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL downloadURL: NSURL){
        if saveFile(downloadTask, downloadURL: downloadURL){
            if let urlString = downloadTask.originalRequest?.URL?.path{
                dispatch_async(dispatch_get_main_queue()){ [unowned self] in
                    self.delegate?.fileDownloadedWithURL?(urlString)
                }
            }
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?){
        
        guard let error = error else{
            sendRunningTasksStatus()
            return
        }

        pause()
        sendRunningTasksStatus()
        if let urlString = task.originalRequest?.URL?.path{
            dispatch_async(dispatch_get_main_queue()){[unowned self] in
                self.delegate?.errorOccured?(urlString, error: error)
            }
        }
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession){
//        print("All tasks completed")
        if var appDelegte = UIApplication.sharedApplication().delegate as? SPBackgroundDownloaderAppDelegate{
            guard let completionHandler = appDelegte.backgroundSessionCompletionHandler else{
                return
            }
            dispatch_async(dispatch_get_main_queue()){
                completionHandler()
            }
            
            appDelegte.backgroundSessionCompletionHandler = nil
        }
        
        sendRunningTasksStatus()
    }
}
