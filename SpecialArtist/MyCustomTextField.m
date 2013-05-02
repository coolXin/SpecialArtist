//
//  MyCustomTextField.m
//  SpecialArtist
//
//  Created by Cby on 13-4-26.
//  Copyright (c) 2013年 Cby. All rights reserved.
//

#import "MyCustomTextField.h"

@implementation MyCustomTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if (self.leftView != nil)
    {
        return CGRectInset(bounds,self.leftView.frame.size.width + 10, 10);
    }
    else
    {
        return CGRectInset(bounds, 10, 10);
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    if (self.leftView != nil)
    {
        return CGRectInset(bounds,self.leftView.frame.size.width + 10, 10);
    }
    else
    {
        return CGRectInset(bounds, 10, 10);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
