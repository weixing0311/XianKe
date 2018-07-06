//
//  WaBaoCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/7.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoCell.h"

@implementation WaBaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countlb.adjustsFontSizeToFitWidth = YES;
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius =15;

    // Initialization code
}

@end
