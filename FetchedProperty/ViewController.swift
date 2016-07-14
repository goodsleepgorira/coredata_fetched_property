//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var itemTextView: UITextView!
    
    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    
    //検証用データ（顧客）
    let customerList = [["近藤",true, 1]]
    
    //検証用データ（商品）
    let itemList = [[1, "さらさら化粧水", 2500],
                   [2, "しっとり化粧水", 1000],
                   [3, "化粧水まろやか", 1300]]

    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = applicationDelegate.managedObjectContext
        
        //検証用データを保存する。
        insertData()
        
        //顧客情報を表示する。
        displayCustomer()
        
    }


    //検証用データを保存するメソッド
    func insertData(){
        
        do {
            //管理オブジェクトコンテキストの中のオブジェクトの件数を取得する。。
            let fetchRequest = NSFetchRequest(entityName: "Customer")
            fetchRequest.resultType = .CountResultType
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Int]
            
            if(result[0] == 0){
                
                //検証用の商品データを保存する。
                for data in itemList {
                    let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedContext) as! Item
                    item.shubetsu = data[0] as? Int //商品種別
                    item.name = data[1] as? String  //商品名
                    item.price = data[2] as? Int    //価格
                }


                //検証用の顧客データを保存する。
                for data in customerList {
                    let customer = NSEntityDescription.insertNewObjectForEntityForName("Customer", inManagedObjectContext: managedContext) as! Customer
                    customer.name = data[0] as? String //名前
                    customer.sex = data[1] as? Bool    //性別
                    customer.hope = data[2] as? Int    //年齢
                }
                
                //管理オブジェクトコンテキストの中身を保存する。
                try managedContext.save()
            }
            
        } catch {
            print(error)
        }
    }



    //顧客情報表示メソッド
    func displayCustomer() {
        do {
            //顧客オブジェクトを取得する。。
            let fetchRequest = NSFetchRequest(entityName: "Customer")
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Customer]
            
            //ラベルに顧客情報を設定する。
            for data in result {
                nameLabel.text = data.name
                if(data.sex == true) {
                    sexLabel.text = "女性"
                } else {
                    sexLabel.text = "男性"
                }
            }
        } catch {
            print(error)
        }
    }


    //ボタン押下時の呼び出しメソッド
    @IBAction func pushButton(sender: UIButton) {
    }

}

