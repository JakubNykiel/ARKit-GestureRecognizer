//
//  MenuViewController.swift
//  ARKit-GestureRecognizer
//
//  Created by Jakub Nykiel on 17.03.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import UIKit
import ImagePicker
class MenuViewController: UIViewController {

    @IBOutlet weak var ARBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
    }
    
    @IBAction func showLibrary(_ sender: Any) {
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func prepare() {

    }
}
extension MenuViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        let photoLibraryVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoLibrary") as! PhotoLibrary
        photoLibraryVC.images = images
        self.dismiss(animated: true, completion: {
            self.navigationController?.show(photoLibraryVC, sender: nil)
        })
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
