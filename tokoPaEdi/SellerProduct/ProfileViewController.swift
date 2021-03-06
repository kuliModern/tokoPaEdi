//
//  ProfileViewController.swift
//  tokoPaEdi
//
//  Created by Azka Kusuma on 27/09/21.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var sellerName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonLogOut()
        // Do any additional setup after loading the view.
    }
    
    func buttonLogOut(){
        
        userName.text = sellerName
        
        let button = UIButton(frame: CGRect(x: 35, y: 550, width: 350, height: 50))
        button.backgroundColor = .red
        button.setTitle("Log Out", for: .normal)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    @objc func buttonDidTap(){
        print("logout pressed")
        
        navigationController?.popToRootViewController(animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
