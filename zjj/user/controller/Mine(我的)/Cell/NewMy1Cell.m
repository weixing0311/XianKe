//
//  NewMy1Cell.m
//  zjj
//
//  Created by iOSdeveloper on 2018/2/1.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import "NewMy1Cell.h"

@implementation NewMy1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)enterEditInfoPage:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(enterEditPage)]) {
        [self.delegate enterEditPage];
    }
}

- (IBAction)enterGzPage:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(enterGzPage)]) {
        [self.delegate enterGzPage];
    }

}
- (IBAction)enterMessagePage:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(enterMessagePage)]) {
        [self.delegate enterMessagePage];
    }

}

- (IBAction)enterFunsPage:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(enterFunsPage)]) {
        [self.delegate enterFunsPage];
    }

}
@end
