//
//  ViewController.swift
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var itemTextView: UITextView!
    
    //管理オブジェクトコンテキスト
    var managedContext:NSManagedObjectContext!
    
    //検証用データ（著者）
    let authorList = [["杉田真",false, 32]]
    
    //著者オブジェクト
    var author:Author!
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //管理オブジェクトコンテキストを取得する。
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = applicationDelegate.managedObjectContext
        
        //検証用データを保存する。
        insertData()
        
        //著者情報を表示する。
        displayCustomer()
        
    }


    //検証用データを保存するメソッド
    func insertData(){
        
        do {
            //著者オブジェクトの件数を取得する。。
            let fetchRequest = NSFetchRequest(entityName: "Author")
            fetchRequest.resultType = .CountResultType
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Int]
            
            if(result[0] == 0){
                
                //検証用の著者データを保存する。
                for data in authorList {
                    let author = NSEntityDescription.insertNewObjectForEntityForName("Author", inManagedObjectContext: managedContext) as! Author
                    author.name = data[0] as? String  //著者名
                    author.sex = data[1] as? Bool  //性別
                    author.age = data[2] as? Int //年齢
                }
                
                //管理オブジェクトコンテキストの中身を保存する。
                try managedContext.save()
            }
            
        } catch {
            print(error)
        }
    }



    //著者表示メソッド
    func displayCustomer() {
        do {
            //著者オブジェクトを取得する。。
            let fetchRequest = NSFetchRequest(entityName: "Author")
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [Author]
            author = result[0]
            
            //ラベルに著者情報を設定する。
            nameLabel.text = author.name
            if(author.sex == true) {
                sexLabel.text = "女性"
            } else {
                sexLabel.text = "男性"
            }
            ageLabel.text = String(author.age!)
            
        } catch {
            print(error)
        }
    }



    //出版物読込ボタン押下時の呼び出しメソッド
    @IBAction func pushButton(sender: UIButton) {
    }

}

