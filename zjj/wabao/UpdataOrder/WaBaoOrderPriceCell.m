//
//  WaBaoOrderPriceCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/31.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoOrderPriceCell.h"

@implementation WaBaoOrderPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setUpWbInfoWithDict:(NSDictionary *)dic
{
    
}
- (IBAction)didPay:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(didPayWithCell:)]) {
        [self.delegate didPayWithCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
