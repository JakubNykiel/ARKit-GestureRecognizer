//
//  ARKitViewController.swift
//  ARKit-GestureRecognizer
//
//  Created by Jakub Nykiel on 17.03.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ARKitViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var backBtn: UIButton!
    var configuration: ARWorldTrackingConfiguration!
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func prepare() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        self.navigationController?.isNavigationBarHidden = true
        self.backBtn.layer.cornerRadius = 0.5 * backBtn.bounds.size.width
        
    }
    
    @objc func vibratePhone() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    @IBAction func removeAllFromScene(_ sender: Any) {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    @IBAction func stopSound(_ sender: Any) {
        timer?.invalidate()
    }
    
    @IBAction func playSound(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(vibratePhone), userInfo: nil, repeats: true)
    }
    
    @IBAction func addToScene(_ sender: Any) {
       self.addNode()
    }
    @IBAction func addManyToScene(_ sender: Any) {
        for _ in 0...1 {
            self.addNode()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
extension ARKitViewController: ARSCNViewDelegate {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
extension ARKitViewController {
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func addNode() {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        let x = randomNumbers(firstNum: -0.2, secondNum: 0.2)
        let y = randomNumbers(firstNum: -0.2, secondNum: 0.2)
        let z = randomNumbers(firstNum: -1.5, secondNum: -0.8)
        
        node.position = SCNVector3(x,y,z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}
