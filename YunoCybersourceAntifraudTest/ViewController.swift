//
//  ViewController.swift
//  YunoCybersourceAntifraudTest
//
//  Created by Lautaro Pinto on 25/10/2023.
//

import UIKit
import RLTMXProfiling
import RLTMXProfilingConnections

class ViewController: UIViewController {
    var profilingConnections: RLTMXProfilingConnections?
    var profile: RLTMXProfiling?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfilingSDK()
        startCybersourceProfiling()
    }
    
    private func setUpProfilingSDK() {
        profilingConnections = RLTMXProfilingConnections.init()
        profilingConnections?.connectionTimeout = 20
        
        profilingConnections?.connectionRetryCount = 2;
        profile = RLTMXProfiling.sharedInstance()
        
        var orgID: String = ""
        #if DEBUG
        orgID = "1snn5n9w"
        #elseif RELEASE
        orgID = "k8vif92e"
        #endif
        
        profile?.configure(configData:[
            // (REQUIRED) Organization ID
            RLTMXOrgID              :orgID,
            // (REQUIRED) Enhanced fingerprint server
            RLTMXFingerprintServer  :"h-sdk.online-metrix.net",
            // (OPTIONAL) If Keychain Access sharing groups are used,
            RLTMXProfilingConnectionsInstance: profilingConnections,
        ])
    }
    
    private func startCybersourceProfiling() {
        let uuid = UUID().uuidString
        let sessionID = "yuno_test\(uuid)"
        
        let customAttributes: [String : String] = [RLTMXSessionID: sessionID]
        let profileHandle: RLTMXProfileHandle? = profile?.profileDevice(
            profileOptions: customAttributes,
            callbackBlock: { (result:[AnyHashable : Any]?) -> Void in
                let results:NSDictionary! = result! as NSDictionary
                let status:RLTMXStatusCode  = RLTMXStatusCode(
                    rawValue:(results.value(forKey: RLTMXProfileStatus) as! NSNumber).intValue
                )!
                
                if(status == RLTMXStatusCode.RLTMXStatusCodeOk) {
                    self.sendSessionID(sessionID: sessionID)
                }
            })
    }
    
    func sendSessionID(sessionID: String) {
        print("Cybersource session ID: \(sessionID)")
    }
}
