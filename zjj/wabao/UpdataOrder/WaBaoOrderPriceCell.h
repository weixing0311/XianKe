//
//  WaBaoOrderPriceCell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/5/31.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol orderPriceCellDelegate;

@interface WaBaoOrderPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *pricelb;
@property (nonatomic,assign)id<orderPriceCellDelegate>delegate;
-(void)setUpWbInfoWithDict:(NSDictionary *)dic;
@end
@protocol orderPriceCellDelegate<NSObject>
-(void)didPayWithCell:(WaBaoOrderPriceCell *)cell;
@end
