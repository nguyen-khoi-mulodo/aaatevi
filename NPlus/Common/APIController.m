//
//  APIController.m
//  NPlus
//
//  Created by TEVI Team on 10/23/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "APIController.h"
#import "HttpClient.h"
#import "DeviceInfo.h"
#import "ParserObject.h"
#import "NSString+Base64.h"
#import "TokenManager.h"
#import "TokenInfo.h"
#import "VersionEntity.h"


#define SECRET_KEY              @"T3Vi@nCt2o1^"

#define LOGIN                   @"%@/users/login?access_token=%@&username=%@&password=%@"
#define GET_HOME                @"%@/videos/home?access_token=%@"
#define GET_SHOW_BY_GENRE       @"%@/shows/genre?access_token=%@&genreid=%@&userid=%@&pageindex=%@&pagesize=%d&sort=%@"
#define GET_LIST_SUB_GENRE      @"%@/genres/childs/%@?access_token=%@"
#define GET_SEARCH_SHOW         @"%@/searchs/show?access_token=%@"
#define GET_SEARCH_VIDEO        @"%@/searchs/video?access_token=%@"
#define GET_SHOW_DETAIL         @"%@/shows/%@?access_token=%@"
#define GET_VIDEO_BY_GENRE      @"%@/videos/genre/%@?access_token=%@&userid=%@&pageindex=%@&pagesize=%@&sort=%@"
#define GET_VIDEO_BY_SEASON     @"%@/videos/season/%@?access_token=%@"
//#define GET_VIDEO_DETAIL        @"%@/videos/%@?access_token=%@"
#define GET_VIDEO_LIKED         @"%@/videos/liked?access_token=%@&pageindex=%@&pagesize=%@"
#define GET_SHOW_RELATED        @"%@/shows/related/%@?access_token=%@"
#define GET_VIDEO_RELATED       @"%@/videos/related/%@?access_token=%@"
#define GET_HOT_KEY             @"%@/shows/hot-keyword?access_token=%@"
#define LIKE_VIDEO              @"%@/videos/like/%@?access_token=%@"
#define LOGIN_FACEBOOK          @"%@/users/login-fb?access_token=%@&fbuserid=%@&fbavatar=%@&fbfullname=%@&fbusername=%@&fbaccesskey=%@&fbemail=%@"
#define LOGIN_GOOGLEPLUS        @"%@/users/login-gp?access_token=%@&gpuserid=%@&gpavatar=%@&gpfullname=%@&gpusername=%@&gpaccesskey=%@&gpemail=%@"
#define GET_SUBTITLE            @"%@/videos/subtitle/%@?access_token=%@"

//-----------------------------------------

#define GET_ACCESS_TOKEN            @"%@/commons/token"
#define GET_HOME_VIDEO              @"%@/home/video?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_HOME_ITEM               @"%@/home/index?access_token=%@"
#define GET_TOP_KEY_WORD            @"%@/home/top-keyword?access_token=%@"
#define GET_DISCOVER_VIDEO          @"%@/videos/discover/%@?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_VIDEO_DETAIL            @"%@/videos/detail/%@?access_token=%@"
#define GET_LIST_VIDEO_BY_GENRE     @"%@/videos/genre/%@?access_token=%@&type=%@&pageindex=%d&pagesize=%d"
#define GET_VIDEO_ARTIST            @"%@/videos/artist/%ld?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_VIDEO_SUGGESTION        @"%@/videos/suggest/%@?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_VIDEO_STREAM            @"%@/videos/stream/%@?access_token=%@"
#define GET_LIST_GENRE              @"%@/genres/list/%@?access_token=%@"
#define GET_MULTI_LIST_GENRE        @"%@/genres/multi-list/%@?access_token=%@"
#define GET_GENRE_DETAIL            @"%@/genres/%@?access_token=%@"
#define GET_LIST_CHANNEL_BY_GENRE   @"%@/channels/genre/%@?access_token=%@&type=%@&pageindex=%d&pagesize=%d"
#define GET_DISCOVER_CHANNEL        @"%@/channels/discover?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_CHANNEL_SUGGETION       @"%@/channels/suggest/%@?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_CHANNEL_DETAIL          @"%@/channels/detail/%@?access_token=%@"
#define GET_CHANNEL_ARTIST          @"%@/channels/artist/%ld?access_token=%@&pageindex=%d&pagesize=%d"
#define RATING_CHANNEL              @"%@/channels/rating/%@?access_token=%@&score=%d"
#define GET_SEASON_DETAIL           @"%@/seasons/detail/%@?access_token=%@"
#define GET_SEASON_DETAIL           @"%@/seasons/detail/%@?access_token=%@"
#define GET_ARTIST_DETAIL           @"%@/artists/detail/%ld?access_token=%@"
#define GET_ARTISTS_HOT             @"%@/artists/hot?access_token=%@&pageindex=%d&pagesize=%d"
#define SEARCH_VIDEO                @"%@/searchs/video?access_token=%@&pageindex=%d&pagesize=%d"
#define SEARCH_CHANNEL              @"%@/searchs/channel?access_token=%@&pageindex=%d&pagesize=%d"
#define SEARCH_ARTIST               @"%@/searchs/artist?access_token=%@&pageindex=%d&pagesize=%d"
#define LOGIN_FB                    @"%@/users/login-fb?access_token=%@"
#define LOGOUT                      @"%@/users/logout?access_token=%@"
#define SUBCRIBE_CHANNEL            @"%@/users/subscribe-channel/%@?access_token=%@"
#define UNSUBCRIBE_CHANNEL          @"%@/users/unsubscribe-channel/%@?access_token=%@"
#define USER_GET_LIST_CHANNEL       @"%@/users/list-channel?access_token=%@&pageindex=%d&pagesize=%d"
#define SUBCRIBE_VIDEO              @"%@/users/subscribe-video/%@?access_token=%@"
#define UNSUBCRIBE_VIDEO            @"%@/users/unsubscribe-video/%@?access_token=%@"
#define USER_GET_LIST_VIDEO         @"%@/users/list-video?access_token=%@&pageindex=%d&pagesize=%d"
#define USER_GET_NEW_FEED           @"%@/users/video-suggest?access_token=%@&pageindex=%d&pagesize=%d"
#define GET_APP_RELATED             @"%@/commons/app?access_token=%@"
#define KEY_NOTIFY                  @"%@/commons/key-notify?access_token=%@"
#define CHECK_VERSION               @"%@/commons/version?access_token=%@"
#define GET_LOCAL_NOTIF             @"%@/commons/local-notif?access_token=%@"
#define GET_FEEDBACK                @"%@/users/get-feedback?access_token=%@"
#define USER_FEEDBACK               @"%@/users/feedback?access_token=%@"
#define USER_CHECK_NOTIFY           @"%@/users/check-notify?access_token=%@"
#define LOG_VIEWED                  @"%@/logs/viewed/%@?type=%@&access_token=%@"
#define LOG_PLAYED                  @"%@/logs/played/%@?type=VIDEO&access_token=%@"
#define LOG_NOTIFY_VIEW             @"%@/logs/notify-viewed/%@?access_token=%@"
@interface APIController(){
    HttpClient *httpClient;
}
@end
@implementation APIController
static APIController* _sharedInstance = nil;

