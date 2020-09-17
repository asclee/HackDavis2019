import UIKit
import SwiftyJSON

import Foundation
import Alamofire

import CoreMotion

var motionManager: CMMotionManager!
let recorder = CMSensorRecorder()
let motion = CMMotionManager()

var timer = Timer()
var counter = 0
var y_intial = 0.0

class FallViewController: UIViewController {
    @IBOutlet weak var fallDetectLabel: UILabel!
    
    @IBOutlet weak var promptFirstLine: UILabel!

    @IBOutlet weak var promptSecondLine: UILabel!
    
    @IBOutlet weak var yesButtonOutlet: UIButton!
    
    @IBOutlet weak var noButtonOutlet: UIButton!
    
    @IBAction func yesButton(_ sender: Any) {
        sendTextMessage()
    }
    
    @IBAction func noButton(_ sender: Any) {
        promptFirstLine.isHidden = true
        promptSecondLine.isHidden = true
        yesButtonOutlet.isHidden = true
        noButtonOutlet.isHidden = true
        fallDetectLabel.textColor = UIColor.red
        fallDetectLabel.text = "Fall Detected = False"
    }
    
    override func viewDidLoad() {
        promptFirstLine.isHidden = true
        promptSecondLine.isHidden = true
        yesButtonOutlet.isHidden = true
        noButtonOutlet.isHidden = true
        
        motion.startAccelerometerUpdates()
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction() {
        if (motion.accelerometerData == nil) {
            return
        }
        
        if (counter == 0) {
            y_intial = round((motion.accelerometerData!.acceleration.y) * 100)
            counter += 1
            return
        }
        
        counter += 1
        
        let data = motion.accelerometerData
        let y = round((data!.acceleration.y) * 100)
        
        if (abs(y_intial - y) > 90) {
            // Fall detection triggered
            fallDetectLabel.text = "Fall Detected = True"
            fallDetectLabel.textColor = UIColor.green
            promptFirstLine.isHidden = false
            promptSecondLine.isHidden = false
            yesButtonOutlet.isHidden = false
            noButtonOutlet.isHidden = false
        }
        
        y_intial = y
    }
    
    func sendTextMessage() {
        let accountSID = "ACCOUNT_SID"
        let authToken = "AUTH_TOKEN"
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        let parameters = ["From": "PHONE_NUM", "To": "PHONE_NUM", "Body": "Detected Fall from John Appleseed. LOCATION: Pavilion at ARC. Please call (315) 451 - 2819!"]
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                debugPrint(response)
        }
    }
}
