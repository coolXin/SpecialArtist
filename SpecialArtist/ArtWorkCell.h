//
//  HaoKanCell.h
//  Artist
//
//  Created by cuibaoyin on 13-3-5.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerRequestParam.h"
#import "MBProgressHUD.h"

@interface ArtWorkCell : UITableViewCell<ServerRequestParamDelegate>
{
    NSMutableArray *dataArray;
    NSIndexPath *indexPath;
    
    ServerRequestParam *serverRequest;
    MBProgressHUD *hud;
    MBProgressHUD *failedHud;
}

@property (strong, nonatomic) IBOutlet UILabel *fancyLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UIView *frameView;
@property (strong, nonatomic) IBOutlet UILabel *workNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *litleTitleLabel;

- (IBAction)fancyWork:(id)sender;
- (IBAction)commentWork:(id)sender;
- (void)cleanDataAndUI;
- (void)loadDataWithArray:(NSMutableArray *)array withIndexPath:(NSIndexPath *)index;

@end
