//
//  WaBaoJlCell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/5/16.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "WaBaoJlCell.h"

@implementation WaBaoJlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (IBAction)showAllTheMember:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showMemberWithCell:)]) {
        [self.delegate showMemberWithCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
