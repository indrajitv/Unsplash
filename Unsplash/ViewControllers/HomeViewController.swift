//
//  ViewController.swift
//  Unsplash
//
//  Created by Indrajit-mac on 31/12/18.
//  Copyright © 2018 IND. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var grideFlow = PinterestLayout()
    var listFlow = UICollectionViewFlowLayout()
    var currentPagination = 1
    lazy var photoCollectionView:UICollectionView={
        grideFlow.delegate  = self
        let cv = UICollectionView(frame: .zero, collectionViewLayout: listFlow)
        cv.delegate = self
        cv.dataSource = self
        cv.register(HomeViewPhotoCell.self, forCellWithReuseIdentifier: "HomeViewPhotoCell")
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.bounces = true
        cv.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return cv
    }()
    
    var photosArray = [Photo]()
    
    lazy var rightBarButton:UIBarButtonItem={
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(self.rightBarButtonClicked))
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setUpViews()
        
    }
    
    
    func setUpViews(){
        
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 :
            self.title = "Good morning"
        case 12:
            self.title = "Good noon"
        case 13..<17 :
            self.title = "Good afternoon"
        case 17..<22 :
            self.title = "Good evninig"
        default:
            self.title = "Good night"
        }
        
        listFlow.minimumLineSpacing = 10
        listFlow.minimumInteritemSpacing = 10
        self.view.backgroundColor = .white
        self.view.addSubview(photoCollectionView)
        photoCollectionView.fillOnSupperView()
     
        self.navigationItem.rightBarButtonItem = rightBarButton
     
        self.apiRequestToListPhotos()
    }

  
    func apiRequestToListPhotos(){
       
        let request = APIRequest()
        request.doRequestForDecodable(decodablClass: [Photo].self, method: .GET, queryString: "photos?page=\(self.currentPagination)", parameters: nil,showLoading: self.currentPagination == 1) { (photos, error) in
            
            if let error = error{
                print("#error found in photo API ",error)
            }else if let val = photos{
                self.photosArray.append(contentsOf: val)
            }else{ }
            
            self.photoCollectionView.reloadData()
            
        }
    }
    
    @objc func rightBarButtonClicked(sender:UIBarButtonItem){
        if self.photoCollectionView.collectionViewLayout == grideFlow{
            sender.image = #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal)
            self.photoCollectionView.collectionViewLayout = listFlow
        }else{
            sender.image = #imageLiteral(resourceName: "list").withRenderingMode(.alwaysOriginal)
            self.photoCollectionView.collectionViewLayout = grideFlow
        }
    }
   
}



extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegate,PinterestLayoutDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return photosArray.count
  
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeViewPhotoCell", for: indexPath) as! HomeViewPhotoCell
        cell.indexPath = indexPath
        cell.photo = photosArray[indexPath.item]
   
        if indexPath.item == self.photosArray.count - 1{
            currentPagination += 1
            self.apiRequestToListPhotos()
        }
        return cell
    }
    
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat{
        if var height = photosArray[indexPath.item].height{
            height = height/8
            return CGFloat(height > 400 ? 400 : height)
        }
     
       return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? HomeViewPhotoCell{
           cell.photoImageView.animateImageView(replaceImageInZoomMode: cell.photo?.urls?.full)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if var height = photosArray[indexPath.item].height{
            height = height/8
            height = height > 500 ? 500 : height
            return CGSize(width: collectionView.frame.width-20, height: CGFloat(height))
        }
        return .zero
    }
    
    
    
}


class HomeViewPhotoCell:BaseCellForCollectionView{
    var indexPath:IndexPath?
    var photo:Photo?{
        didSet{
            if let photoDetails = photo{
                
                if let color = photoDetails.color{
                    self.photoImageView.layer.borderColor = UIColor.hexStringToUIColor(hex: color).cgColor
                    self.photoImageView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
                }else{
                    self.photoImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                    self.photoImageView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                }
                
                if let value = photoDetails.urls?.regular{
                    self.photoImageView.loadAsyncFrom(url: value, placeholder: nil)
                }else{
                    self.photoImageView.image = nil
                }
           
            }else{
                
            }
        }
    }
    let photoImageView:MyImageView={
        let iv = MyImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override func setUpViews() {
        super.setUpViews()
        
        addSubview(photoImageView)
        photoImageView.fillOnSupperView()
        
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = 5
        photoImageView.layer.borderWidth = 0.2
        
        
    }
}
