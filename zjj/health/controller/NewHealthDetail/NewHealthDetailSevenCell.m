//
//  NewHealthDetailSevenCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/4/20.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewHealthDetailSevenCell.h"

@implementation NewHealthDetailSevenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.midBgView.layer.masksToBounds = YES;
    self.midBgView.layer.cornerRadius =55;
//    self.midBgView.layer.borderColor = RGBACOLOR(225.0f/0, 225.0f/0, 225.0f/0, 0.3).CGColor;
//    self.midBgView.layer.borderWidth = 5;

}
-(void)setInfoWithItem:(HealthDetailsItem *)item
{
    self.weightlb.text = [NSString stringWithFormat:@"%.1f",item.weight];
    self.bmilb.text = [NSString stringWithFormat:@"%.1f",item.bmi];
    self.healthIndexlb.text = [NSString stringWithFormat:@"%.2f",item.score];
    self.stateImageView.image = item.weight-item.lastWeight>0?getImage(@"health_detail_up"):getImage(@"health_detail_down");
    self.lesslb.text = [NSString stringWithFormat:@"%.1f斤",item.weight-item.lastWeight>0?(item.weight-item.lastWeight)*2:(item.lastWeight-item.weight)*2];
    self.lesslb.textColor = item.weight-item.lastWeight>0?[UIColor colorWithRed:246/255.0 green:172/255.0 blue:2/255.0 alpha:1]:HEXCOLOR(0x17BEBB);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
