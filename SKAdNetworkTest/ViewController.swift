//
//  ViewController.swift
//  SKAdNetworkTest
//
//  Created by Michael Horn on 9/13/20.
//

import UIKit
import StoreKit
import AppTrackingTransparency
import AdSupport
import Branch

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTrackingAuthorization()
    }
    
    private var idfa: UUID {
        return ASIdentifierManager.shared().advertisingIdentifier
    }
    
    func requestTrackingAuthorization() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                // Tracking authorization dialog was shown and opt-in by User
                // The value returned if the user authorizes access to app-related data that can be used for tracking the user or the device.
                // If Authorized, we can access the IDFA
                print("Authorized")
                print("IDFA value is:", self.idfa)
            case .denied:
                // Tracking authorization dialog was shown and permission is denied
                // The value returned if the user denies authorization to access app-related data that can be used for tracking the user or the device.
                // If user denies it then we get all 0s in the UUID.
                // There's an option "Allow Apps to Request to Track" in system's Settings app, and if it's off, requestTrackingAuthorization will return .denied immediately (See Slide).
                print("Denied")
            case .notDetermined:
                // Tracking authorization dialog has not been shown - you can display the dialog under this condition
                print("Not Determined")
            case .restricted:
                // Limited Ad Tracking already set
                // The value returned if authorization to access app-related data that can be used for tracking the user or the device is restricted.
                print("Restricted")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    //TODO: Track Event EXAMPLE for when Branch SDK
    
    @IBAction func registration(sender: UIButton){
        
        // With Branch SDK, updateConversionValue is automatically called if there is a mapping in the Dashboard setup for that event.
        // Create a buo and track your event as you normally would
        let buo = BranchUniversalObject.init(canonicalIdentifier: "content/12345")
        buo.title = "My Content Title"
        buo.contentDescription = "My Content Description"
        buo.imageUrl = "https://lorempixel.com/400/400"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.contentMetadata.customMetadata["key1"] = "value1"
        BranchEvent.standardEvent(.completeRegistration, withContentItem: buo).logEvent()
        
        // Without Branch, call updateConversionValue manually.
        
        // 1:
        // User puts his phone down for a bit, comes back and registers with his email address
        // The App calls updateConversationValue with that value that represents the registered action
        // Looping timer restarts since this action was within the initial 24 hour window
        
        SKAdNetwork.updateConversionValue(5)
    }
    
    @IBAction func addToCart(sender: UIButton){
        
        // 2:
        // User  browses for a little while and adds something to his cart
        // Since conversion value for addToCart is higher than registration, when updateConversionValue is called, the device takes the updated conversion value of 40
        
        SKAdNetwork.updateConversionValue(40)
    }
    
    @IBAction func purchase(sender: UIButton){
        // 3:
        // The next day User remembers to finish their purchase
        // Purchase has a conversion value of 63 which is higher than addToCart
        // Another 24 hour looping timer is started
        
        SKAdNetwork.updateConversionValue(63)
        
        // 4:
        // User forgets to add something else to cart so he goes back to do so
        // when that action occurs, it is not accepted because it is lower than add to cart
        // as a result, looping timer doesnt not restart
        
        // 5:
        // 24 hour looping timer expires
        // From there, Apple adds additional random time window btwn 0-24 hours before sending postback to the ad network
        // Only ONE postback is ever sent, only ONE conversion value is ever included
    }
    
}

