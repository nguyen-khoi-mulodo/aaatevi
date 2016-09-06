//
//  APIController.h
//  NPlus
//
//  Created by TEVI Team on 10/23/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "User.h"
#import "Genre.h"
#import "Season.h"
#import "Artist.h"
#import "VersionEntity.h"
#import "HomeItem.h"
#import "TopKeyword.h"

@interface APIController : NSObject
+(APIController*) sharedInstance;

- (void)getAccessTokenCompleted:(void(^)(id results))_completed failed:(void (^)(NSError* error))_failed;

- (void)loginWithUserName:(NSString*)user_name withPassword:(NSString*)password completed:(void(^)(User *result))_completed failed:(void (^)(NSError* error))_failed;

- (void)loginWithFacebookUserId:(NSString*)fbuserid withAvatar:(NSString*)fbavatar withFullName:(NSString*) fbfullname withUserName:(NSString*) fbusername withAccessKey:(NSString*) fbaccessKey withEmail:(NSString*) fbemail completed:(void(^)(User *result))_completed failed:(void (^)(NSError* error))_failed;

- (void)loginWithGoogleUserId:(NSString*)ggUserId withAvatar: (NSString*)ggAvatar withFullName:(NSString*)ggFullName withUserName:(NSString*)ggUserName withAccessKey:(NSString*)ggAccessKey withEmail:(NSString*)ggEmail completed:(void(^)(User *result))_completed failed:(void(^)(NSError *error))_failed;

- (void)getHomeCompleted:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getShowByGenre:(NSString*)genre_id withPage:(NSString*)page withSort:(NSString*)sort completed:(void(^)(NSArray* results, BOOL isMore, NSString* genreID, NSString* sort))_completed failed:(void (^)(NSError* error))_failed;

- (void)getListSubGenre:(NSString*)genre_id  completed:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getSearchShow:(NSString*)keyword withGenre:(NSString*)genre_id withPageIndex:(NSString*)page completed:(void(^)(NSArray* results, BOOL isMore))_completed failed:(void (^)(NSError* error))_failed;

- (void)getSearchVideos:(NSString *)keyword withPageIndex:(NSString *)page completed:(void (^)(NSArray *, BOOL))_completed failed:(void (^)(NSError *))_failed;

- (void)getShowDetailWithId:(NSString*)show_id completed:(void(^)(Channel *result, NSString *jsonString))_completed failed:(void (^)(NSError* error))_failed;

- (void)getVideoBySeasonWithId:(NSString*)show_id completed:(void(^)(NSArray* results, NSString *jsonString))_completed failed:(void (^)(NSError* error))_failed;

- (void)getVideoDetailWithId:(NSString*)video_id completed:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getVideoRelatedWithId:(NSString*)video_id completed:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getShowRelatedWithId:(NSString*)show_id completed:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getHotKeywordCompleted:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getVideoLikedWithPageIndex:(NSString*)page completed:(void(^)(NSArray* results, BOOL isMore))_completed failed:(void (^)(NSError* error))_failed;

- (void)likeVideo:(NSString*)video_id  completed:(void(^)(NSString* message, BOOL isLike))_completed failed:(void (^)(NSError* error))_failed;

- (void)getVideoByGenre:(NSString *)genre_id withPage:(NSString*)page withSort:(NSString*)sort completed:(void (^)(NSArray *, BOOL, NSString*))_completed failed:(void (^)(NSError *))_failed;

- (void)getSubtitleWithWideoKey:(NSString*)video_key completed:(void(^)(NSArray *results))_completed failed:(void(^)(NSError *error))_failed;



#pragma mark - New version
- (void) getHomeListWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int ,NSArray *,BOOL, int ))_completed failed:(void (^)(NSError *))_failed;
- (void)getHomeItemCompleted:(void(^)(int code, HomeItem* results))_completed failed:(void (^)(NSError* error))_failed;
- (void)getListVideoWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getListVideoByGenre:(NSString*)genreId type:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getVideoOfArtist:(long)artistId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getVideoStreamWithKey:(NSString*)videoId completed:(void(^)(int code,VideoStream *results))_completed failed:(void (^)(NSError* error))_failed;
- (void)getVideoDetailWithKey:(NSString*)videoId completed:(void(^)(int code,Video *results))_completed failed:(void (^)(NSError* error))_failed;
- (void)getVideoSuggestionWithKey:(NSString *)videoId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed;
- (void)getDiscoverVideoWithType:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int ,NSArray *,BOOL, int ))_completed failed:(void (^)(NSError *))_failed;

