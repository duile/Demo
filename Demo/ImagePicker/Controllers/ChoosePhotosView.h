//
//  ChoosePhotosView.h
//  ImagePicker
//
//  Created by zj on 16/9/21.
//  Copyright © 2016年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSArray*,NSArray*,BOOL);

@interface ChoosePhotosView : UICollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
@property(nonatomic,strong) UIViewController             *SuperCtl;//传入父kongzhiqi
@property(nonatomic,assign) NSUInteger         MaxPhotosCount;//允许最大的照片张数

@property(nonatomic,strong) NSMutableArray               * AllImages;
@property(nonatomic,strong) NSMutableArray               * AllImageDatas;
@property(nonatomic,strong) NSMutableArray               * AllImagePath;

@property(nonatomic,assign) BOOL isNewVC;//判断是否是记账页面

@property (nonatomic,copy) MyBlock sendBlock;

@property (nonatomic,assign) BOOL isChange;

@property (nonatomic,assign) BOOL isHeaderImage;

@property (nonatomic,strong) NSString * headerImgStr;

@property (nonatomic,copy) MyBlock headerBlock;

@end
