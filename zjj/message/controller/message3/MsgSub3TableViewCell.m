//
//  MsgSub3TableViewCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/7/5.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "MsgSub3TableViewCell.h"

@implementation MsgSub3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.borderWidth= 1;
    self.bgView.layer.borderColor = HEXCOLOR(0xffffff).CGColor;
    
    
    // Initialization code
}
-(void)setInfoWithDict:(NSDictionary * )dict
{
    [self.BigImageView sd_setImageWithURL:[NSURL URLWithString:[dict safeObjectForKey:@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"find_default2"]];;
    
    self.timelb.text = [dict safeObjectForKey:@"releaseTime"];
    self.timelb.frame = CGRectMake((JFA_SCREEN_WIDTH-[self getWidthWithString:self.timelb.text]-20)/2, 8, [self getWidthWithString:self.timelb.text]+20, 20) ;
    
    
    self.contentLabel.text = [dict safeObjectForKey:@"sendcontent"];
    self.contentLabel.hidden =NO;
    self.titleLabel.text = [dict safeObjectForKey:@"title"];
}
-(float)getWidthWithString:(NSString *)str
{
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;

    UIFont *font = [UIFont systemFontOfSize:13];
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSParagraphStyleAttributeName:paragraph};
    CGSize size = [self.timelb.text boundingRectWithSize:CGSizeMake(JFA_SCREEN_WIDTH-52, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
