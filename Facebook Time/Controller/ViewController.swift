//
//  ViewController.swift
//  Facebook Time
//
//  Created by Muhammad Riaz on 02/09/2016.
//  Copyright © 2016 APPWORLD. All rights reserved.
//

import UIKit
import AVFoundation
import WebKit

class ViewController: UIViewController, UIScrollViewDelegate, WKUIDelegate {

    //Outlets
//    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var statusBarDistance: NSLayoutConstraint!
    @IBOutlet var containerView : UIView!
    @IBOutlet weak var stopAndReloadButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var bottomPanel: UIView! //navigationBar
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var statusBarView: UIView!
    //Time out view.
    @IBOutlet weak var timeOutView: UIView!
    @IBOutlet weak var timeOutMessageView: UIView!
    //For picker view.
    @IBOutlet weak var customPickerView: UIPickerView!
    @IBOutlet weak var pickerConainerView: UIView!
    
    //Variables
    var siteWebView: WKWebView?
    var mainUrl: String = "http://facebook.com"
    var loadingFinished: Bool = false
    var audioPlayer = AVAudioPlayer()
    var navBarVisibility: Bool = false
    var clockTimer = Timer()
    let screenSize: CGRect = UIScreen.main.bounds
    var deviceOrientation: String = "Portrait" //Landscape
    var lastScrollContentOffset: CGFloat = 0.0
    
    override func loadView() {
        super.loadView()
        
        siteWebView = WKWebView(frame: containerView.bounds, configuration: WKWebViewConfiguration())
        siteWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(siteWebView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //For google mobile ads
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" //Test
//        bannerView.adUnitID = "ca-app-pub-9005498559306659/3557447129"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        //Web browser settings
        siteWebView!.scrollView.isScrollEnabled = true
        siteWebView!.isUserInteractionEnabled = true
        //siteWebView!.navigationDelegate = self //This is to track load progress.
        siteWebView!.uiDelegate = self
        //To use scrollview methods and detecting scrollview scrolling.
        siteWebView!.scrollView.delegate = self
        siteWebView!.scrollView.bounces = false
        
        //Adding tap gesture to statusBarView.
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.setPageTop))
        tapGestureRecognizer.numberOfTapsRequired = 1
        statusBarView.addGestureRecognizer(tapGestureRecognizer)
        statusBarView.isUserInteractionEnabled = true
        
