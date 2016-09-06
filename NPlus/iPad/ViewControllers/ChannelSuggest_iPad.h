//
//  ArtistHotVC.h
//  NPlus
//
//  Created by Vo Chuong Thien on 1/19/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelSuggestDeleage <NSObject>
- (void) getChannnelDetailWithChannel:(Channel*) channel;
@end

@interface ChannelSuggest_iPad : BaseVC<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView* myTableView;
    IBOutlet UILabel* lbTitleChannel;
    
}
@property (nonatomic, strong) Channel* mChannel;
@property (nonatomic, strong) id <ChannelSuggestDeleage> delegate;

- (void) loadDataWithChannel:(Channel*) channel;
@end