+(APIController*) sharedInstance{
    
    @synchronized(self)
    {
        if (_sharedInstance == nil)
            _sharedInstance = [[self alloc] init];
    }
    
    return _sharedInstance;
}

+(id) alloc
{
    @synchronized(self)
    {
        NSAssert(_sharedInstance == nil,
                 @"Attempted to allocate a second instance of a singleton.");
        _sharedInstance = [super alloc];
        
        return _sharedInstance;
    }
    return nil;
}

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        httpClient = [[HttpClient alloc] init];
    }
    
    return self;
}

#pragma mark - Common
-(void)getAccessTokenCompleted:(void (^)(id))_completed failed:(void (^)(NSError *))_failed{
    NSString *deviceInfo = [[DeviceInfo sharedInstance] deviceInfo];
    NSString *deviceId = [[DeviceInfo sharedInstance] deviceId];
    long long milliseconds = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *tmp = [NSString stringWithFormat:@"%@%lld%@", SECRET_KEY, milliseconds, deviceId];
    NSString *md5 = [[tmp md5]lowercaseString];
    NSString *refToken = [Utilities getRefreshToken];
    if (!refToken) {
        refToken = @"";
    }
        NSDictionary *dict = @{@"deviceinfo":deviceInfo,@"timestamp":[NSString stringWithFormat:@"%lld",milliseconds],@"md5":md5,@"refesh_token":refToken};
    NSString *url = [NSString stringWithFormat:GET_ACCESS_TOKEN,API_URL];
    [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        if (data) {
            NSArray *tokens = [ParserObject getObjectsFromArray:@[data] withObjectType:@"TOKEN"];
            _completed([tokens lastObject]);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
-(void)getAppRelatedCompleted:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_APP_RELATED, API_URL, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *items = [ParserObject getObjectsFromArray:data withObjectType:@"APPRELATED"];
                    _completed(items);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN || code == kAPI_EMPTY_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getAppRelatedCompleted:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
        } else {
            _failed(nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)keyNotify:(NSString*)keyNotify completed:(void (^)(BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:KEY_NOTIFY,API_URL,access_token];
    NSDictionary *dict = @{@"notifykey":keyNotify};
    [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                //NSLog(@"key notify successful register");
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN || code == kAPI_EMPTY_TOKEN) {
                [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                    [[APIController sharedInstance]keyNotify:keyNotify completed:_completed failed:_failed];
                } failed:^(NSError *error) {
                    _failed(error);
                }];
            }
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
-(void)checkVersionCompleted:(void (^)(VersionEntity*))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:CHECK_VERSION, API_URL, accessToken];
    NSString *deviceInfo = [[DeviceInfo sharedInstance]deviceInfo];
    NSDictionary *dict = @{@"deviceinfo":deviceInfo};
    [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
        
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            if (data) {
                NSArray *array = [ParserObject getObjectsFromArray:@[data] withObjectType:@"VERSION"];
                if (array) {
                    VersionEntity *version = [array lastObject];
                    _completed(version);
                }
            }else{
                _failed(nil);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                [self checkVersionCompleted:_completed failed:_failed];
            }failed:^(NSError *error){
                _failed(error);
            }];
        }
        
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
    
}

- (void)getListLocalNotifCompleted:(void (^)(int, NSArray *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_LOCAL_NOTIF,API_URL,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"NOTIFICATION"];
            _completed(code,array);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getListLocalNotifCompleted:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)logViewedWithObjectId:(NSString *)objectId type:(NSString *)type completed:(void (^)(BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:LOG_VIEWED,API_URL,objectId,type,access_token ];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance]logViewedWithObjectId:objectId type:type completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)logPlayededVideoId:(NSString *)videoId completed:(void (^)(BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:LOG_PLAYED,API_URL,videoId,access_token ];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance]logPlayededVideoId:videoId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)logNotifyViewd:(NSString*)notifyId completed:(void (^)(BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:LOG_NOTIFY_VIEW,API_URL,notifyId,access_token ];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance]logNotifyViewd:notifyId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

