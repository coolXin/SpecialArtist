//
//  CommitCell.h
//  Artist
//
//  Created by cuibaoyin on 13-3-21.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "AmrRecordAndPlay.h"

@interface CommitCell : UITableViewCell<AmrRecordAndPlayDelegate>

@property (strong, nonatomic) CommentModel *myModel;
@property (strong, nonatomic) IBOutlet UIImageView *avaterImageView;
@property (strong, nonatomic) UILabel *textContentLabel;
@property (strong, nonatomic) IBOutlet UIView *voiceView;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *audioStatusImageView;

- (IBAction)playBtnPressed:(id)sender;
-(void)setupCellWithCommit:(CommentModel *)model;

@end
