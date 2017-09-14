//
//  ViewController.swift
//  MagixViewer
//
//  Created by Hsu Yee Htike on 12/9/17.
//  Copyright © 2017 Hsu Yee Htike. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var showPano: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pya Zan ~", for: .normal)
        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(pyaKyiKyi), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        view.addSubview(showPano)
        
        view.addConstraints([
            NSLayoutConstraint(item: showPano, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: showPano, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 16)
            ])
        
        
    }
    
    func pyaKyiKyi(){
        let panoView = MagixViewController()
        panoView.image = UIImage(named: "brownstone.jpg")
        self.present(panoView, animated: true, completion: nil)
    }


}