#pragma mark - User
- (void)loginWithFacebookUserId:(NSString *)fbuserid withFullName:(NSString *)fbfullname withEmail:(NSString *)fbemail completed:(void (^)(User *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSDictionary *dict = @{@"fbUserId":fbuserid, @"fbFullName":fbfullname, @"fbEmail":fbemail ? fbemail:@""};
    NSString *url = [NSString stringWithFormat:LOGIN_FB,API_URL,access_token ];
    [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *data = [responseObject objectForKey:kRESPONSE_DATA];
            NSString *userName = [[data objectForKey:@"1"]description];
            NSString *displayName = [[data objectForKey:@"2"]description];
            User *user = [[User alloc]init];
            user.displayName = displayName ? displayName : fbfullname;
            user.userName = userName;
            _completed(user);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] loginWithFacebookUserId:fbuserid withFullName:fbfullname withEmail:fbemail completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)logoutCompleted:(void (^)(BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:LOGOUT,API_URL,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] logoutCompleted:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)userGetListChannelPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:USER_GET_LIST_CHANNEL,API_URL,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] userGetListChannelPageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else if (code == kAPI_USER_NOT_LOGIN) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            //alert.tag = 111;
            [alert show];
            APPDELEGATE.user = nil;
            APPDELEGATE.isLogined = NO;
            [[APIController sharedInstance]logoutCompleted:^(BOOL result) {
                
            } failed:^(NSError * error) {
                
            }];
        }
        else {
            _completed(code,nil,NO,0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)userSubcribeChannel:(NSString *)channelId subcribe:(BOOL) isSubcribe completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url;
    if (isSubcribe) {
        url = [NSString stringWithFormat:SUBCRIBE_CHANNEL,API_URL,channelId, access_token];
    }else{
        url = [NSString stringWithFormat:UNSUBCRIBE_CHANNEL,API_URL,channelId, access_token];
    }
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(code,result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] userSubcribeChannel:channelId subcribe:isSubcribe completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else if (code == kAPI_USER_NOT_LOGIN) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            //alert.tag = 111;
            [alert show];
            APPDELEGATE.user = nil;
            APPDELEGATE.isLogined = NO;
            [[APIController sharedInstance]logoutCompleted:^(BOOL result) {
                
            } failed:^(NSError * error) {
                
            }];
        }
        else {
            _completed(code,NO);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}



- (void)userGetListVideoPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void(^)(int code,NSArray* results, BOOL loadmore, int total))_completed failed:(void (^)(NSError* error))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:USER_GET_LIST_VIDEO,API_URL,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] userGetListVideoPageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else if (code == kAPI_USER_NOT_LOGIN) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            //alert.tag = 111;
            [alert show];
            APPDELEGATE.user = nil;
            APPDELEGATE.isLogined = NO;
            [[APIController sharedInstance]logoutCompleted:^(BOOL result) {
                
            } failed:^(NSError * error) {
                
            }];
        } else {
            _completed(code,nil,NO,0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)userGetNewFeedPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, id, BOOL, BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:USER_GET_NEW_FEED,API_URL,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *data = [responseObject objectForKey:kRESPONSE_DATA];
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *dictToday = [[data objectForKey:@"1"] mutableCopy];
                NSMutableDictionary *dictYesterday = [[data objectForKey:@"2"] mutableCopy];
                NSMutableDictionary *dictOlder = [[data objectForKey:@"3"] mutableCopy];
                
                NSMutableDictionary *copyToday = [dictToday mutableCopy];
                NSMutableDictionary *copyYesterday = [dictYesterday mutableCopy];
                NSMutableDictionary *copyOlder = [dictOlder mutableCopy];
                
                NSArray *dataVideoToday = [dictToday objectForKey:@"2"];
                NSArray *valueVideoToday = [ParserObject getObjectsFromArray:dataVideoToday withObjectType:@"VIDEO"];
                [copyToday setValue:valueVideoToday forKey:@"2"];
                
                NSArray *dataVideoYesterday = [dictYesterday objectForKey:@"2"];
                NSArray *valueVideoYesterday = [ParserObject getObjectsFromArray:dataVideoYesterday withObjectType:@"VIDEO"];
                [copyYesterday setValue:valueVideoYesterday forKey:@"2"];
                
                NSArray *dataVideoOlder = [dictOlder objectForKey:@"2"];
                NSArray *valueVideoOlder = [ParserObject getObjectsFromArray:dataVideoOlder withObjectType:@"VIDEO"];
                [copyOlder setValue:valueVideoOlder forKey:@"2"];
                
                
                NSMutableArray *result = [[NSMutableArray alloc]init];
                [result addObject:copyToday];
                [result addObject:copyYesterday];
                [result addObject:copyOlder];
                
                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
                BOOL isFull = valueVideoOlder.count > 0;
                _completed(code,result,loadmore, isFull);
            }
            
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] userGetNewFeedPageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else if (code == kAPI_USER_NOT_LOGIN) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            //alert.tag = 111;
            [alert show];
            APPDELEGATE.user = nil;
            APPDELEGATE.isLogined = NO;
            [[APIController sharedInstance]logoutCompleted:^(BOOL result) {
                
            } failed:^(NSError * error) {
                
            }];
        } else {
            _completed(code,nil,NO,0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)userSubcribeVideo:(NSString *)videoId subcribe:(BOOL) isSubcribe  completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString* url;
    if (isSubcribe) {
        url = [NSString stringWithFormat:SUBCRIBE_VIDEO,API_URL,videoId, access_token];
    }else{
        url = [NSString stringWithFormat:UNSUBCRIBE_VIDEO,API_URL,videoId, access_token];
    }

    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(code,result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] userSubcribeVideo:videoId subcribe:isSubcribe completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else if (code == kAPI_USER_NOT_LOGIN) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thông báo" message:@"Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            //alert.tag = 111;
            [alert show];
            APPDELEGATE.user = nil;
            APPDELEGATE.isLogined = NO;
            [[APIController sharedInstance]logoutCompleted:^(BOOL result) {
                
            } failed:^(NSError * error) {
                
            }];
        } else {
            _completed(code,NO);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)getFeedbackObjectCompleted:(void (^)(int, NSArray *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_FEEDBACK,API_URL,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"FEEDBACK"];
            _completed(code,array);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getFeedbackObjectCompleted:_completed failed:_failed];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)userFeedbackWithId:(short)feedbackId content:(NSString *)content phone:(NSString*)phone completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:USER_FEEDBACK,API_URL,access_token];
    NSDictionary *dict = @{@"subjectId":[NSNumber numberWithShort:feedbackId],@"content":content, @"phone":phone};
    [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            
            if (code == kAPI_SUCCESS) {
                BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
                _completed(code,result);
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN || code == kAPI_EMPTY_TOKEN) {
                [[APIController sharedInstance]userFeedbackWithId:feedbackId content:content phone:phone completed:_completed failed:_failed];
            }
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)userCheckNotifyCompleted:(void (^)(int, NSArray *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:USER_CHECK_NOTIFY,API_URL,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            _completed(code,arrayData);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]userCheckNotifyCompleted:_completed failed:_failed];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}



- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {};

#pragma mark - Video

- (void)getHomeItemCompleted:(void (^)(int, HomeItem *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    
    NSString *url = [NSString stringWithFormat:GET_HOME_ITEM,API_URL,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *data = [responseObject objectForKey:kRESPONSE_DATA];
            if (data) {
                NSArray *array = [ParserObject getObjectsFromArray:@[data] withObjectType:@"HOME_ITEM"];
                HomeItem *homeItem = [array lastObject];
                _completed(code,homeItem);
            } else {
                _failed(nil);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getHomeItemCompleted:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];

}

- (void)getListVideoWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int ,NSArray *,BOOL, int ))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    
    NSString *url = [NSString stringWithFormat:GET_HOME_VIDEO,API_URL,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            } else {
//                _failed(nil);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getListVideoWithPageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO, 0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)getDiscoverVideoWithType:(NSString *)type pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_DISCOVER_VIDEO,API_URL,type,access_token,pageIndex,pageSize];
    
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            } else {
//                _failed(nil);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getDiscoverVideoWithType:type pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO, 0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
    
}
- (void)getVideoSuggestionWithKey:(NSString *)videoId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_SUGGESTION,API_URL,videoId,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getVideoSuggestionWithKey:videoId pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO, 0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)getListVideoByGenre:(NSString *)genreId type:(NSString *)type pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_LIST_VIDEO_BY_GENRE,API_URL,genreId,access_token,type,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getListVideoByGenre:genreId type:type pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO,0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)getVideoOfArtist:(long)artistId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_ARTIST,API_URL,artistId,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            } else {
//                _failed(nil);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_DATA_EMPTY) {
            _completed(code,nil,NO, 0);
            //[APPDELEGATE showToastWithMessage:@"Không tìm thấy dữ liệu" position:@"bottom" type:2];
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getVideoOfArtist:artistId pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO, 0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)getVideoDetailWithKey:(NSString *)videoId completed:(void (^)(int,Video *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_DETAIL,API_URL,videoId,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *dict = [responseObject objectForKey:kRESPONSE_DATA];
            if (dict) {
                NSArray *array = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"VIDEO"];
                Video *video = [array lastObject];
                _completed(code,video);
            } else {
                
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getVideoDetailWithKey:videoId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)getVideoStreamWithKey:(NSString *)videoId completed:(void (^)(int, VideoStream *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_STREAM,API_URL,videoId,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *dict = [responseObject objectForKey:kRESPONSE_DATA];
            if (dict) {
                NSArray *array = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"VIDEO_STREAM"];
                VideoStream *stream = [array lastObject];
                _completed(code,stream);
            } else {
                
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getVideoStreamWithKey:videoId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
#pragma mark - Genre
- (void)getListGenresWithParentId:(NSString *)parentId completed:(void (^)(int, NSArray *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_LIST_GENRE,API_URL,parentId,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"GENRE"];
//                _completed(code,array);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"GENRE"];
            _completed(code,array);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getListGenresWithParentId:parentId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)getMultiListGenres:(NSString *)listIds completed:(void (^)(int, NSArray *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_MULTI_LIST_GENRE,API_URL,listIds,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
            //            if (arrayData.count) {
            //                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"GENRE"];
            //                _completed(code,array);
            //            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"GENRE"];
            _completed(code,array);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getMultiListGenres:listIds completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}


- (void)getGenreDetailWithKey:(NSString *)genreId completed:(void (^)(int, Genre *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_GENRE_DETAIL,API_URL,genreId,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *dict = [responseObject objectForKey:kRESPONSE_DATA];
            if (dict) {
                NSArray *array = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"GENRE"];
                Genre *genre = [array lastObject];
                _completed(code,genre);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getGenreDetailWithKey:genreId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
#pragma mark - Channel

- (void)getDiscoverChannelWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_DISCOVER_CHANNEL,API_URL,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getDiscoverChannelWithPageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO,0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}
- (void)getListChannelsWithGenreId:(NSString*)genreId type:(NSString*)type pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_LIST_CHANNEL_BY_GENRE,API_URL,genreId,access_token,type, pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getListChannelsWithGenreId:genreId type:type pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO,0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)getChannelSuggestionWithKey:(NSString *)chanelId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_CHANNEL_SUGGETION,API_URL,chanelId,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            } else {
//                _failed(nil);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getChannelSuggestionWithKey:chanelId pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        }else {
            _completed(code,nil,NO, 0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)getChannelOfArtist:(long)artistId pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_CHANNEL_ARTIST, API_URL,artistId,access_token,pageIndex,pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code,array,loadmore, total);
//            } else {
//                _failed(nil);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code,array,loadmore, total);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getChannelOfArtist:artistId pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil,NO, 0);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)getChannelDetailWithKey:(NSString *)channelId completed:(void (^)(int, Channel*))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_CHANNEL_DETAIL,API_URL, channelId, access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *dict = [responseObject objectForKey:kRESPONSE_DATA];
            if (dict) {
                NSArray *array = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"CHANNEL"];
                Channel *channel = [array lastObject];
                _completed(code,channel);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getChannelDetailWithKey:channelId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void)ratingChannel:(NSString *)channelId score:(int)score completed:(void (^)(int, BOOL))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:RATING_CHANNEL,API_URL,channelId, access_token,score];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            BOOL result = [[responseObject objectForKey:kRESPONSE_DATA]boolValue];
            _completed(code,result);
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] ratingChannel:channelId score:score completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,NO);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

