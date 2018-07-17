//
//  MsgSub1Cell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MsgSub1Cell.h"

@implementation MsgSub1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentlb.adjustsFontSizeToFitWidth = YES;
}
-(void)setInfoWithDict:(NSDictionary * )dict
{
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:getImage(@"default")];
    
    self.titlelb.text = [dict safeObjectForKey:@"title"];
    self.contentlb.text =[dict safeObjectForKey:@"sendcontent"];
    self.timelb.text =[dict safeObjectForKey:@"sendTime"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
