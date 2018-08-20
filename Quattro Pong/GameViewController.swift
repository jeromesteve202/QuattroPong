//
//  GameViewController.swift
//  Pong
//
//  Created by Steve Sahayadarlin on 7/27/17.
//  Copyright © 2017 Steve Sahayadarlin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase
import GoogleMobileAds

var heightOffset = Double()
var widthOffset = Double()
var originalHeight = Double()
var originalWidth = Double()

var shouldShowRewardVideo = false
var shouldShowInterstitial = false
var adDidClose = false

var numOfTurns = 0

var ballColors = [UIColor]()


class GameViewController: UIViewController, GADRewardBasedVideoAdDelegate, GADInterstitialDelegate {
    
    var adTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addColorsForBall()
        
        interstitial = createAndLoadInterstitial()
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
//        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-2830059983414219/7143062235")
        
        let bestScoreObj = UserDefaults.standard.object(forKey: "bestscore")
        if let double1 = bestScoreObj as? Double {
            bestScore = double1
        }
        
        adTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        
        originalHeight = Double(self.view.frame.size.height)
        originalWidth = Double(self.view.frame.size.width)
        heightOffset = originalHeight / 667
        widthOffset = originalWidth / 375
        
        loadingLabel.frame.size.height = loadingLabel.frame.height * CGFloat(heightOffset)
        loadingLabel.frame.size.width = loadingLabel.frame.width * CGFloat(widthOffset)
        loadingLabel.isHidden = true
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
    }
    
    func addColorsForBall() {
        ballColors.append(UIColor(red: 34/255, green: 253/255, blue: 41/255, alpha: 1))
        ballColors.append(UIColor(red: 158/255, green: 200/255, blue: 247/255, alpha: 1))
        ballColors.append(UIColor(red: 255/255, green: 228/255, blue: 79/255, alpha: 1))
        ballColors.append(UIColor(red: 200/255, green: 234/255, blue: 177/255, alpha: 1))
        ballColors.append(UIColor(red: 233/255, green: 141/255, blue: 213/255, alpha: 1))
        ballColors.append(UIColor(red: 2/255, green: 210/255, blue: 227/255, alpha: 1))
        ballColors.append(UIColor(red: 204/255, green: 222/255, blue: 227/255, alpha: 1))
        ballColors.append(UIColor(red: 233/255, green: 227/255, blue: 62/255, alpha: 1))
        ballColors.append(UIColor(red: 44/255, green: 233/255, blue: 219/255, alpha: 1))
        ballColors.append(UIColor(red: 245/255, green: 204/255, blue: 192/255, alpha: 1))
        ballColors.append(UIColor(red: 35/255, green: 171/255, blue: 163/255, alpha: 1))
        ballColors.append(UIColor(red: 167/255, green: 201/255, blue: 200/255, alpha: 1))
        ballColors.append(UIColor(red: 218/255, green: 196/255, blue: 114/255, alpha: 1))
        ballColors.append(UIColor(red: 195/255, green: 134/255, blue: 179/255, alpha: 1))
        ballColors.append(UIColor(red: 246/255, green: 254/255, blue: 112/255, alpha: 1))
        ballColors.append(UIColor(red: 31/255, green: 115/255, blue: 230/255, alpha: 1))
        ballColors.append(UIColor(red: 236/255, green: 159/255, blue: 110/255, alpha: 1))
        ballColors.append(UIColor(red: 176/255, green: 213/255, blue: 27/255, alpha: 1))
        ballColors.append(UIColor(red: 253/255, green: 186/255, blue: 5/255, alpha: 1))
        ballColors.append(UIColor(red: 124/255, green: 173/255, blue: 245/255, alpha: 1))
        
    }
    
    var isAdLoading = false
    @IBOutlet var loadingLabel: UILabel!
    
    func updateTimer() {
        if shouldShowRewardVideo {
            if GADRewardBasedVideoAd.sharedInstance().isReady == true {
                if isAdLoading {
                    isAdLoading = false
                    loadingLabel.isHidden = true
                    self.view.isUserInteractionEnabled = true
                }
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                shouldShowRewardVideo = false
            }else{
                shouldShowRewardVideo = true
                isAdLoading = true
                loadingLabel.isHidden = false
                self.view.isUserInteractionEnabled = false
            }
        }
        
        if shouldShowInterstitial {
            shouldShowInterstitial = false
            if numOfTurns % 5 == 0 {
                displayInterstitial()
            }
        }
    }
    
    func displayInterstitial() {
        shouldShowInterstitial = false
        if (interstitial?.isReady)! {
            interstitial?.present(fromRootViewController: self)
        }else{
            print("Ad wasn't ready")
        }
    }
    
    var interstitial: GADInterstitial?
    
    func createAndLoadInterstitial() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2830059983414219/4488978732")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }


    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didRewardUserWith reward: GADAdReward) {
        print("\n\n EXTRA LIFE AWARDED \n\n ")
        let completeLevelAlert = UIAlertController(title: "Success!", message: "Extra life received for each time you play this session.", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){(ACTION) in
        }
        completeLevelAlert.addAction(okAction)
        self.present(completeLevelAlert, animated: true, completion: nil)
        doesHaveExtraLife = true
        didWatchVideo = true
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd:GADRewardBasedVideoAd) {
        print("Reward based video ad is received.")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Opened reward based video ad.")
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad started playing.")
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad is closed.")
        adDidClose = true
        
    }
    
    func rewardBasedVideoAdWillLeaveApplication(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("Reward based video ad will leave application.")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd,
                            didFailToLoadWithError error: Error) {
        print("Reward based video ad failed to load.")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
