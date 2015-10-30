//
//  ViewController.swift
//  BackgroundDownload
//
//  Created by Pradip V on 10/30/15.
//  Copyright © 2015 Speedui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        SPBackgroundDownloader.downloader.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension ViewController{
    private func setupDownloads(){
        self.statusLabel.text = "Starting download.."
        self.detailLabel.text = ""

        let item1 = "http://flashair/DCIM/IMG_5153.jpg"
        let item2 = "http://flashair/DCIM/IMG_5154.jpg"
        let item3 = "http://flashair/DCIM/IMG_5155.jpg"
        let item4 = "http://flashair/DCIM/IMG_5159.jpg"
        let item5 = "http://flashair/DCIM/IMG_5157.jpg"
        let item6 = "http://flashair/DCIM/IMG_5158.jpg"
        
        SPBackgroundDownloader.downloader.urlStrings = [item1,item2,item3,item4,item5,item6]
        
        SPBackgroundDownloader.downloader.session?.configuration.HTTPMaximumConnectionsPerHost = 1
        SPBackgroundDownloader.downloader.session?.configuration.timeoutIntervalForRequest = 5
        SPBackgroundDownloader.downloader.session?.configuration.timeoutIntervalForResource = 5
            
        SPBackgroundDownloader.downloader.startDownload()
    }
    

    @IBAction func start(sender: AnyObject) {
        setupDownloads()
    }
    
    @IBAction func crash(sender: AnyObject) {
        let array : [Int] = []
        print(array[0])
    }
    
    @IBAction func cancel(sender: AnyObject) {
        SPBackgroundDownloader.downloader.cancel()
    }
    
    @IBAction func resume(sender: AnyObject) {
        SPBackgroundDownloader.downloader.resume()
    }
    
    @IBAction func pause(sender: AnyObject) {
        SPBackgroundDownloader.downloader.pause()
    }
    
    @IBAction func deleteAllFIles(sender: AnyObject) {
        SPBackgroundDownloader.downloader.deleteDownloadedFiles()
    }
}

extension ViewController : SPBackgroundDownloaderDelegate{
    func noRunningTasks() {
        self.statusLabel.text = "Nothing being downloaded or stuck."
    }

    func fileDownloadedWithURL(url: String) {
        self.detailLabel.text = "\(self.detailLabel.text!)\n\((NSURL(string: url)!.lastPathComponent)!) downloaded."
        self.detailLabel.sizeToFit()
    }
    
    func errorOccured(url: String, error: NSError) {
        print(error)
        self.detailLabel.text = "\(self.detailLabel.text!)\n\((NSURL(string: url)!.lastPathComponent)!) can't be downloaded."
    }
}


