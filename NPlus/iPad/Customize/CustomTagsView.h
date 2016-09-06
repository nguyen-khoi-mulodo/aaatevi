//
//  CustomTagsView.h
//  NPlus
//
//  Created by Admin on 3/8/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabelViewFlowLayout.h"

@interface CustomTagsView : UILabelViewFlowLayout{
    NSMutableArray* listTags;
    UILabel* lineView;
}

- (void) resetWithArray:(NSArray*) array;

@end
