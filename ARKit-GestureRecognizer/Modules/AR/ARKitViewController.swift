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
import CoreML
import Vision

class ARKitViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    
    var configuration: ARWorldTrackingConfiguration!
    var timer : Timer?
    
    var detectCounter: Int = 0
    var detections: [String:Int] = [:]
    var detectingIsActive: Bool = true
    
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    var visionRequests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
        self.prepareCoreML()
        self.searchBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = true
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
    
    private func prepareCoreML() {
        guard let selectedModel = try? VNCoreMLModel(for: gesty2().model) else {
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project. Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        visionRequests = [classificationRequest]
        loopCoreMLUpdate()
    }
    
    func loopCoreMLUpdate() {
        dispatchQueueML.async {
            print(self.detectingIsActive)
            if self.detectingIsActive {
                self.updateCoreML()
                self.loopCoreMLUpdate()
            }
            
        }
    }
    
    func updateCoreML() {
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
    @objc func vibratePhone() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

    @IBAction func searchAction(_ sender: Any) {
        self.detectingIsActive = true
        loopCoreMLUpdate()
        self.searchBtn.isHidden = true
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        let observation = observations.first as? VNClassificationObservation
        
        let observationIdentifier: String = observation!.identifier
        let observationValue: String = String(format:" : %.2f", observation!.confidence)
        
        DispatchQueue.main.async {
//            print("\(observationIdentifier) - \(observationValue)")
            if observation!.confidence > 0.4 {
                if self.detections[observationIdentifier] == nil {
                    self.detections[observationIdentifier] = 0
                }
                self.detections[observationIdentifier] = self.detections[observationIdentifier]! + 1
                print("\(String(describing: self.detections[observationIdentifier]!)): \(observationIdentifier) - \(observationValue)")
                print("-------------")
                if self.detections[observationIdentifier] == 18 {
                    self.detectingIsActive = false
                    switch observationIdentifier {
                    case "muka":
                        self.addNode(color: UIColor.blue)
                        self.detections = [:]
                        self.searchBtn.isHidden = false
                    case "loser":
                        self.addNode(color: UIColor.orange)
                        self.addNode(color: UIColor.red)
                        self.detections = [:]
                        self.searchBtn.isHidden = false
                    case "pi?teczka":
                        self.sceneView.session.pause()
                        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                            node.removeFromParentNode()
                        }
                        self.sceneView.session.run(self.configuration)
                        self.detections = [:]
                        self.searchBtn.isHidden = false
                    default:
                        self.detectingIsActive = true
                        print("Nieznany gest")
                    }
                }
            }
            
        }
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
    
    func addNode(color: UIColor) {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.firstMaterial?.specular.contents = UIColor.yellow
        node.geometry?.firstMaterial?.diffuse.contents = color
        let x = randomNumbers(firstNum: -0.2, secondNum: 0.2)
        let y = randomNumbers(firstNum: -0.2, secondNum: 0.2)
        let z = randomNumbers(firstNum: -1.2, secondNum: -0.6)
        
        node.position = SCNVector3(x,y,z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
}
