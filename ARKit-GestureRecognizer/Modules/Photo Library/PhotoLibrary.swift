//
//  PhotoLibrary.swift
//  ARKit-GestureRecognizer
//
//  Created by Jakub Nykiel on 17.03.2018.
//  Copyright © 2018 Jakub Nykiel. All rights reserved.
//

import Foundation
import Photos

class PhotoLibrary: UIViewController {
    
    var images: [UIImage] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
}
extension PhotoLibrary: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraCell", for: indexPath as IndexPath) as! UserImagesCollectionViewCell
        cell.userImage.image = self.images[indexPath.row]
        return cell
    }
}
