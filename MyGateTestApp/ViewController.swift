//
//  ViewController.swift
//  MyGateTestApp
//
//  Created by Naresh on 02/02/19.
//  Copyright © 2019 Naresh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var profileTableView: UITableView!
    let vc = UIImagePickerController()
    var selectedImage: UIImage?
    var imagesArr : NSMutableArray = NSMutableArray()
    var namessArr : NSMutableArray = NSMutableArray()
    var passcodesArr : NSMutableArray  = NSMutableArray()
    var i = 0
    
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        vc.delegate = self
        vc.allowsEditing = true
        profileTableView.tableFooterView = UIView()
        profileTableView.alwaysBounceVertical = false
    }

    @IBAction func addBtnClicked(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            print("Button capture")
            vc.sourceType = .camera
            self.present(vc, animated: true, completion: nil)
        } else {
            print("Button capture")
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension ViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            picker.dismiss(animated: true, completion: nil)
        }
        
        if let image = selectedImage {
            imagesArr.add(image)
            passcodesArr.add(Int(generateRandomDigits(6))!)
             namessArr.add("User" + " " + "\(i)")
                i = i + 1
            
            let imageData = NSKeyedArchiver.archivedData(withRootObject: imagesArr)
            defaults.set(imageData, forKey: "images")
            defaults.set(namessArr, forKey: "namessArray")
            defaults.set(passcodesArr, forKey: "passcodeArray")
            defaults.synchronize()
        }
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profilecell_id", for: indexPath) as! ProfileTableViewCell
        
        let imageData = UserDefaults.standard.object(forKey: "images") as? NSData
        
        if let imageData = imageData {
            let imageArray = NSKeyedUnarchiver.unarchiveObject(with: imageData as Data) as! [UIImage]
            cell.profileImageView.image  = imageArray[indexPath.row]

        }
        let names = defaults.stringArray(forKey: "namessArray")
        let passcodes = defaults.array(forKey: "passcodeArray")
        cell.userNameLbl.text = names?[indexPath.row]
        cell.passcodeLbl.text =  "\(passcodes![indexPath.row])"
        return cell
    }
}

extension UIViewController {
    func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
}


extension UIView {
    func viewShadow(radius:CGFloat) {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = radius
    }
}

extension UIImageView {
    func roundedIamge() {
    self.layer.borderWidth = 0
    self.layer.masksToBounds = false
    self.layer.cornerRadius = self.frame.height/2
    self.clipsToBounds = true
    }
}


@IBDesignable extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

