//
//  UIGridView.h
//  foodling2
//
//  Created by Tanin Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIGridViewDelegate;
@class UIGridViewCell;

@interface UIGridView : UITableView<UITableViewDelegate, UITableViewDataSource> {
	UIGridViewCell *tempCell;
}

@property (nonatomic, retain) IBOutlet id<UIGridViewDelegate> uiGridViewDelegate;
@property (nonatomic, retain) NSString* identifierName;

- (void) setUp;
- (UIGridViewCell *) dequeueReusableCell:(NSString*) name;
- (IBAction) cellPressed:(id) sender;

@end
