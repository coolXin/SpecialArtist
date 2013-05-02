//
//  ListofModelCell.m
//  SpecialArtist
//
//  Created by Cby on 13-4-26.
//  Copyright (c) 2013年 Cby. All rights reserved.
//

#import "ListOfModelCell.h"
#import "ArtWorksModel.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation ListOfModelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)steupUIWith:(id)model
{
    ArtWorksModel *workModel = (ArtWorksModel *)model;
    _titleLabel.text = workModel.title;
    _textDescription.text = workModel.textDesc;

    [_myImageView setImageWithURL:[NSURL URLWithString:workModel.image_small] placeholderImage:[UIImage imageNamed:@"image1.png"] options:SDWebImageProgressiveDownload progress:nil completed:nil];
}

@end