- (void)getListGenresWithParentId:(NSString*)parentId completed:(void(^)(int code,NSArray* results))_completed failed:(void (^)(NSError* error))_failed;
- (void)getMultiListGenres:(NSString *)listIds completed:(void (^)(int, NSArray *))_completed failed:(void (^)(NSError *))_failed;
- (void)getGenreDetailWithKey:(NSString*)genreId completed:(void(^)(int code, Genre *results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getDiscoverChannelWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int ,NSArray *,BOOL, int ))_completed failed:(void (^)(NSError *))_failed;
- (void)getListChannelsWithGenreId:(NSString*)genreId type:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getChannelSuggestionWithKey:(NSString*)channelId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getChannelOfArtist:(long)artistId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getChannelDetailWithKey:(NSString*)channelId completed:(void(^)(int code,Channel *results))_completed failed:(void (^)(NSError* error))_failed;
- (void)ratingChannel:(NSString*)channelId score:(int)score completed:(void(^)(int code,BOOL results))_completed failed:(void (^)(NSError* error))_failed;

- (void) getSeasonDetailWithKey:(NSString*)seasonId completed:(void(^)(int code, Season *season))_completed failed:(void (^)(NSError* error))_failed;
- (void)getArtistDetailWithKey:(long)artistId completed:(void(^)(int code, Artist *artist))_completed failed:(void (^)(NSError* error))_failed;
- (void) getListArtistHotWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed;
- (void)searchVideoByKeyword:(NSString*)keyword pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)searchChannelByKeyword:(NSString*)keyword pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)searchArtistByKeyword:(NSString*)keyword pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)getTopKeyWordsCompleted:(void (^)(int, NSArray*))_completed failed:(void (^)(NSError *))_failed;

- (void)loginWithFacebookUserId:(NSString *)fbuserid withFullName:(NSString *)fbfullname withEmail:(NSString *)fbemail completed:(void (^)(User *))_completed failed:(void (^)(NSError *))_failed;
- (void)logoutCompleted:(void (^)(BOOL ))_completed failed:(void (^)(NSError *))_failed;
- (void)userSubcribeChannel:(NSString *)channelId subcribe:(BOOL) isSubcribe completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed;
- (void)userGetListChannelPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;
- (void)userSubcribeVideo:(NSString *)videoId subcribe:(BOOL) isSubcribe  completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed;
- (void)userGetListVideoPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed;

- (void)userGetNewFeedPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code, id results, BOOL loadmore, BOOL isFull))_completed failed:(void (^)(NSError* error))_failed;

- (void)userFeedbackWithId:(short)feedbackId content:(NSString*)content phone:(NSString*)phone completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed;
- (void)userCheckNotifyCompleted:(void(^)(int code,NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)getFeedbackObjectCompleted:(void(^)(int code,NSArray* results))_completed failed:(void (^)(NSError* error))_failed;
- (void)getAppRelatedCompleted:(void(^)(NSArray* results))_completed failed:(void (^)(NSError* error))_failed;
- (void)keyNotify:(NSString*)keyNotify completed:(void(^)(BOOL result))_completed failed:(void (^)(NSError* error))_failed;
- (void)checkVersionCompleted:(void(^)(VersionEntity *result))_completed failed:(void (^)(NSError* error))_failed;
- (void)getListLocalNotifCompleted:(void(^)(int code,NSArray* results))_completed failed:(void (^)(NSError* error))_failed;

- (void)logViewedWithObjectId:(NSString*)objectId type:(NSString*)type completed:(void(^)(BOOL result))_completed failed:(void (^)(NSError *error))_failed;
- (void)logPlayededVideoId:(NSString*)videoId completed:(void(^)(BOOL result))_completed failed:(void (^)(NSError *error))_failed;
- (void)logNotifyViewd:(NSString*)notifyId completed:(void(^)(BOOL result))_completed failed:(void (^)(NSError *error))_failed;
@end
