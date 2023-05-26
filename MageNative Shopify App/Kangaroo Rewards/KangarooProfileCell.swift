//
//  KangarooProfileCell.swift
//  MageNative Shopify App
//
//  Created by cedcoss on 09/04/23.
//  Copyright © 2023 MageNative. All rights reserved.
//

import UIKit
import FSCalendar
class KangarooProfileCell: UICollectionViewCell {
    static let reuseID = "KangarooProfileCell"
    var updateTapped: (()->())?
    let tempView = UIView()
    let screenSize: CGRect = UIScreen.main.bounds;
    var parent : UIViewController?
    var calendarView = UIDatePicker()//: CalendarView!
    static let textColor = UIColor(light: UIColor(hexString: "#050505", alpha: 1),dark: UIColor.provideColor(type: .newLoginVC).textColor)
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.textAlignment = .left
        label.textColor = textColor
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = textColor
        textfield.font = mageFont.mediumFont(size: 14)
        textfield.setLeftPaddingPoints(15)
        textfield.setRightPaddingPoints(15)
        textfield.keyboardType = .default
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "First Name"
        textfield.layer.cornerRadius = 8
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        return textfield
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.textAlignment = .left
        label.textColor = textColor
        return label
    }()
    
    let lastNameTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = textColor
        textfield.font = mageFont.mediumFont(size: 14)
        textfield.setLeftPaddingPoints(15)
        textfield.setRightPaddingPoints(15)
        textfield.keyboardType = .default
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "Last Name"
        textfield.layer.cornerRadius = 8
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        return textfield
    }()
    
    let emailLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Email Address"
        label.textAlignment = .left
        label.textColor = textColor
        return label
    }()
    
    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = textColor
        textfield.font = mageFont.mediumFont(size: 14)
        textfield.setLeftPaddingPoints(15)
        textfield.setRightPaddingPoints(15)
        textfield.keyboardType = .emailAddress
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.layer.cornerRadius = 8
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "Email Address"
        return textfield
    }()
    
    let dobLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of Birth"
        label.textAlignment = .left
        label.textColor = textColor
        return label
    }()
    
    lazy var dobTextField: UITextField = {
        let textfield = UITextField()
        textfield.textColor = KangarooProfileCell.textColor
        textfield.font = mageFont.mediumFont(size: 14)
        textfield.setLeftPaddingPoints(15)
        textfield.setRightPaddingPoints(15)
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.placeholder = "Date of Birth"
        textfield.layer.cornerRadius = 8
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 1
        return textfield
    }()
    
    lazy var updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Update", for: .normal)
        button.backgroundColor = .AppTheme()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = mageFont.mediumFont(size: 14)
        button.addTarget(self, action: #selector(handleUpdate), for: .touchUpInside)
        button.titleLabel?.textColor = KangarooProfileCell.textColor
        return button
    }()
    
    lazy var checkSMSButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.tintColor = UIColor.AppTheme()
        button.addTarget(self, action: #selector(smsButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var smsText : UILabel = {
        let label = UILabel()
        label.text = "I would like to receive promotions by SMS".localized
        label.textColor = UIColor.AppTheme()
        return label
    }()
    
    
    lazy var emailText : UILabel = {
        let label = UILabel()
        label.text = "I would like to receive promotions by email".localized
        label.textColor = UIColor.AppTheme()
        return label
    }()
    
    lazy var checkEmailButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "unchecked"), for: .normal)
        button.tintColor = UIColor.AppTheme()
        button.addTarget(self, action: #selector(emailButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    var smsCheck = false
    var emailCheck = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        setupContentLayout(view: firstNameLabel, previousView: contentView, paddingTop: 20)
        setupContentLayout(view: firstNameTextField, previousView: firstNameLabel, paddingTop: 0)
        
        setupContentLayout(view: lastNameLabel, previousView: firstNameTextField, paddingTop: 16)
        setupContentLayout(view: lastNameTextField, previousView: lastNameLabel, paddingTop: 0)
        
        setupContentLayout(view: emailLabel, previousView: lastNameTextField, paddingTop: 16)
        setupContentLayout(view: emailTextField, previousView: emailLabel, paddingTop: 0)
        
        setupContentLayout(view: dobLabel, previousView: emailTextField, paddingTop: 16)
        setupContentLayout(view: dobTextField, previousView: dobLabel, paddingTop: 0)
        addEmailView()
        addSMSView()
        
        setupContentLayout(view: updateButton, previousView: smsText, paddingTop: 20)
        
        
        dobTextField.delegate = self
    }
    
    
    private func addEmailView() {
        contentView.addSubview(checkEmailButton)
        contentView.addSubview(emailText)
        
        checkEmailButton.anchor(top: dobTextField.bottomAnchor, left: contentView.leadingAnchor, paddingTop: 16, paddingLeft: 16, width: 30, height: 30)
        emailText.anchor(top: dobTextField.bottomAnchor, left: checkEmailButton.trailingAnchor, right: contentView.trailingAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 30)
    }
    
    private func addSMSView() {
        contentView.addSubview(checkSMSButton)
        contentView.addSubview(smsText)
        
        checkSMSButton.anchor(top: checkEmailButton.bottomAnchor, left: contentView.leadingAnchor, paddingTop: 16, paddingLeft: 16, width: 30, height: 30)
        smsText.anchor(top: emailText.bottomAnchor, left: checkSMSButton.trailingAnchor, right: contentView.trailingAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 30)
    }
    
    private func setupContentLayout(view: UIView, previousView: UIView, paddingTop: CGFloat) {
        contentView.addSubview(view)
        if previousView == contentView {
            view.anchor(top: previousView.topAnchor, left: contentView.leadingAnchor, right: contentView.trailingAnchor, paddingTop: paddingTop, paddingLeft: 16, paddingRight: 16, height: 20)
        }
        else {
            view.anchor(top: previousView.bottomAnchor, left: contentView.leadingAnchor, right: contentView.trailingAnchor, paddingTop: paddingTop, paddingLeft: 16, paddingRight: 16, height: 44)
        }
    }
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.dobTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.dobTextField.text = dateFormatter.string(from: datePicker.date)
        }
        self.dobTextField.resignFirstResponder()
    }
    
    @objc func handleUpdate() {
        self.updateTapped?()
    }
    
    @objc func smsButtonClicked(_ sender : UIButton) {
        self.smsCheck.toggle()
        if smsCheck {
            sender.setImage(UIImage(named: "checked"), for: .normal)
        }
        else {
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    @objc func emailButtonClicked(_ sender : UIButton) {
        emailCheck.toggle()
        if emailCheck {
            sender.setImage(UIImage(named: "checked"), for: .normal)
        }
        else {
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension KangarooProfileCell {
    func setupData(customer: KanagrooCustomerData?,consentData:KangarooGetCustomerConsentData?) {
        if let firstName = customer?.firstName {
            self.firstNameTextField.text = firstName
            self.firstNameTextField.isUserInteractionEnabled = false
        }
        if let lastName = customer?.lastName {
            self.lastNameTextField.text = lastName
            self.lastNameTextField.isUserInteractionEnabled = false
        }
        
        if let email = customer?.email {
            self.emailTextField.text = email
            self.emailTextField.isUserInteractionEnabled = false
        }
        if let dob = customer?.birthDate {
            self.dobTextField.text = dob
        }
        if let emailConsent = consentData?.allowEmail {
            if emailConsent {
                self.emailCheck = emailConsent
                self.checkEmailButton.setImage(UIImage(named: "checked"), for: .normal)
            }
           
        }
        if let smsConsent = consentData?.allowSMS {
            if smsConsent {
                self.smsCheck = smsConsent
                self.checkSMSButton.setImage(UIImage(named: "checked"), for: .normal)
            }
            
        }
    }
}

extension KangarooProfileCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        addInputViewDatePicker()
    }
    
    func addInputViewDatePicker() {
    /*    calendarView = CalendarView(frame: CGRect(x: 0, y: 0 , width: self.contentView.frame.width - 20, height: 250))
        calendarView.center = CGPoint(x: self.contentView.frame.size.width  / 2, y: self.frame.size.height/2 - 60)//self.view.center
        contentView.addSubview(calendarView)
        calendarView.calendar.delegate = self
        calendarView.calendar.dataSource = self
        calendarView.tag = 1221;
        calendarView.headingLabel.text = "SELECT DATE".localized
        calendarView.doneBtn.setTitle("DONE".localized, for: .normal)
        calendarView.cancelBtn.setTitle("CANCEL".localized, for: .normal)
        calendarView.headingLabel.font = mageFont.mediumFont(size: 16.0)
        calendarView.doneBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        calendarView.cancelBtn.titleLabel?.font = mageFont.mediumFont(size: 15.0)
        calendarView.cancelBtn.addTarget(self, action: #selector(cancelBtnPressed), for: .touchUpInside)
        calendarView.view.layer.borderWidth = 1.0
        calendarView.view.layer.borderColor = UIColor(light: .black, dark: .white).cgColor
        calendarView.doneBtn.addTarget(self, action: #selector(dateSelected), for: .touchUpInside)
        calendarView.becomeFirstResponder()  */
        
        
        print("clicked")
        if #available(iOS 14.0, *) {
            calendarView.preferredDatePickerStyle = .inline
        } else {
            // Fallback on earlier versions
        }
        
    tempView.frame = UIScreen.main.bounds;
    
    tempView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight , UIView.AutoresizingMask.flexibleWidth];
    tempView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.5);
        let dismissBtn = UIButton()
        dismissBtn.frame = UIScreen.main.bounds
        dismissBtn.addTarget(self, action: #selector(backgroundClicked(_:)), for: .touchUpInside)
        self.parent?.view.addSubview(tempView)
        tempView.addSubview(dismissBtn)
    
    let tempInrView = UIView();
    tempInrView.frame = CGRect(x: 0, y: CGFloat(0), width: screenSize.width-50,height: CGFloat(300));
    tempInrView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight , UIView.AutoresizingMask.flexibleWidth];
    tempInrView.backgroundColor = UIColor.white;
    tempInrView.center = CGPoint(x: tempView.frame.size.width / 2,
                                 y: tempView.frame.size.height/2);
    tempInrView.layer.borderColor = UIColor.blue.cgColor
    tempInrView.layer.borderWidth = 1.5
    tempView.addSubview(tempInrView)
    
    calendarView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin,UIView.AutoresizingMask.flexibleRightMargin];
        calendarView.frame = CGRect(x: 0, y: CGFloat(0), width: tempInrView.frame.width,height: CGFloat(300));
    tempInrView.addSubview(calendarView)
        calendarView.datePickerMode = UIDatePicker.Mode.date;
        calendarView.setValue(UIColor.black, forKeyPath: "textColor");
        calendarView.backgroundColor = UIColor.white;
        calendarView.maximumDate = Date()
        calendarView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)

        calendarView.locale = Locale(identifier: "en")
        
    }
    
    @objc func backgroundClicked(_ sender:UIButton){
        tempView.removeFromSuperview()
    }
    
    @objc func datePickerValueChanged(_ sender : UIDatePicker) {
        let date = calendarView.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        self.dobTextField.text = dateString
         tempView.removeFromSuperview()
    }
    
    @objc func cancelBtnPressed() {
        self.calendarView.removeFromSuperview()
    }
    
    @objc func dateSelected() {
        self.calendarView.removeFromSuperview()
    }
}
/*
extension KangarooProfileCell: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        let dateString = dateFormatter.string(from: date)
        self.dobTextField.text = dateString
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
*/
