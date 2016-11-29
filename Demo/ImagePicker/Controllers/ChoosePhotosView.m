//
//  ChoosePhotosView.m
//  ImagePicker
//
//  Created by zj on 16/9/21.
//  Copyright © 2016年 zj. All rights reserved.
//

#import "ChoosePhotosView.h"
#import "MyLayout.h"
#import "TZImagePickerController.h"
#import "ImageCell.h"
#import "ScanImagesCtr.h"
@interface ChoosePhotosView()<UICollectionViewDataSource,UICollectionViewDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end
@implementation ChoosePhotosView
-(NSMutableArray *)AllImages
{
    if (!_AllImages)
    {
        _AllImages = [NSMutableArray array];
    }
    return _AllImages;
}
-(NSMutableArray *)AllImageDatas
{
    if (!_AllImageDatas)
    {
        _AllImageDatas = [NSMutableArray array];
    }
    return _AllImageDatas;
}
-(NSMutableArray *)AllImagePath
{
    if (!_AllImagePath)
    {
        _AllImagePath = [NSMutableArray array];
    }
    return _AllImagePath;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self=[super initWithFrame:frame collectionViewLayout:layout])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator =NO;
        [self registerClass:[ImageCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    }
    return self;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_AllImages.count == self.MaxPhotosCount)
    {
        return self.MaxPhotosCount;
    }
    else
    {
        return _AllImages.count+1;
    }
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_AllImages.count != 0)
    {
        if (indexPath.row != _AllImages.count)
        {
            ImageCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
            
            cell.Im.image = _AllImages[indexPath.row];
            if (_isHeaderImage){
                cell.Im.frame = CGRectMake(0, 0, 100, 100);
            }else{
                cell.Im.frame = CGRectMake(0, 0, 40, 40);
            }
            
            cell.Im.contentMode = 2;
            cell.Im.clipsToBounds = YES;
            if (_isNewVC) {
                cell.DeleteButton.hidden = true;
            }else{
                cell.DeleteButton.hidden = NO;
            }
            cell.DeleteButton.tag = indexPath.row;
            [cell.DeleteButton addTarget:self action:@selector(DeleteBus:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else
        {
            ImageCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
            cell.Im.contentMode = 0;
            if (_isNewVC == true){
                UIImage *image = [UIImage imageNamed:@"icon_tupian.png"];
                cell.Im.image = image;
                
                CGRect rect = cell.Im.frame;
                cell.Im.frame = CGRectMake(rect.origin.x + 10, 11, 20, 18);
                
            }else{
                cell.Im.image = [UIImage imageNamed:@"zu"];
            }
            cell.DeleteButton.hidden = YES;
            return cell;
        }
        
    }
    else
    {
        ImageCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
        if (_isNewVC == true){
            UIImage *image = [UIImage imageNamed:@"icon_tupian.png"];
            cell.Im.image = image;
            
            CGRect rect = cell.Im.frame;
            cell.Im.frame = CGRectMake(rect.origin.x + 10, 11, 20, 18);
            
        }else{
//            if (_isHeaderImage){
//                cell.Im.image = [UIImage imageNamed:self.headerImgStr];
//            }else {
                cell.Im.image = [UIImage imageNamed:@"zu"];
           // }
        }
        cell.DeleteButton.hidden = YES;
        cell.Im.contentMode = 0;
        return cell;
    }
}
//
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNewVC){
        return  CGSizeMake(40, 40);
    }else if(_isHeaderImage){
        return  CGSizeMake(100, 100);
    }
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/3, (
                      [UIScreen mainScreen].bounds.size.width-30)/3);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{   if (_isNewVC){
        return  UIEdgeInsetsMake(0, 3, 0, 3);
    }
    if (_isHeaderImage){
        return UIEdgeInsetsMake(10, 10, 0, 0);
    }
    return UIEdgeInsetsMake(10, 5, 10, 5);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // self.SuperCtl

    if (_AllImages.count > indexPath.row)//浏览图片
    {
        ScanImagesCtr * ImaPicker = [[ScanImagesCtr alloc]init];
        ImaPicker.AllImages = _AllImages;
        ImaPicker.SelectedImageNum = indexPath.row;
        ImaPicker.delBlock = ^{
            [self DeletePic:indexPath.row + 1];
            
        };
        [self.SuperCtl presentViewController:ImaPicker animated:false completion:nil];
        
    }
    else
    {
        UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction*TakePhoto=[UIAlertAction actionWithTitle:@"相册中选取" style:0 handler:^(UIAlertAction * _Nonnull action){
            TZImagePickerController * Picker = [[TZImagePickerController alloc]initWithMaxImagesCount:self.MaxPhotosCount-_AllImages.count delegate:self];
            Picker.delegate = self;
            [self.SuperCtl presentViewController:Picker animated:YES completion:nil];
        }];
        UIAlertAction*Images   =[UIAlertAction actionWithTitle:@"拍照片"    style:0 handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController * Picker = [[UIImagePickerController alloc]init];
            Picker.delegate = self;
            Picker.allowsEditing = YES;
            Picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.SuperCtl presentViewController:Picker animated:YES completion:nil];
        }];
        UIAlertAction*Cancel   =[UIAlertAction actionWithTitle:@"取消"      style:2 handler:nil];
        [alert addAction:TakePhoto];
        [alert addAction:Images];
        [alert addAction:Cancel];
        [self.SuperCtl presentViewController:alert animated:YES completion:nil];
        
    }
}
//选好照片
-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets
{
   
    [self.AllImages addObjectsFromArray:photos];
    for (int i = 0; i < photos.count; i++) {
        UIImage *image = photos[i];
        NSData * imageData = UIImageJPEGRepresentation(image, 0.75);
        [self.AllImageDatas addObject:imageData];
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg",i];
        [self.AllImagePath addObject:imageName];
    }
    if (_isNewVC){
        self.sendBlock(photos,self.AllImageDatas,false);
    }
    
//    else if (_isHeaderImage){
//        self.headerBlock(photos,self.AllImageDatas,false);
//    }
    [self reloadData];
}
//拍照选好照片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.AllImages addObject:image];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.75);
    [self.AllImageDatas addObject:imageData];
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *str = [[NSString alloc] initWithFormat:@"%@",dat];
    NSString * imageName = [NSString stringWithFormat:@"%@.jpg",str];
    [self.AllImagePath addObject:imageName];
    if (_isNewVC){
        self.sendBlock(self.AllImages,self.AllImageDatas,false);
    }else if (_isHeaderImage){
        self.headerBlock(self.AllImages,self.AllImageDatas,false);
    }

    [self reloadData];
}
//删除照片
-(void)DeleteBus:(UIButton*)Bu
{
    [_AllImages removeObjectAtIndex:Bu.tag];
    [_AllImageDatas removeObjectAtIndex:Bu.tag];
    [self reloadData];
}
//删除照片
-(void)DeletePic:(NSInteger)Bu
{
    if(Bu > 1){
        [_AllImages removeObjectAtIndex:Bu];
        [_AllImageDatas removeObjectAtIndex:Bu];
    }else if (Bu == 1){
        [_AllImages removeObjectAtIndex:Bu - 1];
        [_AllImageDatas removeObjectAtIndex:Bu - 1];
    }
    if (_isNewVC){
        self.sendBlock(_AllImages,_AllImageDatas,true);
    }else if (_isHeaderImage){
        self.headerBlock(self.AllImages,self.AllImageDatas,false);
    }
    [self reloadData];
}


@end
