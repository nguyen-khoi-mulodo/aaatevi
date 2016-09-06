//
//  ArtistResultController.h
//  NPlus
//
//  Created by Khoi Nguyen Nguyen on 5/16/16.
//  Copyright © 2016 TEVI Team. All rights reserved.
//

#import "HomeVC.h"
#import "XLPagerTabStripViewController.h"
@interface ArtistResultController : HomeVC <XLPagerTabStripChildItem>

- (void)searchArtistByKeyWord:(NSString*)keyword isNewSearch:(BOOL)isNewSearch;

@end
