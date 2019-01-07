//
//  File.swift
//  No data
//
//  Created by indrajit on 21/08/18.
//  Copyright © 2018 Indrajit. All rights reserved.
//

import UIKit


extension UIView{
    
    func showNoDataLabel(title:String,subTitle:String,image:UIImage,sizeOfImageView:CGFloat = 90){
        
        removeNoDataLabel()
        
        let containerView = UIView()
        containerView.tag = 1210
        containerView.backgroundColor = .white
        
        addSubview(containerView)
        containerView.centerOnYOrX(x: true, y: true)
        containerView.fillOnSupperView()
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.clipsToBounds = true
        
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.tag = 1210
        label.numberOfLines = 0
        
        let attr = NSMutableAttributedString()
        attr.append(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.darkGray]))
        attr.append(NSAttributedString(string: "\n"+subTitle, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.alignment = .center
        attr.addAttributes([NSAttributedString.Key.paragraphStyle:paragraphStyle], range: NSMakeRange(0, attr.length))
        
        label.attributedText = attr
        
        
        containerView.addSubview(imageView)
        containerView.addSubview(label)
        
        imageView.setHieghtOrWidth(height: sizeOfImageView, width: sizeOfImageView)
        imageView.centerOnYOrX(x: true, y: true, xConst: 0, yConst:0)
        
        label.centerOnYOrX(x: true, y: nil)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        
        
    }
    
    func removeNoDataLabel(){
        for view in subviews{
            if view.tag == 1210{
                view.removeFromSuperview()
                break
            }
        }
    }
    
    
    func anchors(left:NSLayoutXAxisAnchor?,right:NSLayoutXAxisAnchor?,top:NSLayoutYAxisAnchor?,bottom:NSLayoutYAxisAnchor?,leftConstant:CGFloat = 0,rightConstant:CGFloat = 0,topConstant:CGFloat = 0,bottomCosntant:CGFloat = 0){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let leftAnchor = left{
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstant).isActive = true
        }
        
        if let rightAnchor = right{
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: rightConstant).isActive = true
        }
        
        if let topAnchor = top{
            self.topAnchor.constraint(equalTo: topAnchor, constant: topConstant).isActive = true
        }
        
        if let bottomAnchor = bottom{
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomCosntant).isActive = true
        }
    }
    
    
    func fillOnSupperView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let subperView = self.superview{
            self.leftAnchor.constraint(equalTo: subperView.leftAnchor, constant: 0).isActive = true
            self.rightAnchor.constraint(equalTo: subperView.rightAnchor, constant: 0).isActive = true
            self.topAnchor.constraint(equalTo: subperView.topAnchor, constant: 0).isActive = true
            self.bottomAnchor.constraint(equalTo: subperView.bottomAnchor, constant: 0).isActive = true
        }
    }
    
    func centerOnSuperView(constantX:CGFloat = 0 , constantY:CGFloat = 0 ){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let subperView = self.superview{
            self.centerXAnchor.constraint(equalTo: subperView.centerXAnchor, constant: constantX).isActive = true
            self.centerYAnchor.constraint(equalTo: subperView.centerYAnchor, constant: constantY).isActive = true
        }
    }
    
    
    
    func setHieghtOrWidth(height:CGFloat?,width:CGFloat?){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let heightConst = height{
            self.heightAnchor.constraint(equalToConstant: heightConst).isActive = true
        }
        if let widthAnchor = width{
            self.widthAnchor.constraint(equalToConstant: widthAnchor).isActive = true
        }
    }
    
    
    func centerOnYOrX(x:Bool?,y:Bool?,xConst:CGFloat=0,yConst:CGFloat=0){
        self.translatesAutoresizingMaskIntoConstraints = false
        if x != nil && y != nil{
            
            self.centerOnSuperView(constantX: xConst , constantY: yConst)
        }else if x != nil{
            self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor, constant: xConst ).isActive = true
        }else if y != nil{
            self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor, constant: yConst).isActive = true
        }
        
        
        
    }
    
    
}

extension UIColor{
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