#pragma mark - Season
- (void)getSeasonDetailWithKey:(NSString *)seasonId completed:(void (^)(int, Season *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_SEASON_DETAIL,API_URL,seasonId,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSDictionary *dict = [responseObject objectForKey:kRESPONSE_DATA];
            if (dict) {
                NSArray *array = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"SEASON"];
                Season *season = [array lastObject];
                _completed(code,season);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getSeasonDetailWithKey:seasonId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

#pragma mark - Artist
- (void)getArtistDetailWithKey:(long)artistId completed:(void (^)(int, Artist *))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_ARTIST_DETAIL,API_URL,artistId,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == 0) {
            NSDictionary *dict = [responseObject objectForKey:kRESPONSE_DATA];
            if (dict) {
                NSArray *array = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"ARTIST"];
                Artist *artist = [array lastObject];
                _completed(code,artist);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getArtistDetailWithKey:artistId completed:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

- (void) getListArtistHotWithPageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_ARTISTS_HOT, API_URL, access_token, pageIndex, pageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//            if (arrayData.count) {
//                NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"ARTIST"];
//                BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                _completed(code, array,loadmore, total);
//            } else {
//                _failed(nil);
//            }
            NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"ARTIST"];
            BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
            int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
            _completed(code, array,loadmore, total);
        }  else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[TokenManager sharedInstance] loadDataWithAccessToken:^(NSString *accessToken){
                if (accessToken) {
                    [self getListArtistHotWithPageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
                }
            }failed:^(NSError *error){
                _failed(error);
            }];
        } else if (code == kAPI_DATA_EMPTY || code == kAPI_EXPIRED_TOKEN){
            _failed(nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
}

#pragma mark - Search
- (void)searchVideoByKeyword:(NSString *)keyword pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    if (keyword) {
        NSString *probablyEmpty = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        BOOL wereOnlySpaces = [probablyEmpty isEqualToString:@""];
        if (!wereOnlySpaces) {
            NSString *access_token = [Utilities getAccessToken];
            NSString *url = [NSString stringWithFormat:SEARCH_VIDEO,API_URL,access_token,pageIndex,pageSize];
            NSDictionary *dict = @{@"keyword":keyword};
            [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
                NSLog(@"responseObject: %@", responseObject);
#endif
                int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
                if (code == kAPI_SUCCESS) {
                    NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//                    if (arrayData.count) {
//                        NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
//                        BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                        int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                        _completed(code,array,loadmore, total);
//                    } else {
//                        _failed(nil);
//                    }
                    NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"VIDEO"];
                    BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
                    int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
                    _completed(code,array,loadmore, total);
                } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
                    [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                        [[APIController sharedInstance] searchVideoByKeyword:keyword pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
                    } failed:^(NSError *error) {
                        _failed(error);
                    }];
                } else {
                    _completed(code,nil,NO, 0);
                }
            } failed:^(NSError *error) {
#if DEBUG_RESULT
                NSLog(@"error: %@", [error description]);
#endif
                _failed(error);
            }];
        }
    }
}
- (void)searchChannelByKeyword:(NSString *)keyword pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    if (keyword) {
        NSString *probablyEmpty = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        BOOL wereOnlySpaces = [probablyEmpty isEqualToString:@""];
        if (!wereOnlySpaces) {
            NSString *access_token = [Utilities getAccessToken];
            NSString *url = [NSString stringWithFormat:SEARCH_CHANNEL,API_URL,access_token,pageIndex,pageSize];
            NSDictionary *dict = @{@"keyword":keyword};
            [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
                NSLog(@"responseObject: %@", responseObject);
#endif
                int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
                if (code == kAPI_SUCCESS) {
                    NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//                    if (arrayData.count) {
//                        NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
//                        BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                        int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                        _completed(code,array,loadmore, total);
//                    } else {
//                        _failed(nil);
//                    }
                    NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"CHANNEL"];
                    BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
                    int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
                    _completed(code,array,loadmore, total);
                } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
                    [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                        [[APIController sharedInstance] searchChannelByKeyword:keyword pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
                    } failed:^(NSError *error) {
                        _failed(error);
                    }];
                } else {
                    _completed(code,nil,NO, 0);
                }
            } failed:^(NSError *error) {
#if DEBUG_RESULT
                NSLog(@"error: %@", [error description]);
#endif
                _failed(error);
            }];
        }
    }
}
- (void)searchArtistByKeyword:(NSString *)keyword pageIndex:(int)pageIndex pageSize:(int)pageSize completed:(void (^)(int, NSArray *, BOOL, int))_completed failed:(void (^)(NSError *))_failed {
    if (keyword) {
        NSString *probablyEmpty = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        BOOL wereOnlySpaces = [probablyEmpty isEqualToString:@""];
        if (!wereOnlySpaces) {
            NSString *access_token = [Utilities getAccessToken];
            NSString *url = [NSString stringWithFormat:SEARCH_ARTIST,API_URL,access_token,pageIndex,pageSize];
            NSDictionary *dict = @{@"keyword":keyword};
            [httpClient postWithNonSerializerURL:url withParams:dict completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
                NSLog(@"responseObject: %@", responseObject);
#endif
                int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
                if (code == kAPI_SUCCESS) {
                    NSArray *arrayData = [responseObject objectForKey:kRESPONSE_DATA];
//                    if (arrayData.count) {
//                        NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"ARTIST"];
//                        BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
//                        int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
//                        _completed(code,array,loadmore, total);
//                    } else {
//                        _failed(nil);
//                    }
                    NSArray *array = [ParserObject getObjectsFromArray:arrayData withObjectType:@"ARTIST"];
                    BOOL loadmore = [[responseObject objectForKey:kRESPONSE_LOADMORE]boolValue];
                    int total = [[responseObject objectForKey:kRESPONSE_TOTAL]intValue];
                    _completed(code,array,loadmore, total);
                } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
                    [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                        [[APIController sharedInstance] searchArtistByKeyword:keyword pageIndex:pageIndex pageSize:pageSize completed:_completed failed:_failed];
                    } failed:^(NSError *error) {
                        _failed(error);
                    }];
                } else {
                    _completed(code,nil,NO, 0);
                }
            } failed:^(NSError *error) {
#if DEBUG_RESULT
                NSLog(@"error: %@", [error description]);
#endif
                _failed(error);
            }];
        }
    }
}

