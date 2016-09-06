//
//  HotItemCell.m
//  NPlus
//
//  Created by Vo Chuong Thien on 10/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "VideoDownloadedItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation VideoDownloadedItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)init {
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 502, 195);
        
        [[NSBundle mainBundle] loadNibNamed:@"VideoDownloadedItemCell" owner:self options:nil];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.view];
        
        [self.lbName setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Semibold" size:20.0f]];
        [self.lbTap setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:15.0f]];
        [self.lbViews setFont:[UIFont fontWithName:@"SanFranciscoDisplay-Regular" size:15.0f]];
    }
    
    return self;
    
}

-(void) setVideo:(Video *) item{
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    int index = (rand() % 3) + 1;
    [_imageIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"demo-img-video_ipad_%d", index]]];
}

- (void) setVideo:(Video*) item isShowActionView:(BOOL) isShow{
    [self.view setUserInteractionEnabled:YES];
    [_imageIcon setClipsToBounds:YES];
    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    int index = (rand() % 3) + 1;
    [_imageIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"demo-img-video_ipad_%d", index]]];
    [self.actionView setHidden:!isShow];
}

//- (void) setVideo:(VideoInfo*) item isShowAction:(BOOL) isShow{
//    [_imageIcon setClipsToBounds:YES];
//    [_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
//    [_imageIcon setImage:[UIImage imageNamed:item.imageName]];
//    [self.btnAction setHidden:!isShow];
//    [self.lbName setText:item.displayName];
//    [self.lbTap setText:item.tap];
//    [self.lbStatus setHidden:!isShow];
//}


- (void)setUILabelTextWithVerticalAlignTop:(NSString *)theText withLabel:(UILabel*) label{
    CGSize labelSize = label.frame.size;
    CGSize theStringSize = [theText sizeWithFont:label.font constrainedToSize:labelSize lineBreakMode:label.lineBreakMode];
    float X = label.frame.origin.x;
    float width;
    if ((label.frame.size.width/2 - theStringSize.width/2) > 0) {
        X = label.frame.origin.x + (label.frame.size.width/2 - theStringSize.width/2);
        width = self.frame.size.width - 2 * X;
    }else{
        width = label.frame.size.width;
    }
    label.frame = CGRectMake(X, label.frame.origin.y, width, theStringSize.height);
    label.text = theText;
}

-(void) setContent:(Channel *) item{
    //[_imageIcon setClipsToBounds:YES];
    //[_imageIcon setContentMode:UIViewContentModeScaleAspectFill];
    //[_imageIcon setImageWithURL:[NSURL URLWithString:item.image_thumb] placeholderImage:[UIImage imageNamed:@"default_video_ipad"]];
//    [_lbName setText:item.show_title];
}

- (IBAction) doShowMore:(id)sender{
    NSLog(@"do show more");
}

- (IBAction) doDownload:(id)sender{
    NSLog(@"do download");
}

@end
