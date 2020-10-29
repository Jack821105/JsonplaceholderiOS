//
//  PhotosCollectionViewCell.swift
//  jsonplaceholderiOS
//
//  Created by 許自翔 on 2020/10/28.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var photo:Photo?
    
    
    func update() {
        guard let photoData = photo else {
            return
        }
        let id = photoData.id
        titleLabel.text = photoData.title
        idLabel.text = String(id)
        photoImageView.image = UIImage(systemName: "questionmark.circle")
        
        Network.shared.fetchImage(url: photoData.url150) { [weak self] (image:UIImage?) in
            guard let image = image else { return }
            if id == self?.photo?.id{
                DispatchQueue.main.async {
                    self?.photoImageView.image = image
                }
            }
            
        }
        
    }
    
}




