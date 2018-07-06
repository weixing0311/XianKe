//
//  WaBaoCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/5/7.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaBaoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelb;
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *countlb;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;

@end
