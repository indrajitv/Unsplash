//
//  File.swift
//  PickerView
//
//  Created by indrajit on 11/08/18.


import UIKit
class CustomPickerView:NSObject,UIPickerViewDelegate,UIPickerViewDataSource{
    
    
    //Theme colors
    var itemTextColor = UIColor.black
    var backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    var toolBarColor = UIColor.blue
    var font = UIFont.systemFont(ofSize: 16)
    
    private static var shared:CustomPickerView!
    var bottomAnchorOfPickerView:NSLayoutConstraint!
    var heightOfPickerView:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 160 : 120
    var heightOfToolbar:CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 50 : 40
    
    var dataSource:(items:[String]?,itemIds:[String]?)
    
    typealias CompletionBlock = (_ item:String?,_ id:String?) -> Void
    var didSelectCompletion:CompletionBlock?
    var doneBottonCompletion:CompletionBlock?
    var cancelBottonCompletion:CompletionBlock?
    
    
    lazy var pickerView:UIPickerView={
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.delegate = self
        pv.dataSource = self
        pv.showsSelectionIndicator = true
        pv.backgroundColor = self.backgroundColor
        return pv
    }()
    
    lazy var disablerView:UIView={
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var tooBar:UIView={
        let view = UIView()
        view.backgroundColor = self.toolBarColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonDone)
        buttonDone.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        buttonDone.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        buttonDone.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        buttonDone.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        view.addSubview(buttonCancel)
        buttonCancel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        buttonCancel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        buttonCancel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        buttonCancel.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        return view
    }()
    
    
    lazy var buttonDone:UIButton={
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.tintColor = self.itemTextColor
        button.titleLabel?.font = self.font
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.buttonDoneClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var buttonCancel:UIButton={
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = self.itemTextColor
        button.titleLabel?.font = self.font
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.addTarget(self, action: #selector(self.buttonCancelClicked), for: .touchUpInside)
        return button
    }()
    
    
    static func show(items:[String],itemIds:[String]? = nil,selectedValue:String? = nil,doneBottonCompletion:CompletionBlock?,didSelectCompletion:CompletionBlock?,cancelBottonCompletion:CompletionBlock?){
        
        if CustomPickerView.shared == nil{
            shared = CustomPickerView()
        }else{
            return
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,let keyWindow = appDelegate.window {
            
            shared.cancelBottonCompletion = cancelBottonCompletion
            shared.didSelectCompletion = didSelectCompletion
            shared.doneBottonCompletion = doneBottonCompletion
            shared.dataSource.items = items
            
            if let idsVal = itemIds,items.count == idsVal.count{ //ids can not be less or more than items
                shared?.dataSource.itemIds  = itemIds
            }
            
            shared?.heightOfPickerView += shared.heightOfToolbar
            
            keyWindow.addSubview(shared.disablerView)
            shared.disablerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 0).isActive = true
            shared.disablerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: 0).isActive = true
            shared.disablerView.topAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0).isActive = true
            shared.disablerView.bottomAnchor.constraint(equalTo: keyWindow.bottomAnchor, constant: 0).isActive = true
            
            
            shared.disablerView.addSubview(shared.pickerView)
            shared.pickerView.leftAnchor.constraint(equalTo: shared.disablerView.leftAnchor, constant: 0).isActive = true
            shared.pickerView.rightAnchor.constraint(equalTo: shared.disablerView.rightAnchor, constant: 0).isActive = true
            shared.pickerView.heightAnchor.constraint(equalToConstant: shared.heightOfPickerView).isActive = true
            shared.bottomAnchorOfPickerView = shared.pickerView.topAnchor.constraint(equalTo: shared.disablerView.bottomAnchor, constant: 0)
            shared.bottomAnchorOfPickerView.isActive = true
            
            
            shared.disablerView.addSubview(shared.tooBar)
            shared.tooBar.heightAnchor.constraint(equalToConstant: shared.heightOfToolbar).isActive = true
            shared.tooBar.leftAnchor.constraint(equalTo: shared.disablerView.leftAnchor, constant: 0).isActive = true
            shared.tooBar.rightAnchor.constraint(equalTo: shared.disablerView.rightAnchor, constant: 0).isActive = true
            shared.tooBar.bottomAnchor.constraint(equalTo: shared.pickerView.topAnchor, constant: 0).isActive = true
            
            keyWindow.layoutIfNeeded()
            
            
            if let selectedVal = selectedValue{
                for (index,itemName) in items.enumerated(){
                    if itemName.lowercased() == selectedVal.lowercased(){
                        shared.pickerView.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                }
            }
            
            shared.bottomAnchorOfPickerView.constant = -shared.heightOfPickerView
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                keyWindow.layoutIfNeeded()
                shared.disablerView.alpha = 1
            }) { (bool) in  }
            
        }
    }
    
    
    //MARK: Picker datasource delegates
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let count = dataSource.items?.count{
            return count
        }
        return 0
    }
    
    
    
    //MARK: Picker delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if let names = dataSource.items{
            return names[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if let names = dataSource.items{
            let item = names[row]
            return NSAttributedString(string: item, attributes: [NSAttributedString.Key.foregroundColor : itemTextColor,NSAttributedString.Key.font : font])
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var itemName:String?
        var id:String?
        
        if let names = dataSource.items{
            itemName = names[row]
        }
        if let ids = dataSource.itemIds{
            id = ids[row]
        }
        self.didSelectCompletion?(itemName, id)
    }
    
    
    
    @objc func buttonDoneClicked(){
        self.hidePicker(handler: doneBottonCompletion)
    }
    
    @objc func buttonCancelClicked(){
        
        self.hidePicker(handler: cancelBottonCompletion)
    }
    
    func hidePicker(handler:CompletionBlock?){
        var itemName:String?
        var id:String?
        let row = self.pickerView.selectedRow(inComponent: 0)
        if let names = dataSource.items{
            itemName = names[row]
        }
        if let ids = dataSource.itemIds{
            id = ids[row]
        }
        handler?(itemName, id)
        
        bottomAnchorOfPickerView.constant = self.heightOfPickerView
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.disablerView.window!.layoutIfNeeded()
            self.disablerView.alpha = 0
        }) { (bool) in
            self.disablerView.removeFromSuperview()
            CustomPickerView.shared = nil
        }
    }
    
}


