//
//  MyImageView.swift
//  Unsplash
//
//  Created by indrajit-mac on 31/12/18.
//  Copyright © 2018 IND. All rights reserved.
//

import UIKit


var asyncImagesCashArray = NSCache<NSString, UIImage>()

class MyImageView: UIImageView {
    
    
 
    private var currentURL: NSString?
    var currentDownloadingUrls = [String]()
    var zoomImageView,originalImageView:MyImageView!
    var blackBackgroundView:UIView!
 
    
    
    func loadAsyncFrom(url: String, placeholder: UIImage?) {
       
        let imageURL = url as NSString
        
        if let cashedImage = asyncImagesCashArray.object(forKey: imageURL) {
            image = cashedImage
            return
        }
        image = placeholder
        currentURL = imageURL
       
        guard let requestURL = URL(string: url) else { image = placeholder; return }
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                if error == nil,let imageData = data,let currentImgurl = self?.currentURL,currentImgurl == imageURL, let imageToPresent = UIImage(data: imageData) {
                    self?.image = imageToPresent
                    asyncImagesCashArray.setObject(imageToPresent, forKey: imageURL)
                }else{
                    self?.image = placeholder
                }
            }
            }.resume()
    }
    
    
    
    
    func animateImageView(replaceImageInZoomMode:String? = nil) {
        self.originalImageView = self
        
        if let startingFrame = self.superview?.convert(self.frame, to: nil),let appDelegate = UIApplication.shared.delegate as? AppDelegate,let window = appDelegate.window {
            
            self.alpha = 0
            
            blackBackgroundView = UIView()
            window.addSubview(blackBackgroundView)
            blackBackgroundView.fillOnSupperView()
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            
            
            zoomImageView = MyImageView()
            zoomImageView.backgroundColor = UIColor.black
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.contentMode = .scaleAspectFit
            zoomImageView.image = self.image
            zoomImageView.clipsToBounds = true
            window.addSubview(zoomImageView)
            if let newUrl = replaceImageInZoomMode{
                zoomImageView.loadAsyncFrom(url: newUrl, placeholder: self.image)
            }
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.zoomOut)))
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                
                let height = (window.frame.width / startingFrame.width) * startingFrame.height
                
                let y = window.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width:window.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
                
            }, completion: nil)
            
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = originalImageView!.superview?.convert(originalImageView!.frame, to: nil){
            
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                
            }, completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.originalImageView?.alpha = 1
            })
            
        }
    }
}
