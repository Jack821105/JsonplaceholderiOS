//
//  PhotosCollectionViewController.swift
//  jsonplaceholderiOS
//
//  Created by 許自翔 on 2020/10/28.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController {
    
    
    var photoList = [Photo]()
    let limit:Int = 48
    var pages:Int = 1
    var hasMore = true
    var isLoadingMore = false
    var isLoading = false
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        UIView()
        loadData()
        // Do any additional setup after loading the view.
        
        
        
    }
    
    func UIView() {
        //控制cell
        let itemSpace: CGFloat = 0
        let columnCount: CGFloat = 4
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width  - itemSpace * (columnCount)) / columnCount)
        print("width",width, collectionView.bounds)
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
 
    
        
    }
    
    
    func loadData() {
        showLoadingView()
        isLoadingMore = true
        Network.shared.fetchData(limit: limit, pages: pages) {[weak self]  (photoList) in
            guard let self = self else { return }
            if let photoList:[Photo] = photoList{
                self.photoList.append(contentsOf: photoList)
                self.dismissLoadingView()
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        isLoadingMore = false
    }
    
    //滑動底部判斷
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        if offsetY > contentHeight - height {
            guard hasMore, !isLoadingMore else { return }
            pages += 1
            loadData()
        }
    }
    
    func showLoadingView() {
        containerView = UIKit.UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor   = .systemBackground
        containerView.alpha             = 0
        UIKit.UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.5 }
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhotosCollectionViewCell.self)", for: indexPath) as? PhotosCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.photo = photoList[indexPath.row]
        cell.update()
        
        
        return cell
    }
    
   
}
