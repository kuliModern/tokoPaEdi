//
//  ViewController.swift
//  tokoPaEdi
//
//  Created by Azka Kusuma on 21/09/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // Table View
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private var models = [SellerProduct]()
    
    var seller = true
    var customerName = ""
    var sellerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)

        navigationController()
        getAllItem()
        getName()
        updateUI()
        
        // Do any additional setup after loading the view.
    }
    
    // navigation controller
    
    func navigationController(){
        let image = UIImage(systemName: "person.circle")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if seller == true{
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(profileButton))
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(profileButton))
            navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        
    }
    
    func updateUI(){
        if seller == true{
            title = "Your Product Catalogue"
        }
        else{
            title = "Welcome, \(customerName)"
        }
        
    }
    
    
    @objc func didTapAdd(){
        
        let alert = UIAlertController(title: "New Product", message: "Enter New Product", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit new Product", style: .cancel, handler: { [weak self] _ in
            
            guard let fieldname = alert.textFields?.first, let text = fieldname.text, !text.isEmpty else{
                return
            }
            
            self?.createItem(name: text)
            
        }))
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc func profileButton(){
        //self.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVC") as! ProfileViewController
        if seller == true{
            vc.sellerName = sellerName
        }
        else{
            vc.sellerName = customerName
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    //Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.product
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let item = models[indexPath.row]
        
        if seller == true{
            let sheet = UIAlertController(title: item.product, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                
                self.deleteItem(item: item)
                
            }))
            present(sheet, animated: true, completion: nil)
        }
    }
    
    
    // Core Data
    
    func getAllItem(){
        
        do {
            models = try context.fetch(SellerProduct.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            print("error")
        }
        
    }
    
    func getName(){
        
        if seller == true{
            for data in models {
                sellerName =  data.sellerName ?? ""
            }
        }
        else{
            for data in models{
                customerName =  data.customerName ?? ""
            }
            
        }
    }
    
    func createItem(name: String){
        
        let newItem = SellerProduct(context: context)
        newItem.product = name
        newItem.productDate = Date()
        
        do{
            try context.save()
            getAllItem()
        }
        catch{
            print("error save database")
        }
        
    }
    
    func deleteItem(item: SellerProduct){
        
        context.delete(item)
        
        do{
            try context.save()
            getAllItem()
        }
        
        catch{
            print("error deleting")
        }
        
    }
}

