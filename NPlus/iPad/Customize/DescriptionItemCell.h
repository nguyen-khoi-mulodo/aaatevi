//
//  VideoHotCell.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/21/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DescriptionItemCellDelegate <NSObject>

- (void) doShowMore;

@end
@interface DescriptionItemCell : UITableViewCell{
    
}
@property (nonatomic, assign) id <DescriptionItemCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView* tvDesc;
- (void) setContent:(NSString*) desc;
@end

