//
//  AddPostViewController.swift
//  TryHarder
//
//  Created by Akhil Chaudhary on 09/10/20.
//


import UIKit


class AddPostViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate  {

    @IBOutlet weak var DescriptionTextView: UITextView!
    
    @IBOutlet weak var activtyIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var TitleTextView: UITextField!
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          
        self.imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    @IBAction func AddPostButton(_ sender: UIButton) {
    
        UploadPosttoServer()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DescriptionTextView.layer.borderWidth = 1
        DescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        DescriptionTextView.layer.cornerRadius = 3.0
        
        
               let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddPostViewController.imageTapped(gesture:)))

               // add it to the image view;
               imageView.addGestureRecognizer(tapGesture)
               // make sure imageView can be interacted with by user
               imageView.isUserInteractionEnabled = true
        
       
        
    }

    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
            // if the tapped view is a UIImageView then set it to imageview
            if (gesture.view as? UIImageView) != nil {

                let imageControl = UIImagePickerController()
                imageControl.delegate = self
                imageControl.sourceType = .photoLibrary
                self.present(imageControl, animated: true, completion: nil)

            }
        }

    
    

    
    func UploadPosttoServer()
    {
        
        let myUrl = NSURL(string: "http://legalnitsolutions.com/App/blogApp/add_blog.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "title"  : TitleTextView.text!,
            "content"    : DescriptionTextView.text!,
            "user"    : "kanha"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = imageView.image!.jpegData(compressionQuality: 3)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        activtyIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error?.localizedDescription))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json!)
                
                DispatchQueue.main.async {
                    self.activtyIndicator.stopAnimating()
                    self.imageView.image = UIImage(named: "place")
                }
                
                
            } catch
            {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
   }
   




extension NSMutableData {
      
       func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
       }
   }



