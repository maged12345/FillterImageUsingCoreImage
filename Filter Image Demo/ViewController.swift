//
//  ViewController.swift
//  Filter Image Demo
//
//  Created by maged mohamed on 12/6/21.
//  Copyright © 2021 maged mohamed. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var intenditySlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    
    var currentImage:UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Filter Image"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
    }
    @objc func importPicture ( ) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil )
    }

    @IBAction func changeFilterButton(_ sender: UIButton) {
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
    }
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
    }
    
}