        //Check Device
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                //                    print("iPhone 5 or 5S or 5C")
                statusBarDistance.constant = 0
            case 1334:
                //                    print("iPhone 6/6S/7/8")
                statusBarDistance.constant = 0
            case 1920, 2208:
                //                    print("iPhone 6+/6S+/7+/8+")
                statusBarDistance.constant = 0
            default:
                print("Unknown")
                statusBarDistance.constant = 15
            }
        }
        
        //Clock setting.
        clockLabel.text = Date().asStringTime
        clockTimer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(ViewController.updateClock), userInfo: nil, repeats: true)
        
        //Method called to reload table when app running from background to foreground.
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.viewDidAppear(_:)), name: NSNotification.Name(rawValue: "refreshingView"), object: nil)
        
        //Observers
        siteWebView!.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*let todaysDate = NSDate().asStringDate()
        let dbDateQuery = db.query("SELECT value FROM settings WHERE key='timerDate'")
        let dbDate = dbDateQuery[0]["value"] as! String
        if dbDate != todaysDate {
            if timer.valid {
                timer.invalidate()
            }
            remainingTimeInSeconds = 0
            storageDefaults.setInteger(remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
            SharingManager.sharedInstance.storyBoardID = "mainScreen"
            storageDefaults.setValue(SharingManager.sharedInstance.storyBoardID, forKey: "storyBoardID")
            super.dismissViewControllerAnimated(false, completion: nil)
        } else {
            refreshingView()
        }*/
        /*let todaysDate = NSDate().asStringDate()
        let dbDateQuery = SM.SI.db.query("SELECT value FROM settings WHERE key='timerDate'")
        let dbDate = dbDateQuery[0]["value"] as! String
        if dbDate != todaysDate {
            resumeTimer()
            timeOutView.hidden = true
            if SM.SI.currentURL == "http://facebook.com" {
                loadingFacebookHome()
            }
        } else {
            if SM.SI.timer.valid {
                SM.SI.timer.invalidate()
            }
            SM.SI.remainingTimeInSeconds = 0
            SM.SI.storageDefaults.setInteger(SM.SI.remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
            timeOutView.hidden = false
        }*/
        timerCheckToDisplayBrowser()
        _ = shouldAutorotate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden : Bool {
                
        return true
    }
    
    //MARK:- Appearance of main screen.
    func loadingURL(_ url: String) {
        
        let urlToLoad = URL(string: url)
        let requestObj = URLRequest(url: urlToLoad!)
        siteWebView!.load(requestObj)
    }
    
    func timerCheckToDisplayBrowser() {
        
        //For daily social time utilization value
        let dailyTimeUtilizationQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='dailySocialTimeUtilization'")
        let dailyTimeUtilization = dailyTimeUtilizationQuery[0]["value"] as! String
        //For set time reminder value
        let setTimerMessageQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='timerSettingMessageDisplay'")
        let setTimerMessageValue = setTimerMessageQuery[0]["value"] as! String
        //Date check
        let todaysDate = Date().asStringDate()
        let dbDateQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='timerDate'")
        let dbDate = dbDateQuery[0]["value"] as! String
        
        if dailyTimeUtilization == "false" && setTimerMessageValue == "false" && dbDate == todaysDate {
            timeOutView.isHidden = true
            timeOutMessageView.isHidden = true
            resumeTimer()
            if AppSettings.shared.currentURL == "http://facebook.com" {
                loadingURL(mainUrl)
            } else {
                loadingURL(AppSettings.shared.currentURL)
            }
        } else {
            //For daily social time value
            let dbTimeQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='dailySocialTime'")
            let dbTime = dbTimeQuery[0]["value"] as! String
            
            if Int(dbTime)! == 0 {
                //Calling alert to show message to set timer.
                alertForSettingTimerFirst()
            } else if Int(dbTime)! != 0 && dailyTimeUtilization == "false" && setTimerMessageValue == "true" {
                //Reminder mmessage for first time to show set timer
                //Calling alert to confirm social time for today
                alertForConfirmingTodaysSocialTime()
            } else if Int(dbTime)! != 0 && dailyTimeUtilization == "false" && setTimerMessageValue == "false" {
                //Updating records in settings table.
                _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(todaysDate)' WHERE key='timerDate'")
                _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='false' WHERE key='dailySocialTimeUtilization'")
                _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='true' WHERE key='timerSettingMessageDisplay'")
                //Calling alert to confirm social time for today
                alertForConfirmingTodaysSocialTime()
            } else if Int(dbTime)! != 0 && dailyTimeUtilization == "true" {
                if dbDate == todaysDate {
                    //Calling alert for reminding of finished social time for today.
                    timeOutView.isHidden = false
                    timeOutMessageView.isHidden = false
                } else {
                    //Updating records in settings table.
                    _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(todaysDate)' WHERE key='timerDate'")
                    _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='false' WHERE key='dailySocialTimeUtilization'")
                    _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='true' WHERE key='timerSettingMessageDisplay'")
                    //Calling alert to confirm social time for today
                    alertForConfirmingTodaysSocialTime()
                }
            }
        }
    }
    
    //MARK:- Resizing web browser methods.
    override var shouldAutorotate : Bool {
        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft ||
            UIDevice.current.orientation == UIDeviceOrientation.landscapeRight ||
            UIDevice.current.orientation == UIDeviceOrientation.unknown) {
            deviceOrientation = "Landscape"
            bottomPanel.isHidden = false
            //self.siteWebView!.frame = CGRectMake(0.0, 30.0, (screenSize.height), (screenSize.width - 98))
//            self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: (containerView.frame.height), height: (containerView.frame.width - 0)) //98
            return true;
        } else {
            deviceOrientation = "Portrait"
            bottomPanel.isHidden = false
            //self.siteWebView!.frame = CGRectMake(0.0, 30.0, screenSize.width, (screenSize.height - 98))
//            self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: containerView.frame.width, height: (containerView.frame.height - 0)) //98
            return true;
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < lastScrollContentOffset {
            bottomPanel.isHidden = false
            if deviceOrientation == "Portrait" {
                //self.siteWebView!.frame = CGRectMake(0.0, 30.0, screenSize.width, (screenSize.height - 98))
//                self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: (screenSize.height - 0)) //98
            } else {
                //self.siteWebView!.frame = CGRectMake(0.0, 30.0, screenSize.height, (screenSize.width - 98))
//                self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.height, height: (screenSize.width - 0)) //98
            }
            //navBarVisibility = true
            //hideNavBar()
        } else if scrollView.contentOffset.y > lastScrollContentOffset {
            bottomPanel.isHidden = true
            if deviceOrientation == "Portrait" {
//                self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: (screenSize.height - 0)) //68
            } else {
//                self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.height, height: (screenSize.width - 0)) //68
            }
            //navBarVisibility = false
            //hideNavBar()
        } else if scrollView.contentOffset.y == lastScrollContentOffset {
            bottomPanel.isHidden = false
            if deviceOrientation == "Portrait" {
                //self.siteWebView!.frame = CGRectMake(0.0, 30.0, screenSize.width, (screenSize.height - 98))
//                self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: (screenSize.height - 0)) //98
            } else {
                //self.siteWebView!.frame = CGRectMake(0.0, 30.0, screenSize.height, (screenSize.width - 98))
//                self.siteWebView!.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.height, height: (screenSize.width - 0)) //98
            }
            //navBarVisibility = true
            //hideNavBar()
        }
        lastScrollContentOffset = scrollView.contentOffset.y
    }
    
    @objc func setPageTop() {
        
        siteWebView!.scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    //MARK:- Timer methods.
    @objc func updateClock() {
        
        clockLabel.text = Date().asStringTime
    }
    
    func resumeTimer() {
        
        if AppSettings.shared.timer.isValid {
            //print("Already valid.")
        } else {
            let displayString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(AppSettings.shared.remainingTimeInSeconds)) + "-"
            remainingTimeLabel.text = displayString
            AppSettings.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateDisplay), userInfo: nil, repeats: true)
            //Setting start time here.
            AppSettings.shared.startTime = Date()
            AppSettings.shared.saveRecord = true
            //print(startTime)
        }
    }
    
    @objc func updateDisplay() {
        
        if AppSettings.shared.remainingTimeInSeconds != 0 {
            let updatedRemainingTime: Int = AppSettings.shared.remainingTimeInSeconds - 1
            let displayString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(updatedRemainingTime)) + "-"
            AppSettings.shared.remainingTimeInSeconds = updatedRemainingTime
            remainingTimeLabel.text = displayString
        } else {
            AppSettings.shared.timer.invalidate()
            AppSettings.shared.storageDefaults.set(AppSettings.shared.remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='true' WHERE key='dailySocialTimeUtilization'")
            let soundFileNameQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='soundFileName'")
            let soundFileName: String = (soundFileNameQuery[0]["value"] as! String)
            let audioFilePath = Bundle.main.path(forResource: soundFileName, ofType:"mp3")
            let audioFileURL = URL(fileURLWithPath: audioFilePath!)
            audioPlayer = try! AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer.play()
            reminderAlert()
        }
    }
    
    func UpdatingRemainingTimeLabel() {
        
        //Table queries for conditional statements check.
        let todaysDate = Date().asStringDate()
        let dbDateQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='timerDate'")
        let dbDate = dbDateQuery[0]["value"] as! String
        //Updating settings table values for new day.
        if dbDate != todaysDate {
            //Updating records in settings table.
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='\(todaysDate)' WHERE key='timerDate'")
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='false' WHERE key='dailySocialTimeUtilization'")
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='true' WHERE key='timerSettingMessageDisplay'")
        }
        let setTimerMessageQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='timerSettingMessageDisplay'")
        let setTimerMessageValue = setTimerMessageQuery[0]["value"] as! String
        
        //For remaining time label in main screen top corner.
        if setTimerMessageValue == "true" {
            //Updating remaining time label on main screen top corner if timer is not started yet.
            let dbTimeQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='dailySocialTime'")
            let dbTime = dbTimeQuery[0]["value"] as! String
            AppSettings.shared.remainingTimeInSeconds = Int(dbTime)!
            AppSettings.shared.storageDefaults.set(AppSettings.shared.remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
            //Assigning time to label.
            let remainingTimeString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(AppSettings.shared.remainingTimeInSeconds)) + "-"
            remainingTimeLabel.text = remainingTimeString
        } else {
            let remainingTimeString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(AppSettings.shared.remainingTimeInSeconds)) + "-"
            remainingTimeLabel.text = remainingTimeString
        }
    }
    
    //MARK:- Top panel methods.
    @IBAction func refreshAction(_ sender: UIButton) {
        
        if loadingFinished == false {
            siteWebView?.stopLoading()
            stopAndReloadButton.setImage(UIImage(named: "refresh-thin.png"), for: UIControl.State())
            loadingFinished = true
        } else {
            siteWebView!.reload()
        }
    }
    
    @IBAction func backwardAction(_ sender: UIButton) {
        
        if siteWebView!.canGoBack {
            siteWebView!.goBack()
            //let fullDomainName = backwardItemList().host!
            //updatingSiteNameAndWritingReprot(fullDomainName)
        }
    }
    
    @IBAction func forwardAction(_ sender: UIButton) {
        
        if siteWebView!.canGoForward {
            siteWebView!.goForward()
            //let fullDomainName = forwardItemList().host!
            //updatingSiteNameAndWritingReprot(fullDomainName)
        }
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        let textToShare:String = "Facebook Time is awesome! I am sharing the site using this app." //siteWebView!.title! //"socialx is awesome! I am sharing the site using this app."
        
        if let myWebsite = URL(string: AppSettings.shared.currentURL) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            //activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
            
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func backwardAndForwardCheck() {
        
        if siteWebView!.canGoBack {
            backwardButton.isEnabled = true
            backwardButton.setImage(UIImage(named: "backward-thin.png"), for: UIControl.State())
        } else {
            backwardButton.isEnabled = false
            backwardButton.setImage(UIImage(named: "backward-disable-thin.png"), for: .disabled)
        }
        
        if siteWebView!.canGoForward {
            //forwardButton.enabled = true
            //forwardButton.setImage(UIImage(named: "forward-thin.png"), forState: .Normal)
        } else {
            //forwardButton.enabled = false
            //forwardButton.setImage(UIImage(named: "forward-disable-thin.png"), forState: .Disabled)
        }
    }
    
    func enablingShareButtonCheck(_ urlToCheck: String) {
        
        if urlToCheck.lowercased().range(of: "facebook.com/") != nil {
            shareButton.isEnabled = false
            shareButton.setImage(UIImage(named: "share-disable-thin.png"), for: .disabled)
            //print(urlToCheck)
        } else {
            shareButton.isEnabled = true
            shareButton.setImage(UIImage(named: "share-thin.png"), for: UIControl.State())
            //print(urlToCheck)
        }
    }
    
    @IBAction func homedAction(_ sender: UIButton) {
        
        loadingURL(mainUrl)
    }
    
    @IBAction func allocateTimeAction(_ sender: UIButton?) {
        
        let setHoursQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='setHours'")
        let setHours = setHoursQuery[0]["value"] as! String
        let setMinutesQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='setMinutes'")
        let setMinutes = setMinutesQuery[0]["value"] as! String
        customPickerView.reloadAllComponents()
        customPickerView.selectRow(DataModel.hoursPickerValues.firstIndex(of: setHours)!, inComponent: 0, animated: true)
        customPickerView.selectRow(DataModel.minutesPickerValues.firstIndex(of: setMinutes)!, inComponent: 1, animated: true)
        pickerConainerView.isHidden = false
    }
    
    @IBAction func reportScreenAction(_ sender: UIButton) {
        
        var reportView:UIViewController = UIViewController()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        reportView = storyBoard.instantiateViewController(withIdentifier: "reportScreen")
        
        if AppSettings.shared.timer.isValid {
            AppSettings.shared.timer.invalidate()
        }
        
        AppSettings.shared.storageDefaults.set(AppSettings.shared.remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
        
        //Saving record in database.
        if AppSettings.shared.saveRecord == true {
            RepeatMethods.recordSpentTime(Date(), mStartTime: AppSettings.shared.startTime)
            AppSettings.shared.saveRecord = false
        }
        
        self.present(reportView, animated: false, completion: nil)
    }
    
    //MARK:- Observer methods.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            if siteWebView!.estimatedProgress == 1.0 {
                let loadedUrl = siteWebView!.url?.absoluteString as String?
                if loadedUrl != "about:blank" {
                    stopAndReloadButton.setImage(UIImage(named: "refresh-thin.png"), for: UIControl.State())
                    AppSettings.shared.currentURL = loadedUrl
                    AppSettings.shared.storageDefaults.setValue(AppSettings.shared.currentURL, forKey: "currentURLKey")
                    loadingFinished = true
                } else {
                    loadingURL(mainUrl)
                }
            } else {
                loadingFinished = false
                stopAndReloadButton.setImage(UIImage(named: "stop-thin.png"), for: UIControl.State())
            }
        }
        enablingShareButtonCheck(AppSettings.shared.currentURL)
        backwardAndForwardCheck()
    }
    
    //To open _blank or new tab window in the same window. Also set siteWebView!.UIDelegate = self
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if ((navigationAction.targetFrame) == nil) {
            siteWebView?.load(navigationAction.request)
            //print(navigationAction)
        }
        return nil
    }
    
    //MARK:- Alerts
    func alertForSetSocialTime() {
        
        let alertVC = UIAlertController(title: "Note", message: "You have already set Facebook Time for today. Your changes will effect tomorrow.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
            //Code.
            })
        present(alertVC, animated: true, completion: nil)
    }
    
    /*func alertForFinishedSocialTime() {
        
        let alertVC = UIAlertController(title: "Reminder!", message: "You have already spent your allocated Facebook Time for today. You can again enjoy Facebook Time tomorrow.", preferredStyle: .Alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default)
        { action -> Void in
            self.timeOutView.hidden = false
            })
        presentViewController(alertVC, animated: true, completion: nil)
    }*/
    
    func alertForSettingTimerFirst() {
        
        let alertVC = UIAlertController(title: "Set Timer", message: "Please set timer first to control your time for Facebook Time.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "SET", style: UIAlertAction.Style.default)
        { action -> Void in
            //Timer button method calling.
            self.allocateTimeAction(nil)
            })
        present(alertVC, animated: true, completion: nil)
    }
    
    func alertForConfirmingTodaysSocialTime() {
        
        //For daily social time value
        let dbTimeQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='dailySocialTime'")
        let dbTime = dbTimeQuery[0]["value"] as! String
        let timeInSpecificFormat = CommonUtilities.secondsToHoursMinutesSeconds(Int(dbTime)!)
        let messageContent = "You have set '\(timeInSpecificFormat)' for today. To change it tap reset otherwise tap OK to continue with set time for today."
        let alertVC = UIAlertController(title: "Your Set Time", message: messageContent, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
            //Setting remainingTimeInSeconds from settings table for today once only everyday.
            let dbTimeQuery = AppSettings.shared.db.query(sql: "SELECT value FROM settings WHERE key='dailySocialTime'")
            let dbTime = dbTimeQuery[0]["value"] as! String
            AppSettings.shared.remainingTimeInSeconds = Int(dbTime)!
            AppSettings.shared.storageDefaults.set(AppSettings.shared.remainingTimeInSeconds, forKey: "remainingTimeInSeconds")
            //Assigning time to label.
            let remainingTimeString: String  = (CommonUtilities.secondsToHoursMinutesSeconds(AppSettings.shared.remainingTimeInSeconds)) + "-"
            self.remainingTimeLabel.text = remainingTimeString
            //Code for not showing this alert message again.
            _ = AppSettings.shared.db.execute(sql: "UPDATE settings SET value='false' WHERE key='timerSettingMessageDisplay'")
            self.timerCheckToDisplayBrowser()
            //Going to site screen.
            /*SharingManager.sharedInstance.storyBoardID = "siteScreen"
            storageDefaults.setValue(SharingManager.sharedInstance.storyBoardID, forKey: "storyBoardID")
            self.presentViewController(self.siteWebView, animated: false, completion: nil)*/
            })
        alertVC.addAction(UIAlertAction(title: "RESET", style: UIAlertAction.Style.cancel)
        { action -> Void in
            //Timer button method calling.
            self.allocateTimeAction(nil)
            })
        present(alertVC, animated: true, completion: nil)
    }
    
    //When remaining time finished on this screen.
    func reminderAlert() {
        
        let alertVC = UIAlertController(title: "Time's Up!", message: "You have spent your allocated Facebook Time for today. You can again enjoy Facebook Time tomorrow.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        { action -> Void in
            if self.audioPlayer.currentTime > 0 {
                //print(self.audioPlayer.currentTime)
                self.audioPlayer.stop()
            } else {
                self.audioPlayer.currentTime = 0
            }
            //Saving record in database.
            if AppSettings.shared.saveRecord == true {
                RepeatMethods.recordSpentTime(Date(), mStartTime: AppSettings.shared.startTime)
                AppSettings.shared.saveRecord = false
            }
            self.timeOutView.isHidden = false
            self.timeOutMessageView.isHidden = false
            })
        present(alertVC, animated: true, completion: nil)
    }
}

