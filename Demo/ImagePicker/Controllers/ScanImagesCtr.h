//
//  ScanImagesCtr.h
//  ImagePicker
//
//  Created by zj on 16/9/21.
//  Copyright © 2016年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myBlock)(void);

@interface ScanImagesCtr : UIViewController
@property(nonatomic,strong) NSMutableArray             *AllImages;
@property(nonatomic,assign) NSUInteger                  SelectedImageNum;

@property(nonatomic,copy) myBlock delBlock;

@end
