//
//  NewMy1Cell.h
//  zjj
//
//  Created by iOSdeveloper on 2018/2/1.
//  Copyright © 2018年 ZhiJiangjun-iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NewMy1CellDelegate;
@interface NewMy1Cell : UICollectionViewCell
- (IBAction)enterEditInfoPage:(id)sender;
- (IBAction)enterGzPage:(id)sender;
- (IBAction)enterFunsPage:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *jjlb;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelb;
@property (weak, nonatomic) IBOutlet UILabel *gzCountlb;
@property (weak, nonatomic) IBOutlet UILabel *funsCountlb;
@property (weak, nonatomic) IBOutlet UILabel *dtCountlb;


@property (assign,nonatomic)id<NewMy1CellDelegate>delegate;
@end
@protocol NewMy1CellDelegate <NSObject>
-(void)enterGzPage;
-(void)enterFunsPage;
-(void)enterEditPage;
-(void)enterMessagePage;

@end
