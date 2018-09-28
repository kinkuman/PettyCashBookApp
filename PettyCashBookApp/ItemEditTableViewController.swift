//
//  ItemEditTableViewController.swift
//  PettyCashBookApp
//
//  Created by inagaki on 2018/09/28.
//  Copyright © 2018年 inagaki. All rights reserved.
//

import UIKit

class ItemEditTableViewController: UITableViewController {
    
    // データ取得先
    var dataManager:PettyCashDataManager! = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        // 品名
        guard let name = nameTextField.text else {
            nameTextField.placeholder = "必須項目です"
            return
        }
        
        // 価格
        guard let price = priceTextField.text else {
            priceTextField.placeholder = "必須項目です"
            return
        }
        
        if let numPrice = Int(price) {
            
            do {
                // insert処理
                try dataManager.insertData(name: name, price: numPrice)
                
                // 登録できたら入力内容を消す
                nameTextField.text = ""
                priceTextField.text = ""
            } catch {
                showAlert(message: "データベースへ登録ができません")
            }
            
        } else {
            priceTextField.text = ""
            priceTextField.placeholder = "数値で入力してください"
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // データベースを閉じる
        dataManager.close()
        print("dbとじました")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // データベースを開く
        dataManager = PettyCashDataManager()
        print("db開きました")
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UI用自作メソッド
    
    // アラート表示
    func showAlert(message:String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }

}
