//
//  TestTableViewController.swift
//

import UIKit
import CoreData

class TestTableViewController: UITableViewController {

    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!

    //検索結果配列
    var searchResult = [Item]()
 
       

    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = applicationDelegate.managedObjectContext

        //検索結果配列にデータを格納する。
        makeSearchResult()
        
        //テーブルビューを再読み込みする。
        self.tableView.reloadData()

    }


    //検索結果配列作成メソッド
    func makeSearchResult() {
        
        //検索結果配列を空にする。
        searchResult.removeAll()
        
        //フェッチリクエストのインスタンスを生成する。
        let fetchRequest = NSFetchRequest(entityName: "Item")
        
        do {
            //フェッチリクエストを実行する。
            searchResult = try managedContext.executeFetchRequest(fetchRequest) as! [Item]
            
        } catch {
            print(error)
        }
    }
    

    //データの個数を返すメソッド
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }


    //データを返すメソッド
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //セルを取得する。
        let cell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath:indexPath) as UITableViewCell
        
        //セルのラベルに商品情報を設定する。
        let item = searchResult[indexPath.row]
        cell.textLabel?.text = "\(item.name!)　\(item.price!)円"
        
        return cell
    }
    
    
    
    //編集可否を答えるメソッド
    override func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        //すべての行を編集可能にする。
        return true
    }
    

    //テーブルビュー編集時の呼び出しメソッド
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            do {
                //選択行のオブジェクトを管理オブジェクトコンテキストから取得する。
                let fetchRequest = NSFetchRequest(entityName: "Item")
                fetchRequest.predicate = NSPredicate(format:"name = %@", searchResult[indexPath.row].name!)
                
                if let result = try managedContext.executeFetchRequest(fetchRequest) as? [Item] {
                    
                    //検索結果配列から選択行のオブジェクトを削除する。
                    searchResult.removeAtIndex(indexPath.row)
                    
                    //テーブルビューから選択行を削除する。
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                    
                    //管理オブジェクトコンテキストから選択行のオブジェクトを削除する。
                    managedContext.deleteObject(result[0])
                    
                    //管理オブジェクトコンテキストの中身を保存する。
                    try managedContext.save()
                }
            } catch {
                print(error)
            }
        }
    }

}
