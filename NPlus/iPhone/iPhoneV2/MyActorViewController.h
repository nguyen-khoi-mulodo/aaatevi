//
//  MyActorViewController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 1/4/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"

@interface MyActorViewController : HomeVC <UITableViewDataSource, UITableViewDelegate>

- (void)searchArtistByKeyWord:(NSString*)keyword isNewSearch:(BOOL)isNewSearch;

@end
