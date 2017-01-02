//
//  iSettingCustomCell.m
//  
//
//  Created by 蔡瑞雄 on 2011/8/17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "iCustomCellRowType.h"
#import "AppDelegate.h"

@implementation iCustomCellRowType

@synthesize primaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:FALSE animated:animated];
    
    // Configure the view for the selected state
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // Initialization code
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.textAlignment = NSTextAlignmentLeft;
        primaryLabel.font = [UIFont systemFontOfSize:12];
        primaryLabel.numberOfLines = 3;
        primaryLabel.adjustsFontSizeToFitWidth = TRUE;
        primaryLabel.minimumScaleFactor = 0.6f;
        [primaryLabel setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:primaryLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
    frame= CGRectMake(boundsX+4 ,0, 180, 36);
    primaryLabel.frame = frame;
}

- (void)dealloc
{
    //[super dealloc];
}

@end
