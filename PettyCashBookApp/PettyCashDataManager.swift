//
//  PettyCashDataManager.swift
//  SQLiteSample4
//
//  Created by user on 2018/09/27.
//  Copyright © 2018年 user. All rights reserved.
//

import UIKit

/// お小遣いデータベースアクセスのためのクラス
class PettyCashDataManager: NSObject {
    
    // データベース
    var db:FMDatabase!
    
    // イニシャライザ
    override init() {
        super.init()
        db = connectDatabase()
    }
    
    // データベース接続
    func connectDatabase() -> FMDatabase {
        //データベース名
        let databaseName = "my.db"
        
        //データベースファイルを格納するために文書フォルダーを取得
        let pathArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let workPath = pathArray[0]
        
        //データベースファイルへのパスを作成
        let databasePath = workPath + "/\(databaseName)"
        
        // データベース接続
        let db = FMDatabase(path: databasePath)
        
        // データベースを開く
        db.open()
        
        return db
    }
    
    // お小遣い帳テーブルの存在チェック
    func existPettyCashTable() -> Bool {
        return db.tableExists("pettycashbook")
    }
    
    // テーブルの作成
    func createPettyCashBookTable() throws {
        
        try db.executeUpdate("create table pettycashbook(id integer primary key,name text,price integer)", values: nil)
        
    }
    
    // selectの結果をItemの配列で返す
    func selectData() throws -> [Item] {
        // SQLを発行する
        
        var resultArray:[Item] = []
        
        let result = try db.executeQuery("select * from pettycashbook", values: nil)
        
        // 結果が得られた場合はカーソルを１行目に移動し
        while result.next() {
            
            // idを取得
            let id = result.long(forColumnIndex: 0)
            // nameを文字列で取得
            let name = result.string(forColumnIndex: 1)!
            // priceを整数で取得
            let price  = result.long(forColumnIndex: 2)
            
            let item = Item(id: id, name: name, price: price)
            
            // 結果配列に追加
            resultArray.append(item)
        }
        
        return resultArray
    }
    
    func insertData(name:String,price:Int) throws {
        
        // 新しいデータを１つ追加する
        try db.executeUpdate("insert into pettycashbook(name,price) values(?,?)", values: [name,price])
        
    }
    
    func deleteData(id:Int) throws {
        
        // 新しいデータを１つ追加する
        try db.executeUpdate("delete from pettycashbook where id = ?", values: [id])
        
    }
    
    func close() {
        db.close()
    }
}
