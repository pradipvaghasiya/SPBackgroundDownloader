//
//  SPBackgroundDownloader+Delegate.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

extension SPBackgroundDownloader{
    func sendRunningTasksStatus(){
        getAllSessionTasks{ tasks in
            let runningTasksCount = tasks.filter{
                if $0.state == .Running{
                    return true
                }
                return false
                }.count
            
            if runningTasksCount == 0{
                dispatch_async(dispatch_get_main_queue()){ [unowned self] in 
                    self.delegate?.noRunningTasks?()
                }
            }
        }
    }
}