- (void)getTopKeyWordsCompleted:(void (^)(int, NSArray*))_completed failed:(void (^)(NSError *))_failed {
    NSString *access_token = [Utilities getAccessToken];
    
    NSString *url = [NSString stringWithFormat:GET_TOP_KEY_WORD,API_URL,access_token];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
        NSLog(@"responseObject: %@", responseObject);
#endif
        int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
        if (code == kAPI_SUCCESS) {
            NSArray *data = [responseObject objectForKey:kRESPONSE_DATA];
            if (data) {
                NSArray *array = [ParserObject getObjectsFromArray:data withObjectType:@"TOPKEYWORD"];
                _completed(code,array);
            } else {
                _failed(nil);
            }
        } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN || code == kAPI_EMPTY_TOKEN){
            [[APIController sharedInstance]getAccessTokenCompleted:^(id resulf) {
                [[APIController sharedInstance] getTopKeyWordsCompleted:_completed failed:_failed];
            } failed:^(NSError *error) {
                _failed(error);
            }];
        } else {
            _completed(code,nil);
        }
    } failed:^(NSError *error) {
#if DEBUG_RESULT
        NSLog(@"error: %@", [error description]);
#endif
        _failed(error);
    }];
    
}

#pragma mark - OLDVERISON

-(void)loginWithUserName:(NSString *)user_name withPassword:(NSString *)password completed:(void (^)(User *))_completed failed:(void (^)(NSError *))_failed{
        NSString *accessToken = [[Util sharedInstance]getAccessToken];
        NSString *username64 = [[user_name base64EncodedString] stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSString *pass64 = [[password base64EncodedString] stringByReplacingOccurrencesOfString:@"=" withString:@""];
        NSString *url = [NSString stringWithFormat:LOGIN, API_URL, accessToken, username64, pass64];
        [httpClient postWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            NSDictionary *data = [responseObject objectForKey:@"data"];
            if (data) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
                [dict setObject:password forKey:@"7"];
                NSArray *results = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"USERINFO"];
                
//                NSDictionary *tokenDic = [data objectForKey:@"6"];
//                NSArray *tokens = [ParserObject getObjectsFromArray:@[tokenDic] withObjectType:@"TOKEN"];
//                [[TokenManager sharedInstance] setToken:[tokens lastObject]];

                _completed([results lastObject]);
                
            }else{
                _failed(nil);
            }
        } failed:^(NSError *error) {
            _failed(error);
        }];
}

- (void)loginWithFacebookUserId:(NSString*)fbuserid withAvatar:(NSString*)fbavatar withFullName:(NSString*) fbfullname withUserName:(NSString*) fbusername withAccessKey:(NSString*) fbaccessKey withEmail:(NSString*) fbemail completed:(void(^)(User* result))_completed failed:(void (^)(NSError* error))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
        NSString *url = [NSString stringWithFormat:LOGIN_FACEBOOK, API_URL, accessToken, fbuserid, fbavatar, fbfullname, fbusername, fbaccessKey, fbemail];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [httpClient postWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
            if (responseObject) {
                #if DEBUG_RESULT
                    NSLog(@"responseObject: %@", responseObject);
                #endif
                int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
                if (code == kAPI_SUCCESS) {
                    NSDictionary *data = [responseObject objectForKey:@"data"];
                    if (data) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
                        NSArray *results = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"USERINFO"];
                        if (results) {
                            if (_completed) {
                                _completed([results lastObject]);
                            }
                        }
                    }else{
                        _failed(nil);
                    }
                } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN){
                    [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                        [self loginWithFacebookUserId:fbuserid withAvatar:fbavatar withFullName:fbfullname withUserName:fbusername withAccessKey:fbaccessKey withEmail:fbemail completed:_completed failed:_failed];
                    }failed:^(NSError *error){
                        _failed(error);
                    }];
                }
                
            } else {
                if (_failed) {
                    _failed(nil);
                }
            }

        } failed:^(NSError *error) {
            _failed(error);
        }];
}

