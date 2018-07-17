//
//  MessageCell.m
//  zjj
//
//  Created by iOSdeveloper on 2017/8/2.
//  Copyright © 2017年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setInfoWithDict:(NSDictionary * )dict
{
    switch (self.tag) {
        case 0:
            self.BigImageView.image = getImage(@"default");
            self.titleLabel.text = @"系统消息";
            self.timeLabel.text = @"2018/07/12";

            break;
        case 1:
            self.BigImageView.image = getImage(@"default");
            self.titleLabel.text = @"交易物流";
            self.timeLabel.text = @"2018/07/12";
            
            break;
        case 2:
            self.BigImageView.image = getImage(@"default");
            self.titleLabel.text = @"优惠活动";
            self.timeLabel.text = @"2018/07/12";
            
            break;
        case 3:
            self.BigImageView.image = getImage(@"default");
            self.titleLabel.text = @"智能客服";
            self.timeLabel.text = @"2018/07/12";
            
            break;

        default:
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
