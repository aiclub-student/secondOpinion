
// ViewController.swift
// Animal App
//
// Created by Diya Sreedhar on 8/26/21.
//
import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    @IBOutlet weak var buttonMain: UIButton!
    @IBOutlet weak var Result1: UIImageView!
    @IBOutlet weak var Result2: UIImageView!
    
    var APIResult1: String?
    var APIResult2: String?
    let map1=["Cats":"survive1","Dogs":"survive2","Unknown":"survive3"]
    let map2=["Cats":"kps1","Dogs":"kps2","Unknown":"kps3"]
    
    struct AIResponse: Decodable {
        let predicted_label: String?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //buttonMain.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        //buttonMain.backgroundColor = UIColor.blue
       buttonMain.layer.cornerRadius = 25.0
       buttonMain.tintColor = UIColor.systemRed
       scrollView.contentSize=CGSize(width: scrollView.bounds.width, height: scrollView.bounds.height*1.5)
        //scrollView.visibleSize=CGSize(width: view.frame.size.width, height: 1.5*view.frame.size.width)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        print("Button pressed")
        let vc = UIImagePickerController()
        //vc.sourceType = .camera
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        buttonMain.isHidden = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage else {
            print("An error occured: no image found")
            return
        }
        // print out the image size as a test
        imageMain.image = image
        print(image.size)
        let imageJPG = image.jpegData(compressionQuality: 0.0034)
        processAPI1(image:imageJPG!)
        processAPI2(image:imageJPG!)
    }
    
    func processAPI1(image: Data) {
        print("In API1")
        let imageB64 = Data(image).base64EncodedData()
        let uploadURL = "https://askai.aiclub.world/7e4c02bb-b102-4d19-b2ee-37fe26b92e68"
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            //debugPrint("Response is:",response)
            switch response.result {
            case .success(let responseJsonStr):
                print("\n\n API 1: Success value and JSON: \(responseJsonStr)")
                
                let myJson = JSON(responseJsonStr)
                let predictedValue = myJson["predicted_label"].string
                print("API1: Saw predicted value \(String(describing: predictedValue))")
                let predictionMessage = "Animal Name: " + predictedValue!
                self.Result1.image=UIImage(named: self.map1[predictedValue!]!)
            case .failure(let error):
                print("\n\n API1: Request failed with error: \(error)")
            }
            self.buttonMain.isHidden = false
        }
        print("Exiting API1")
    }
    
    func processAPI2(image: Data) {
        print("In API2")
        let imageB64 = Data(image).base64EncodedData()
        let uploadURL = "https://askai.aiclub.world/7e4c02bb-b102-4d19-b2ee-37fe26b92e68"
        AF.upload(imageB64, to: uploadURL).responseJSON { response in
            //debugPrint("Response is:",response)
            switch response.result {
            case .success(let responseJsonStr):
                print("\n\n API2: Success value and JSON: \(responseJsonStr)")
                let myJson = JSON(responseJsonStr)
                let predictedValue = myJson["predicted_label"].string
                print("API2: Saw predicted value \(String(describing: predictedValue))")
                let predictionMessage = "Animal Name: " + predictedValue!
                self.Result2.image=UIImage(named: self.map2[predictedValue!]!)
            case .failure(let error):
                print("\n\n API2: Request failed with error: \(error)")
            }
            self.buttonMain.isHidden = false
        }
        print("Exiting API2")
    }
}

