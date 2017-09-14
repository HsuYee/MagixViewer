//
//  PanoViewThreeSixty.swift
//  UI_Project
//
//  Created by Hsu Yee Htike on 12/9/17.
//  Copyright © 2017 Hsu Yee Htike. All rights reserved.
//

import UIKit
import SceneKit

open class MagixViewController: UIViewController{
    
    var panoView : MagixView = {
        let view = MagixView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.image = UIImage(named: "brownstone.jpg")
        return view
    }()
    
    var closeButt : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("x", for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    var changeMode : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Mode", for: .normal)
        button.addTarget(self, action: #selector(toggleView), for: .touchUpInside)
        return button
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        UIView.setAnimationsEnabled(false)
        setupView()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        panoView.panoView()
    }
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView(){
        view.addSubview(panoView)
        view.addSubview(closeButt)
        view.addSubview(changeMode)
        
        view.addConstraintsWithFormat("H:|[v0]|", views: panoView)
        view.addConstraintsWithFormat("V:|[v0]|", views: panoView)
        
        view.addConstraints([
            NSLayoutConstraint(item: changeMode, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0)
            ])
    }
    
    func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func toggleView(){
        panoView.toggleView()
    } 
    
    deinit {
        print("PanoramaViewController deinit")
    }
    
}
