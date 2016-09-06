//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoSuggestItemCell : UITableViewCell
{
    IBOutlet UILabel* lbTitle;
    IBOutlet UILabel* lbSubTitle;
    IBOutlet UILabel* lbLuotXem;
    IBOutlet UILabel* lbTime;
    IBOutlet UIImageView* thumbImageView;
    IBOutlet UIView* vTime;
    IBOutlet UIImageView* imvHD;
}

-(void) setContentWithVideo:(Video*) video;
@end
