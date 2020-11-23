//
//  ViewController.swift
//  TryHarder
//
//  Created by Akhil Chaudhary on 09/10/20.
//

import UIKit
import Kingfisher


struct jsonStruct:Decodable{
    let title:String
    let pictures:String
    let description:String
}


class ViewController: UIViewController {

    
    var arrData = [jsonStruct]()
    
   
    @IBOutlet weak var tableDataView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableDataView.delegate = self

        tableDataView.dataSource = self
        
        
        tableDataView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "titleCell")
        
        getData()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func getData() {
        
        let url = URL(string:"http://legalnitsolutions.com/App/blogApp/allposts.php?allPosts")
        
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            do {
                if error == nil {
                   
                self.arrData = try JSONDecoder().decode([jsonStruct].self, from: data!)
                    
                    DispatchQueue.main.async {
                        self.tableDataView.reloadData()
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
            
        }.resume()

    }
    
}

extension ViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! MessageViewCell
        
        cell.delegate = self
        cell.indexNo = indexPath.row
        cell.labelSender.text = arrData[indexPath.row].title
        let url = URL(string: arrData[indexPath.row].pictures)
        cell.blogImage.kf.setImage(with: url)
        cell.DescriptionLabel.text = arrData[indexPath.row].description

        return cell
    }
    
   
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//    
    
}


extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsViewController") as? PostDetailsViewController
       // vc?.data = arrData[indexPath.row].title

        self.navigationController?.pushViewController(vc!, animated: true)
    }


}


extension ViewController: CellDelegate {
   
    func CallBtnTapped(tag: Int) {
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        vc.dicData = [0:arrData[tag].title,1:arrData[tag].description, 2:arrData[tag].pictures]
        self.navigationController!.pushViewController(vc, animated: true)

        
    }
    

}

