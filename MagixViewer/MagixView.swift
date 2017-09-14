//
//  PanoViewThreeSixty.swift
//  UI_Project
//
//  Created by Hsu Yee Htike on 12/9/17.
//  Copyright © 2017 Hsu Yee Htike. All rights reserved.
//

import UIKit
import SceneKit

public class MagixView: UIView, SCNSceneRendererDelegate{
    
    //    MARK: Properties
    
    public var image: UIImage?{
        didSet{
            if let image = image {
                setupSphere(image: image)
            }else{
                setupSphere(image: UIImage(named: "ascentiaSky.jpg")!)
            }
        }
    }
    
    fileprivate let scene = SCNScene()
    fileprivate let leftSceneView = SCNView()
    fileprivate let rightSceneView = SCNView()
    fileprivate let mainSceneView = SCNView()
    
    fileprivate var sphereNode = SCNNode()
    fileprivate var sphereGeometry = SCNSphere(radius: 10)
    
    fileprivate let leftCamera = SCNCamera()
    fileprivate let leftCameraNode = SCNNode()
    fileprivate let rightCamera = SCNCamera()
    fileprivate let rightCameraNode = SCNNode()
    fileprivate let mainCamera = SCNCamera()
    fileprivate let mainCameraNode = SCNNode()
    
    fileprivate let navigator = ThreeSixtyNavigator()
    
    fileprivate var vrMode = false
    
    
    fileprivate var width: CGFloat = 0.0    // width for each view
    fileprivate var height: CGFloat = 0.0   // height for each view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupScene()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    deinit {
        print("PanoViewThreeSixty deinit")
        scene.rootNode.cleanup()
        AppUitility.lockOrientation([.portrait, .landscapeLeft, .landscapeRight], andRotateTo: .portrait)
    }
    
    func setupScene(){
        leftSceneView.showsStatistics = true
        rightSceneView.showsStatistics = true
        mainSceneView.showsStatistics = true
        
        leftSceneView.translatesAutoresizingMaskIntoConstraints = false
        rightSceneView.translatesAutoresizingMaskIntoConstraints = false
        mainSceneView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addSubview(leftSceneView)
        self.addSubview(rightSceneView)
        self.addSubview(mainSceneView)
        
        addConstraintsWithFormat("H:|[v0]|", views: mainSceneView)
        addConstraintsWithFormat("V:|[v0]|", views: mainSceneView)
        
        addConstraints([
            NSLayoutConstraint(item: leftSceneView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: leftSceneView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: leftSceneView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            
            NSLayoutConstraint(item: rightSceneView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: rightSceneView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rightSceneView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            ])
        
        leftSceneView.scene = scene
        rightSceneView.scene = scene
        mainSceneView.scene = scene
        
        setupCamera()
        setupNavigation()
    }
    
    func setupNavigation(){
        leftSceneView.delegate = self
        self.navigator.setupPanGestureRecognizer(withView: self)
        self.navigator.navigationMode = .panGestureAndDeviceMotion
    }
    
    func setupCamera(){
        leftCameraNode.camera = leftCamera
        leftCameraNode.position = SCNVector3(x: -0.5, y: 0, z: 5)
        
        rightCameraNode.camera = rightCamera
        rightCameraNode.position = SCNVector3(x: -0.5, y: 0, z: 5)
        
        leftSceneView.pointOfView = leftCameraNode
        rightSceneView.pointOfView = rightCameraNode
        mainSceneView.pointOfView = mainCameraNode
        
        mainCameraNode.camera = mainCamera
        mainCameraNode.camera?.yFov = 85
        mainCameraNode.position = SCNVector3(x: 0, y: 0, z: 0)
        mainCameraNode.addChildNode(leftCameraNode)
        mainCameraNode.addChildNode(rightCameraNode)
        scene.rootNode.addChildNode(mainCameraNode)
    }
    
    func setupSphere(image: UIImage){
        let material = SCNMaterial()
        material.diffuse.contents = image
        material.diffuse.mipFilter = .nearest
        material.diffuse.magnificationFilter = .nearest
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, 1, 1)
        material.diffuse.wrapS = .repeat
        material.cullMode = .front
        
        sphereGeometry.segmentCount = 300
        sphereGeometry.firstMaterial = material
        sphereNode.geometry = sphereGeometry
        scene.rootNode.addChildNode(sphereNode)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {  [weak self] () -> Void in
            guard let strongSelf = self else{
                return
            }
            let orientation = strongSelf.navigator.updateCurrentOrientation()
            strongSelf.mainCameraNode.orientation = orientation
        }
    }
    
    //    func panoView(){
    //        print("hello from panoView ~")
    //
    //        let leftViewFrame = self.frame
    //        leftSceneView.frame = leftViewFrame
    //        leftSceneView.isPlaying = true
    //
    //        rightSceneView.isHidden = true
    //        rightSceneView.isPlaying = false
    //    }
    //
    //    func vrLandscapeMode(){
    //        width = self.frame.size.width/2.0
    //        height = self.frame.size.height
    //        let leftViewFrame = CGRect(x: 0, y: 0, width: width, height: height)
    //        let rightViewFrame = CGRect(x: width, y: 0, width: width, height: height)
    //
    //        rightSceneView.isHidden = false
    //        rightSceneView.isPlaying = true
    //        leftSceneView.frame = leftViewFrame
    //        rightSceneView.frame = rightViewFrame
    //    }
    
    func toggleView(){
        vrMode = !vrMode
        if vrMode {
            vrView()
        }else {
            panoView()
        }
    }
    
    func panoView(){
        AppUitility.lockOrientation([.portrait, .landscapeLeft, .landscapeRight], andRotateTo: .portrait)
        leftSceneView.isPlaying = false
        rightSceneView.isPlaying = false
        mainSceneView.isPlaying = true
        
        leftSceneView.isHidden = true
        rightSceneView.isHidden = true
        mainSceneView.isHidden =  false
        self.navigator.navigationMode = .panGestureAndDeviceMotion
    }
    
    func vrView(){
        AppUitility.lockOrientation([.landscapeRight], andRotateTo: .landscapeRight)
        leftSceneView.isPlaying = true
        rightSceneView.isPlaying = true
        mainSceneView.isPlaying = false
        
        leftSceneView.isHidden = false
        rightSceneView.isHidden = false
        mainSceneView.isHidden =  true
        self.navigator.navigationMode = .deviceMotion
    }
}









