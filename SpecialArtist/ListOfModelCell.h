//
//  ListofModelCell.h
//  SpecialArtist
//
//  Created by Cby on 13-4-26.
//  Copyright (c) 2013年 Cby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListOfModelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textDescription;

- (void)steupUIWith:(id)model;
@end