- (void)loginWithGoogleUserId:(NSString *)ggUserId withAvatar:(NSString *)ggAvatar withFullName:(NSString *)ggFullName withUserName:(NSString*)ggUserName withAccessKey:(NSString *)ggAccessKey withEmail:(NSString *)ggEmail completed:(void (^)(User *result))_completed failed:(void (^)(NSError *))_failed {
    NSString *accessToken = [UserDefaultManager getAccessToken];
        NSString *url = [NSString stringWithFormat:LOGIN_GOOGLEPLUS, API_URL, accessToken, ggUserId, ggAvatar, ggFullName, ggUserName, ggAccessKey, ggEmail];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [httpClient postWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
            if (responseObject) {
#if DEBUG_RESULT
                NSLog(@"responseObject: %@", responseObject);
#endif
                int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
                if (code == kAPI_SUCCESS) {
                    NSDictionary *data = [responseObject objectForKey:@"data"];
                    if (data) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:data];
                        NSArray *results = [ParserObject getObjectsFromArray:@[dict] withObjectType:@"USERINFO"];
                        if (_completed) {
                            _completed([results lastObject]);
                        }
                    }else{
                        _failed(nil);
                    }
                } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN){
                    [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                        [self loginWithGoogleUserId:ggUserId withAvatar:ggAvatar withFullName:ggFullName withUserName:ggUserName withAccessKey:ggAccessKey withEmail:ggEmail completed:_completed failed:_failed];
                    }failed:^(NSError *error){
                        _failed(error);
                    }];
                }
            } else {
                _failed(nil);
            }
        } failed:^(NSError *error) {
            _failed(error);
        }];
}

-(void)getHomeCompleted:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_HOME, API_URL, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    NSArray *showCase = [ParserObject getObjectsFromArray:[data objectForKey:@"Showcase"] withObjectType:@"SHOWCASE"];
                    [array addObject:showCase];
                    NSArray *video = [ParserObject getObjectsFromArray:[data objectForKey:@"VideoNewHot"] withObjectType:@"VIDEO"];
                    [array addObject:video];
                    NSArray *entertainment = [ParserObject getObjectsFromArray:[data objectForKey:@"Entertaiment"] withObjectType:@"VIDEO"];
                    [array addObject:entertainment];
                    NSArray *cartoon = [ParserObject getObjectsFromArray:[data objectForKey:@"Cartoon"] withObjectType:@"SHOW"];
                    [array addObject:cartoon];
                    NSArray *tvshow = [ParserObject getObjectsFromArray:[data objectForKey:@"TVShow" ] withObjectType:@"SHOW"];
                    [array addObject:tvshow];
                    NSArray *movie = [ParserObject getObjectsFromArray:[data objectForKey:@"Movie"] withObjectType:@"SHOW"];
                    [array addObject:movie];
                    if (_completed) {
                        _completed(array);
                    }
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN){
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    [self getHomeCompleted:_completed failed:_failed];
                }failed:^(NSError *error){
                    _failed(error);
                }];
//                if (_completed) {
//                    _completed(code, nil);
//                }
            }
        }

        
    } failed:^(NSError *error) {
        _failed(error);
    }];
    
}

-(void)getShowByGenre:(NSString *)genre_id withPage:(NSString*)page withSort:(NSString*)sort completed:(void (^)( NSArray *, BOOL, NSString*, NSString*))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
        NSString *user_id = [APPDELEGATE getUserID];
        NSString *url = [NSString stringWithFormat:GET_SHOW_BY_GENRE, API_URL, accessToken, genre_id, user_id, page,kPageSize, sort];
        
        [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
            if (responseObject) {
#if DEBUG_RESULT
                NSLog(@"responseObject: %@", responseObject);
#endif
                int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
                if (code == kAPI_SUCCESS) {
                    NSArray *data = [responseObject objectForKey:@"data"];
                    if (data) {
                        BOOL isMore = [[responseObject objectForKey:@"loadmore"] boolValue];
                        NSArray *lstShow = [ParserObject getObjectsFromArray:data withObjectType:@"SHOW"];
                        _completed(lstShow, isMore, genre_id, sort);
                        
                    }else{
                        _failed(nil);
                    }
                } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN){
                    [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                        if (accessToken) {
                            [self getShowByGenre:genre_id withPage:page withSort:sort completed:_completed failed:_failed];
                        }
                    }failed:^(NSError *error){
                        _failed(error);
                    }];
                }
            } else {
                _failed(nil);
            }

            
        } failed:^(NSError *error) {
            _failed(error);
        }];
}

-(void)getListSubGenre:(NSString *)genre_id completed:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_LIST_SUB_GENRE, API_URL, genre_id, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *lstGenre = [ParserObject getObjectsFromArray:[data objectForKey:@"ListGenre"] withObjectType:@"GENRE"];
                    _completed(lstGenre);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getListSubGenre:genre_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
        } else {
            _failed(nil);
        }
    } failed:^(NSError *error) {
        _failed(error);
    }];
  
}