class AlertView{
    
    static func show(title:String? = nil,message:String?,preferredStyle: UIAlertController.Style = .alert,buttons:[String] = ["Ok"],completionHandler:@escaping (String)->Void){
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for button in buttons{
            
            var style = UIAlertAction.Style.default
            let buttonText = button.lowercased().replacingOccurrences(of: " ", with: "")
            if buttonText == "cancel"{
                style = .cancel
            }
            let action = UIAlertAction(title: button, style: style) { (_) in
                completionHandler(button)
            }
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            if let app = UIApplication.shared.delegate as? AppDelegate, let rootViewController = app.window?.rootViewController {
                rootViewController.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}


@IBDesignable
open class CustomTextField:UITextField{
    
    private var labelPlaceholderTitleTop:NSLayoutConstraint!
    private var labelPlaceholderTitleCenterY:NSLayoutConstraint!
    private var labelPlaceholderTitleLeft:NSLayoutConstraint!
    
    @IBInspectable var allowToShrinkPlaceholderSizeOnEditing = true
    @IBInspectable var shrinkSizeOfPlaceholder:CGFloat = 0
    
    @IBInspectable var placeHolderColor:UIColor = .lightGray{
        didSet{
            labelPlaceholderTitle.textColor = placeHolderColor
        }
    }
    open override var font: UIFont?{
        didSet{
            labelPlaceholderTitle.font = font
        }
    }
    @IBInspectable var heightOfBottomLine:CGFloat = 1{
        didSet{
            heightAnchorOfBottomLine.constant = heightOfBottomLine
        }
    }
    
    open override var leftView: UIView?{
        didSet{
            if let lv = leftView{
                labelPlaceholderTitleLeft.constant = lv.frame.width+leftPadding
            }
        }
    }
    
    @IBInspectable var leftPadding:CGFloat = 0{
        didSet{
            labelPlaceholderTitleLeft.constant = leftPadding
        }
    }
    
    
    @IBInspectable var errorText:String = ""{
        didSet{
            self.labelError.text = errorText
        }
    }
    @IBInspectable var errorColor:UIColor = .red{
        didSet{
            labelError.textColor = errorColor
        }
    }
    @IBInspectable var errorFont:UIFont = UIFont.systemFont(ofSize: 10){
        didSet{
            self.labelError.font = errorFont
        }
    }
    
    @IBInspectable var shakeIntensity:CGFloat = 5
    
    private var heightAnchorOfBottomLine:NSLayoutConstraint!
    
    lazy var labelPlaceholderTitle:UILabel={
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = self.font
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var labelError:UILabel={
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = self.errorText
        label.textAlignment = .right
        label.font = self.errorFont
        label.textColor = errorColor
        return label
    }()
    
    let bottonLineView:UIView={
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initalSetup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initalSetup()
    }
    
    override open func prepareForInterfaceBuilder() {
        self.initalSetup()
    }
    
    open override func awakeFromNib() {
        self.labelError.isHidden = true
    }
    
    func initalSetup(){
        
        self.labelPlaceholderTitle.text = placeholder
        placeholder = nil
        borderStyle = .none
        bottonLineView.removeFromSuperview()
        
        addSubview(bottonLineView)
        bottonLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bottonLineView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bottonLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        heightAnchorOfBottomLine = bottonLineView.heightAnchor.constraint(equalToConstant: heightOfBottomLine)
        heightAnchorOfBottomLine.isActive = true
        
        addSubview(labelPlaceholderTitle)
        labelPlaceholderTitleLeft = labelPlaceholderTitle.leftAnchor.constraint(equalTo: leftAnchor, constant: leftPadding)
        labelPlaceholderTitleLeft.isActive = true
        labelPlaceholderTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        labelPlaceholderTitleTop = labelPlaceholderTitle.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        labelPlaceholderTitleTop.isActive = false
        
        labelPlaceholderTitleCenterY = labelPlaceholderTitle.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        labelPlaceholderTitleCenterY.isActive = true
        
        
        addSubview(labelError)
        labelError.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        labelError.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        labelError.topAnchor.constraint(equalTo: bottonLineView.bottomAnchor, constant: 2).isActive = true
        
        
        addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        
        
    }
    
    
    @objc func textFieldDidChange(){
        
        func animateLabel(){
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
        
        if let enteredText = text,enteredText != ""{
            if labelPlaceholderTitleCenterY.isActive{
                labelPlaceholderTitleCenterY.isActive = false
                labelPlaceholderTitleTop.isActive = true
                labelPlaceholderTitleTop.constant = -5
                if allowToShrinkPlaceholderSizeOnEditing{
                    let currentFont = font == nil ? UIFont.systemFont(ofSize: 16) : font!
                    let shrinkSize = shrinkSizeOfPlaceholder == 0 ? currentFont.pointSize-3 : shrinkSizeOfPlaceholder
                    labelPlaceholderTitle.font = UIFont.init(descriptor: currentFont.fontDescriptor, size:shrinkSize)
                }
                animateLabel()
            }
        }else{
            labelPlaceholderTitleCenterY.isActive = true
            labelPlaceholderTitleTop.isActive = false
            labelPlaceholderTitleTop.constant = 0
            labelPlaceholderTitle.font = font
            animateLabel()
        }
    }
    
    
    
    @objc public func showError(){
        self.labelError.isHidden = false
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - shakeIntensity, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + shakeIntensity, y: center.y))
        layer.add(animation, forKey: "position")
    }
    
    @objc public func hideError(){
        self.labelError.isHidden = true
    }
    
}
