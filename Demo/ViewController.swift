//
//  ViewController.swift
//  Demo
//
//  Created by 硕道开发 on 2016/11/24.
//  Copyright © 2016年 吴亚楠. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,TZImagePickerControllerDelegate {
    
    let imagePickerController: UIImagePickerController = UIImagePickerController()
    var butn:UIButton?
    
    var cropView:KICropImageView?
    var sureBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        butn = UIButton.init(type: .custom)
        butn?.setTitle("选取照片", for: .normal)
        butn?.frame = CGRect.init(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 45)
        butn?.backgroundColor = UIColor.red
        butn?.addTarget(self, action: #selector(chooseImage(sender:)), for: .touchUpInside)
        self.view.addSubview(butn!)
        self.view.backgroundColor = UIColor.white
        
    }
    
    func chooseImage(sender: UIButton) {
        
        let actionSheet = UIAlertController(title:nil,message: nil,preferredStyle: .actionSheet)
        let takePhotoes = UIAlertAction(title:"拍照",style: .default,handler: { (alert:UIAlertAction!) -> Void in
            //判断是否支持相机
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                
                
                self.imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            }else{
                
                // AlertViewTool.alertView("当前设备，摄像头不可用！")
            }
        })
        let photoesAlbum = UIAlertAction(title:"照片图库",style: .default,handler: {(alert:UIAlertAction!) -> Void in
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            let Picker = TZImagePickerController.init(maxImagesCount: 1, delegate: self)
            Picker?.delegate = self
            
            self.present(Picker!, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title:"取消",style: .cancel,handler: {(alert:UIAlertAction!) -> Void in
        })
        
        actionSheet.addAction(takePhotoes)
        actionSheet.addAction(photoesAlbum)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    //实现ImagePicker delegate 事件
    
    //选好照片
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!) {
        let image = photos[0] as UIImage
       // let size = image.size
        cropView = KICropImageView.init(frame: self.view.bounds)
        cropView?.setCropSize(CGSize.init(width: 100, height: 100))
        
        cropView?.setImage(image)
        self.view.addSubview(cropView!)
        
        sureBtn = UIButton.init(type: .custom)
        sureBtn?.frame = CGRect.init(x: 80, y: 41, width: 150, height: 31)
        sureBtn?.setTitle("确定", for: .normal)
        sureBtn?.addTarget(self, action: #selector(cropImageAction(but:)), for: .touchUpInside)
        sureBtn?.backgroundColor = UIColor.blue
        self.view.addSubview(sureBtn!)
        
    }
    //拍好照片
    func cropImageAction(but:UIButton) {
        let imageV = UIImageView.init(frame: CGRect.init(x: 100, y: 200, width: 100, height: 100))
        imageV.backgroundColor = UIColor.red
        imageV.image = cropView?.cropImage()
        cropView?.removeFromSuperview()
        sureBtn?.removeFromSuperview()
        self.view.addSubview(imageV)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