-(void)getSearchShow:(NSString *)keyword withGenre:(NSString *)genre_id withPageIndex:(NSString *)page completed:(void (^)(NSArray *, BOOL))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
//    NSString *keyword64 = [keyword stringByReplacingOccurrencesOfString:@"=" withString:@""];
//    NSString *keyword64 = [keyword stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *url = [NSString stringWithFormat:GET_SEARCH_SHOW, API_URL, accessToken];
    NSString *pagesize = IS_IPAD ? @"30" : @"6";
    NSDictionary *params = @{@"keyword":keyword, @"genreid":genre_id, @"pageindex":page, @"pagesize":pagesize};
    [httpClient postWithNonSerializerURL:url withParams:params completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    BOOL isMore = [[responseObject objectForKey:@"loadmore"] boolValue];
                    NSArray *lstGenre = [ParserObject getObjectsFromArray:data withObjectType:@"SHOW"];
                    _completed(lstGenre, isMore);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN){
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getSearchShow:keyword withGenre:genre_id withPageIndex:page completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            } else if ( code == kAPI_DATA_NOT_EXIST) {
                [self postNotificationDataNotExist];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getSearchVideos:(NSString *)keyword withPageIndex:(NSString *)page completed:(void (^)(NSArray *, BOOL))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_SEARCH_VIDEO, API_URL, accessToken];
    NSString *pagesize = IS_IPAD ? @"30" : @"10";
    NSDictionary *params = @{@"keyword":keyword,  @"pageindex":page, @"pagesize":pagesize};
    [httpClient postWithNonSerializerURL:url withParams:params completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    BOOL isMore = [[responseObject objectForKey:@"loadmore"] boolValue];
                    NSArray *lstGenre = [ParserObject getObjectsFromArray:data withObjectType:@"VIDEO"];
                    _completed(lstGenre, isMore);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN){
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getSearchVideos:keyword withPageIndex:page completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            } else if ( code == kAPI_DATA_NOT_EXIST) {
                [self postNotificationDataNotExist];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getShowDetailWithId:(NSString *)show_id completed:(void (^)(Channel *, NSString *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_SHOW_DETAIL, API_URL, show_id, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *items = [ParserObject getObjectsFromArray:@[data] withObjectType:@"CHANNEL"];
                    _completed([items lastObject], json);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getShowDetailWithId:show_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }
    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getVideoBySeasonWithId:(NSString *)show_id completed:(void (^)(NSArray *, NSString *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_BY_SEASON, API_URL, show_id, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *items = [ParserObject getObjectsFromArray:data withObjectType:@"VIDEO"];
                    _completed(items, json);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getVideoBySeasonWithId:show_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getVideoDetailWithId:(NSString *)video_id completed:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_DETAIL, API_URL, video_id, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *items = [ParserObject getObjectsFromArray:@[data] withObjectType:@"VIDEO"];
                    _completed(items);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getVideoDetailWithId:video_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getVideoLikedWithPageIndex:(NSString *)page completed:(void (^)(NSArray *, BOOL))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_LIKED, API_URL, accessToken, page, kPageSize];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    BOOL isMore = [[responseObject objectForKey:@"loadmore"] boolValue];
                    NSArray *items = [ParserObject getObjectsFromArray:data withObjectType:@"VIDEO"];
                    _completed(items, isMore);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN || code == kAPI_USER_NOT_LOGIN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getVideoLikedWithPageIndex:page completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            } else {
                [self postNotificationUserNotLogin];
            }
            
        } else {
            _failed(nil);
        }
    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getVideoRelatedWithId:(NSString *)video_id completed:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_RELATED, API_URL, video_id, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *items = [ParserObject getObjectsFromArray:data withObjectType:@"VIDEO"];
                    _completed(items);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getVideoRelatedWithId:video_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getShowRelatedWithId:(NSString *)show_id completed:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_SHOW_RELATED, API_URL, show_id, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *items = [ParserObject getObjectsFromArray:data withObjectType:@"SHOW"];
                    _completed(items);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getShowRelatedWithId:show_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)getHotKeywordCompleted:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_HOT_KEY, API_URL, accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    _completed(data);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getHotKeywordCompleted:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

-(void)likeVideo:(NSString *)video_id completed:(void (^)(NSString *, BOOL))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:LIKE_VIDEO, API_URL, video_id, accessToken];
    [httpClient postWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (data) {
                    _completed(nil, [[data objectForKey:@"2"] boolValue]);
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN || code == kAPI_USER_NOT_LOGIN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self likeVideo:video_id completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
        NSLog(@"CALL API LIKE FAIL");

    }];
}

-(void)getVideoByGenre:(NSString *)genre_id withPage:(NSString*)page withSort:(NSString*)sort completed:(void (^)(NSArray *, BOOL, NSString*))_completed failed:(void (^)(NSError *))_failed{
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *user_id = [APPDELEGATE getUserID];
    NSString *url = [NSString stringWithFormat:GET_VIDEO_BY_GENRE, API_URL, genre_id, accessToken, user_id, page, kPageSize, sort];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json) {
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSArray *data = [responseObject objectForKey:@"data"];
                if (data) {
                    BOOL isMore = [[responseObject objectForKey:@"loadmore"] boolValue];
                    NSArray *lstVideo = [ParserObject getObjectsFromArray:data withObjectType:@"VIDEO"];
                    _completed(lstVideo, isMore, genre_id);
                    
                }else{
                    _failed(nil);
                }
            } else if (code == kAPI_INVALID_TOKEN || code == kAPI_EXPIRED_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getVideoByGenre:genre_id withPage:page withSort:sort completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
            
        } else {
            _failed(nil);
        }

    } failed:^(NSError *error) {
        _failed(error);
    }];
}

- (void)getSubtitleWithWideoKey:(NSString *)video_key completed:(void (^)(NSArray *))_completed failed:(void (^)(NSError *))_failed {
    NSString *accessToken = [UserDefaultManager getAccessToken];
    NSString *url = [NSString stringWithFormat:GET_SUBTITLE,API_URL,video_key,accessToken];
    [httpClient getWithURL:url withParams:nil completed:^(id responseObject, NSString *json){
        if (responseObject) {
#if DEBUG_RESULT
            NSLog(@"responseObject: %@", responseObject);
#endif
            int code = [[responseObject objectForKey:kRESPONSE_CODE]intValue];
            if (code == kAPI_SUCCESS) {
                NSDictionary *data = [responseObject objectForKey:@"data"];
                if (data) {
                    NSArray *sub = [ParserObject getObjectsFromArray:@[data] withObjectType:@"SUBTITLE"];
                    _completed(sub);
                }
            } else if (code == kAPI_EXPIRED_TOKEN || code == kAPI_INVALID_TOKEN) {
                [[TokenManager sharedInstance]loadDataWithAccessToken:^(NSString *accessToken){
                    if (accessToken) {
                        [self getSubtitleWithWideoKey:video_key completed:_completed failed:_failed];
                    }
                }failed:^(NSError *error){
                    _failed(error);
                }];
            }
        }
    }failed:^(NSError *error){
        if (_failed) {
            _failed(error);
        }
    }];
}

- (void)postNotificationUserNotLogin {
    [[NSNotificationCenter defaultCenter]postNotificationName:kUserNotLoginNotification object:nil];
}

- (void)postNotificationDataNotExist {
    [[NSNotificationCenter defaultCenter]postNotificationName:kDataNotExistNotification object:nil];
}
@end
