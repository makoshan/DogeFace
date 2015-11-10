//
//  ViewController.swift
//  DogFace
//
//  Created by ShanMako on 15/11/3.
//  Copyright © 2015年 sspai. All rights reserved.
//

import UIKit
import ImageIO

class RootViewController: UIViewController ,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    var dogView=UIImageView()
    @IBOutlet weak var imageView: UIImageView!
    var lastScaleFactor:CGFloat = 1
    let images=["dog","dog002","dog003","dog004","dog005","dog006","dog007","dog008","dog009","dog","dog002","dog003","dog004","dog005","dog006","dog007","dog008","dog009","dog","dog002","dog003","dog004","dog005","dog006","dog007","dog008","dog009","dog005","dog006","dog007","dog008","dog009","dog","dog002","dog003","dog004","dog005","dog006","dog007","dog008","dog009","dog","dog002","dog003","dog004","dog005","dog006"]
    lazy var originalImage: UIImage = {
        return UIImage(named: "image")
    }()!
    
    lazy var context: CIContext = {
        return CIContext(options: nil)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.imageView.image=originalImage
        setNavigationBar()
        setUpCollection()
       

    }
    func setUpCollection()
    {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell:PhotoThumbnail = collectionView.dequeueReusableCellWithReuseIdentifier("sundycell", forIndexPath: indexPath) as! PhotoThumbnail        
        cell.setThumbnailImage(UIImage(named: images[indexPath.row])!)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        faceDetecing(UIImage(named: images[indexPath.row])!)
    }
    //每个section中不同的行之间的行间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 5
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 1
    }
    
    //定义每个UICollectionViewCell 的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath: NSIndexPath) -> CGSize{
         return CGSizeMake(42, 42)
    }
    
    
    //定义每个Section 的 margin
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex: NSInteger) -> UIEdgeInsets{
        //分别为上、左、下、右
         return UIEdgeInsetsMake(1, 0, 20, 1)
        
    }
    
    //返回头footerView的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection: NSInteger) -> CGSize{
        let size:CGSize=CGSize(width: 320, height: 20)
        return size;
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func faceDetecing(dogImage:UIImage) {
        let inputImage = CIImage(image: originalImage)!
        let detector = CIDetector(ofType: CIDetectorTypeFace,
            context: context,
            options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        var faceFeatures: [CIFaceFeature]!
        if let orientation: AnyObject = inputImage.properties[kCGImagePropertyOrientation as String] {
            faceFeatures = detector.featuresInImage(inputImage, options: [CIDetectorImageOrientation: orientation]) as! [CIFaceFeature]
        } else {
            faceFeatures = detector.featuresInImage(inputImage)as! [CIFaceFeature]
        }
        
      
        let inputImageSize = inputImage.extent.size
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformScale(transform, 1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height)
        
        for faceFeature in faceFeatures {
            let faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform)
            let finalSize=originalImage.size
            UIGraphicsBeginImageContextWithOptions(finalSize, false, 1)
            originalImage.drawInRect(CGRectMake(0, 0, finalSize.width,finalSize.height))
            dogImage.drawInRect(CGRectMake(faceViewBounds.origin.x,faceViewBounds.origin.y,faceViewBounds.width,faceViewBounds.height))
            let outPutImage:UIImage=UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.imageView.image=outPutImage
            
        }
        
    }
    //保存图片
    func savePhoto(){
        var itemsToShare=[AnyObject]()
        itemsToShare.append("分享Dogeji")
        itemsToShare.append("")
        itemsToShare.append(UIImageJPEGRepresentation(self.imageView.image!, 1)!)
        let activityViewController = UIActivityViewController(activityItems:  itemsToShare, applicationActivities: [])
                presentViewController(activityViewController, animated: true, completion: nil)
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            UIApplication.sharedApplication().openURL(NSURL(string: "photos-redirect://")!)
        default:
            print("a")
        }
    }
    
    //设置toolbar点击事件
    func setNavigationBar(){
        let attributes = [NSFontAttributeName:UIFont(name: "CenturyGothic-BoldItalic", size: 17)!, NSForegroundColorAttributeName:UIColor.UIColorFromRGB(0x037AFF)]
        self.navigationController?.navigationBar.titleTextAttributes=attributes
        self.navigationItem.title="DOGEJI"
        //右侧添加按钮
        let share: UIButton = UIButton()
        share.setImage(UIImage(named: "btn_share"), forState: .Normal)
        share.frame = CGRectMake(0, 0, 44, 44)
        share.imageEdgeInsets=UIEdgeInsets(top: 11, left: 20, bottom: 11, right: 2)
        share.addTarget(self, action: "savePhoto", forControlEvents: UIControlEvents.TouchUpInside)
        let btnShare: UIBarButtonItem = UIBarButtonItem()
        btnShare.customView = share
        self.navigationItem.rightBarButtonItem=btnShare
        //左侧添加按钮
        let add: UIButton = UIButton()
        add.setImage(UIImage(named: "add"), forState: .Normal)
        add.frame = CGRectMake(0, 0, 44, 44)
        add.imageEdgeInsets=UIEdgeInsets(top: 11, left: 2, bottom: 11, right: 20)
        add.addTarget(self, action: "addPhoto", forControlEvents: UIControlEvents.TouchUpInside)
        let btnAdd: UIBarButtonItem = UIBarButtonItem()
        btnAdd.customView = add
        self.navigationItem.leftBarButtonItem=btnAdd
       
    }
    //action打开相册ƒƒ
    func addPhoto() {
        let imagePicker=UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        self.dismissViewControllerAnimated(true, completion: nil)        
        let gotImage:UIImage=info[UIImagePickerControllerOriginalImage] as! UIImage
        self.originalImage=gotImage
        self.imageView.image=gotImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    


}

