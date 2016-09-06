//
//  VideoHotCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "ArtistDescriptionItemCell.h"

@implementation ArtistDescriptionItemCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    [lbTitle setFont:[UIFont fontWithName:kFontSemibold size:17.0f]];
    [self.tvDesc setFont:[UIFont fontWithName:kFontRegular size:15.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction) doShowMore:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doShowMore)]) {
        [self.delegate doShowMore];
    }
}

- (void) setContent:(NSString*) desc{
    desc = [desc stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
        desc = [desc stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    [self.tvDesc setText:desc];
}

@end
