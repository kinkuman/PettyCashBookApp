//
//  ViewController.swift
//  PettyCashBookApp
//
//  Created by inagaki on 2018/09/28.
//  Copyright © 2018年 inagaki. All rights reserved.
//

import UIKit

class PettyCashBookViewController: UITableViewController {

    // データ取得先
    var dataManager:PettyCashDataManager! = nil
    
    // データベースから得たデータ
    var data:[Item]!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // データベースを閉じる
        dataManager.close()
        print("dbとじました")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // データベースを開く
        dataManager = PettyCashDataManager()
        
        
        do {
            
            if dataManager.existPettyCashTable() == false {
                // お小遣い帳テーブルを作成する
                try dataManager.createPettyCashBookTable()
            }
            
            data = try dataManager.selectData()
            
            self.tableView.reloadData()
            
            print("db開きました")
            
        } catch {
            showAlert(message: "データベースの準備ができていません")
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        let item = data[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = String(item.price)
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            // 削除対象となるデータの取り出し
            let item = data[indexPath.row]
            
            // IDを得る
            do {
                try dataManager.deleteData(id: item.id)
                
                // データの再読み込み
                data = try dataManager.selectData()
                
                // テーブルビューに反映する
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                showAlert(message: "削除処理に失敗しました。")
            }
            
        }
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }

    
    // 移動機能を使うには並びの管理のための値が必要
//     // Override to support rearranging the table view.
//     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        // 移動元のデータを切り取り
//        let srcItem = data.remove(at: fromIndexPath.row)
//        // 切り取ったデータを挿入
//        data.insert(srcItem, at: to.row)
//     }
//
//    // Override to support conditional rearranging of the table view.
//    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
 
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellTap" {
            // セルのタップ時は値を渡す
            let next = segue.destination as! ItemEditTableViewController
            
            // 選択した行のrow
            let row = tableView.indexPathForSelectedRow!.row
            
            // 次の画面に渡す
            next.editItem = data[row]
        }
     }
    
    
    // MARK: - UI用自作メソッド
    
    // アラート表示
    func showAlert(message:String) {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
    }
    

}

