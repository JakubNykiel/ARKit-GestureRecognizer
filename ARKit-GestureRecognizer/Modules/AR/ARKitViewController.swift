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

class ARKitViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    private func prepare() {
        sceneView.delegate = self
//        sceneView.showsStatistics = true
        self.navigationController?.isNavigationBarHidden = true
        self.backBtn.layer.cornerRadius = 0.5 * backBtn.bounds.size.width
        
    }
    @IBAction func removeAllFromScene(_ sender: Any) {
        
    }
    @IBAction func addToScene(_ sender: Any) {
        
    }
    @IBAction func addManyToScene(_ sender: Any) {
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

}
