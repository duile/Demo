//
//  ScanImagesCtr.m
//  ImagePicker
//
//  Created by zj on 16/9/21.
//  Copyright © 2016年 zj. All rights reserved.
//

#import "ScanImagesCtr.h"

@interface ScanImagesCtr ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView * ScanImagesView;
@property(nonatomic,strong) UILabel     * TitleLabel;
@property(nonatomic,strong) UIView *navView;
@property(nonatomic,strong) UIButton *backBtn;
@property(nonatomic,strong) UIButton *delBtn;
@end

@implementation ScanImagesCtr

- (void)viewDidLoad
{
    [super viewDidLoad];
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    int endX = 1 - 64/[UIScreen mainScreen].bounds.size.width;
    
    CAGradientLayer * gradientlayer = [[CAGradientLayer alloc] init];
    gradientlayer.colors = @[(__bridge id)[self colorWithHexString:@"02ccca"].CGColor,(__bridge id)[self colorWithHexString:@"10e6a7"].CGColor];
    gradientlayer.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , 64);
    gradientlayer.startPoint = CGPointMake(1, 1);
    gradientlayer.endPoint = CGPointMake(endX, 0);
    [_navView.layer insertSublayer:gradientlayer atIndex:0];
    [self.view addSubview:_navView];
    // [UIScreen mainScreen].bounds.size.width
    _TitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,120, 50)];
    _TitleLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 , 64 / 2 + 5);
    _TitleLabel.textAlignment = 1;
    _TitleLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)_SelectedImageNum+1,(unsigned long)_AllImages.count];
    _TitleLabel.textColor = [UIColor whiteColor];
    [_navView addSubview:_TitleLabel];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _backBtn.frame = CGRectMake(15, 15, 64, 44);
    [_backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(CloseSC) forControlEvents:UIControlEventTouchUpInside];
    //button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 40)
    _backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    [_backBtn setTintColor:[UIColor whiteColor]];
    [_navView addSubview:_backBtn];
    
    _delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _delBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 79, 15, 64, 44);
    [_delBtn setImage:[UIImage imageNamed:@"icon_del"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
    //button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 40)
    _delBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    [_delBtn setTintColor:[UIColor whiteColor]];
    [_navView addSubview:_delBtn];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _ScanImagesView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
    _ScanImagesView.pagingEnabled = YES;
    _ScanImagesView.bounces = NO;
    _ScanImagesView.delegate = self;
    _ScanImagesView.contentSize =CGSizeMake(_AllImages.count * [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100);
    [self.view addSubview:_ScanImagesView];
    for (int i = 0; i <_AllImages.count; i++)
    {
        UIImageView * Im = [[UIImageView alloc]initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100)];
        UITapGestureRecognizer *CloseSc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CloseSC)];
        Im.userInteractionEnabled = YES;
        [Im addGestureRecognizer:CloseSc];
        Im.contentMode = 1;
        Im.image = _AllImages[i];
        [_ScanImagesView addSubview:Im];
    }
    [self scrollViewDidEndScrollingAnimation:_ScanImagesView];
    
}
-(void)CloseSC
{
    [self dismissViewControllerAnimated:false  completion:nil];
}

-(void)deletePic{
    
    self.delBlock();
    [self dismissViewControllerAnimated:false  completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger Num = scrollView.contentOffset.x/scrollView.frame.size.width;
    _TitleLabel.text = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)Num+1,(unsigned long)_AllImages.count];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(_SelectedImageNum * [UIScreen mainScreen].bounds.size.width, 0);
    
}

- (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
