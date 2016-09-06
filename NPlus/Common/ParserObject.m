//
//  ParserObject.m
//  NPlus
//
//  Created by TEVI Team on 7/29/14.
//  Copyright (c) 2014 TEVI Team. All rights reserved.
//

#import "ParserObject.h"
#import "Channel.h"
#import "Video.h"
#import "Season.h"
#import "Genre.h"
#import "TokenInfo.h"
#import "SubTitle.h"
#import "RC4Crypt.h"
#import "QualityURL.h"
#import "Artist.h"
#import "VideoStream.h"
#import "RelatedItem.h"
#import "Showcase.h"
#import "HomeItem.h"
#import "LocalNotif.h"
#import "TopKeyword.h"
#import "Feedback.h"

@implementation ParserObject
+ (NSMutableArray *) getObjectsFromArray: (NSArray *) dataArray{
    return [[NSMutableArray alloc] init];
}
+ (NSMutableArray *) getObjectsFromArray: (NSArray *) dataArray withObjectType:(NSString*)ObjType
{
    NSMutableArray *data = [[NSMutableArray alloc] init];
	for (NSDictionary *element in dataArray)
    {
		if([ObjType isEqualToString:@"VIDEO"]){
            Video *item = [[Video alloc] init];
            item.video_id = [[element objectForKey:@"1"] description];
            item.video_title = [[element objectForKey:@"2"] description];
            item.video_subtitle = [[element objectForKey:@"3"] description];
            item.video_shortDes = [[element objectForKey:@"4"] description];
            item.video_image = [[element objectForKey:@"5"] description];
            item.video_image = [item.video_image stringByReplacingOccurrencesOfString:@".jpg" withString:@"_460.jpg"];
            item.time = [[element objectForKey:@"6"] description];
            item.duration = [item.time intValue];
            item.time = [Utilities timeFormatted:item.duration];
            NSArray *arrayGenres = [element objectForKey:@"7"];
            if (arrayGenres.count && ![[arrayGenres description]isEqualToString:@""]) {
                item.genres = [ParserObject getObjectsFromArray:arrayGenres withObjectType:@"GENRE"];
            }
            NSArray *arrayChannels = [element objectForKey:@"8"];
            if (arrayChannels.count && ![[arrayChannels description]isEqualToString:@""]) {
                item.channels = [ParserObject getObjectsFromArray:arrayChannels withObjectType:@"CHANNEL"];
            }
            item.viewCount = [[element objectForKey:@"9"]intValue];
            item.link_share = [[element objectForKey:@"10"] description];
            item.isSingle = [[element objectForKey:@"11"]boolValue];
            item.is_like = [[element objectForKey:@"12"]boolValue];
            item.seasonKey = [[element objectForKey:@"13"]description];
            item.dateCreated = [[element objectForKey:@"14"]longLongValue];
            item.isHD = [[element objectForKey:@"15"]boolValue];
            [data addObject:item];
        }else if ([ObjType isEqualToString:@"CHANNEL"])
        {
            Channel *item = [[Channel alloc] init];
            item.channelId = [[element objectForKey:@"1"] description];
            item.channelName = [[element objectForKey:@"2"] description];
            item.channelDes = [[element objectForKey:@"3"] description];
            item.national = [[element objectForKey:@"4"] description];
            item.broadcast = [[element objectForKey:@"5"] description];
            item.thumb = [[element objectForKey:@"6"] description];
            item.fullImg = [[element objectForKey:@"7"] description];
            item.thumb = [item.fullImg stringByReplacingOccurrencesOfString:@".jpg" withString:@"_460.jpg"];
            NSArray *genres = [element objectForKey:@"8"];
            if (genres.count && ![[genres description]isEqualToString:@""]) {
                item.genres = [ParserObject getObjectsFromArray:genres withObjectType:@"GENRE"];
            }
            item.rating = [[element objectForKey:@"9"] doubleValue];
            item.view = [[element objectForKey:@"10"] intValue];
//            item.relationKey = [[element objectForKey:@"11"] description];
            NSArray *artists = [element objectForKey:@"11"];
            if (artists.count && ![[artists description]isEqualToString:@""]) {
                item.artists = [ParserObject getObjectsFromArray:artists withObjectType:@"ARTIST"];
            }
            NSArray *seasons = [element objectForKey:@"12"];
            if (seasons.count && ![[seasons description]isEqualToString:@""]) {
                item.seasons = [ParserObject getObjectsFromArray:seasons withObjectType:@"SEASON"];
            }
            item.linkShare = [[element objectForKey:@"13"] description];
            item.director = [[element objectForKey:@"14"] description];
            item.producer = [[element objectForKey:@"15"] description];
            item.totalUserRating = [[element objectForKey:@"16"] longValue];
            item.isSubcribe = [[element objectForKey:@"17"]boolValue];
            item.totalFollow = [[element objectForKey:@"18"] longValue];
            item.videoKey = [[element objectForKey:@"19"]description];
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"GENRE"])
        {
            Genre *item = [[Genre alloc] init];
            item.genreId = [[element objectForKey:@"1"] description];
            item.genreName = [[element objectForKey:@"2"] description];
            NSArray *genres = [element objectForKey:@"3"];
            if (genres.count > 0 && ![[genres description]isEqualToString:@""]) {
                item.childGenres = [ParserObject getObjectsFromArray:genres withObjectType:@"GENRE"];
                item.isParent = YES;
            }
            item.parentKey = [[element objectForKey:@"4"] description];
            [data addObject:item];
        }else if([ObjType isEqualToString:@"SEASON"]){
            Season *item = [[Season alloc] init];

            item.seasonId = [[element objectForKey:@"1"]description];
            item.seasonName = [[element objectForKey:@"2"]description];
            item.seasonDes = [[element objectForKey:@"3"]description];
            item.imgUrl = [[element objectForKey:@"4"]description];
            item.imgUrl = [item.imgUrl stringByReplacingOccurrencesOfString:@".jpg" withString:@"_300.jpg"];
            item.videosCount = [[element objectForKey:@"5"]intValue];
            NSArray *arrayVideos = [element objectForKey:@"6"];
            if (arrayVideos.count && ![[arrayVideos description]isEqualToString:@""]) {
                item.videos = [ParserObject getObjectsFromArray:arrayVideos withObjectType:@"VIDEO"];
            }
            item.type = [[element objectForKey:@"7"]intValue];
            
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"QUALITY"]) {
            QualityURL *quality = [[QualityURL alloc]init];
            quality.type = [[element objectForKey:@"1"]description];
            quality.link = [[element objectForKey:@"2"]description];
            [data addObject:quality];
        }
        else if ([ObjType isEqualToString:@"VIDEO_STREAM"]){
            VideoStream *item = [[VideoStream alloc]init];
            item.videoStreamId = [[element objectForKey:@"1"]description];
            NSArray *arrayUrls = [element objectForKey:@"2"];
            if (arrayUrls.count && ![[arrayUrls description]isEqualToString:@""]) {
                item.streamUrls = [ParserObject getObjectsFromArray:arrayUrls withObjectType:@"QUALITY"];
            }
            NSArray *arrayDownloads = [element objectForKey:@"3"];
            if (arrayDownloads.count && ![[arrayDownloads description]isEqualToString:@""]) {
                item.streamDownloads = [ParserObject getObjectsFromArray:arrayDownloads withObjectType:@"QUALITY"];
            }
            
            [data addObject:item];
            
        } else if([ObjType isEqualToString:@"USERINFO"]){
            User *user = [[User alloc] init];
            user.userName = [[element objectForKey:@"1"] description];
            user.displayName = [[element objectForKey:@"2"] description];
            [data addObject:user];
        }else if([ObjType isEqualToString:@"TOKEN"]){
            TokenInfo *accessToken = [[TokenInfo alloc] init];
            accessToken.token = [element objectForKey:@"2"];
            accessToken.timeExpire = [[element objectForKey:@"3"]longLongValue];
            NSDate *dateExprite = [NSDate dateWithTimeIntervalSince1970:accessToken.timeExpire/1000];
            NSString *dateString = [NSDateFormatter localizedStringFromDate:dateExprite
                                                                  dateStyle:NSDateFormatterShortStyle
                                                                  timeStyle:NSDateFormatterFullStyle];
            accessToken.strExpire = dateString;
            if ([element objectForKey:@"1"]) {
                accessToken.refToken = [element objectForKey:@"1"];
                [Utilities saveRefreshToken:accessToken.refToken];
            }
            [Utilities saveAccessToken:accessToken.token];
            [data addObject:accessToken];
        }else if([ObjType isEqualToString:@"APPRELATED"]){
            RelatedItem *item = [[RelatedItem alloc] init];
            item.iconURL = [[element objectForKey:@"1"] description];
            item.appName = [[element objectForKey:@"2"] description];
            item.desc = [[element objectForKey:@"3"] description];
            item.linkDown = [[element objectForKey:@"4"] description];
            item.promote = [[element objectForKey:@"5"] description];
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"SUBTITLE"]) {
            SubTitle *item = [[SubTitle alloc]init];
            item.subtitle_id = [[element objectForKey:@"1"] description];
            item.subtitle = [[element objectForKey:@"2"] description];
            item.subtitle_timed = [[element objectForKey:@"3"] description];
            item.subtitle_decryptionKey = [[element objectForKey:@"4"] description];
            [data addObject:item];
        } else if([ObjType isEqualToString:@"ARTIST"]){
            Artist *item = [[Artist alloc]init];
            item.artistId = [[element objectForKey:@"1"]longValue];
            item.name = [[element objectForKey:@"12"]description];
            item.alias = [[element objectForKey:@"3"]description];
            item.gender = [[element objectForKey:@"4"]description];
            item.birthday = [[element objectForKey:@"5"]description];
            item.fullDes = [[element objectForKey:@"6"]description];
            item.type = [[element objectForKey:@"7"]description];
            item.blood = [[element objectForKey:@"8"]description];
            item.national = [[element objectForKey:@"9"]description];
            item.avatarImg = [[element objectForKey:@"10"]description];
            item.avatarImg = [item.avatarImg stringByReplacingOccurrencesOfString:@".jpg" withString:@"_150.jpg"];
            item.shortLink = [[element objectForKey:@"11"]description];
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"VERSION"]) {
            VersionEntity *item = [[VersionEntity alloc]init];
            item.isUpdate = [[element objectForKey:@"1"]boolValue];
            item.url = [[element objectForKey:@"2"]description];
            item.msg = [[element objectForKey:@"3"]description];
            item.foreUpdate = [[element objectForKey:@"4"]boolValue];
            item.news = [[element objectForKey:@"5"]description];
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"SHOWCASE"]) {
            Showcase *item = [[Showcase alloc]init];
            item.title = [[element objectForKey:@"1"] description];
            item.image = [[element objectForKey:@"2"] description];
            item.type = [[element objectForKey:@"3"] description ];
            item.itemKey = [[element objectForKey:@"4"] description];
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"HOME_ITEM"]) {
            NSArray *listDataShowcase = [element objectForKey:@"1"];
            NSArray *listShowcase = [ParserObject getObjectsFromArray:listDataShowcase withObjectType:@"SHOWCASE"];
            NSArray *listDataVideoHot = [element objectForKey:@"2"];
            NSArray *listVideoHot = [ParserObject getObjectsFromArray:listDataVideoHot withObjectType:@"VIDEO"];
            NSArray *listDataVideoNew = [element objectForKey:@"3"];
            NSArray *listVideoNew = [ParserObject getObjectsFromArray:listDataVideoNew withObjectType:@"VIDEO"];
            NSArray *listDataShortFilm = [element objectForKey:@"4"];
            NSArray *listShortFilm = [ParserObject getObjectsFromArray:listDataShortFilm withObjectType:@"CHANNEL"];
            NSArray *listDataTVShow = [element objectForKey:@"5"];
            NSArray *listTVShow = [ParserObject getObjectsFromArray:listDataTVShow withObjectType:@"CHANNEL"];
            NSArray *listDataRelax = [element objectForKey:@"6"];
            NSArray *listRelax = [ParserObject getObjectsFromArray:listDataRelax withObjectType:@"CHANNEL"];
            
            HomeItem *item = [[HomeItem alloc]init];
            item.listShowcases = listShowcase;
            item.listVideoHot = listVideoHot;
            item.listVideoNew = listVideoNew;
            item.listShortFilm = listShortFilm;
            item.listTVShow = listTVShow;
            item.listRelax = listRelax;
            [data addObject:item];
        } else if ([ObjType isEqualToString:@"NOTIFICATION"]) {
            LocalNotif *item = [[LocalNotif alloc]init];
            item.key = [[element objectForKey:@"1"]description];
            item.type = [[element objectForKey:@"2"] description];
            item.url = [[element objectForKey:@"3"]description];
            item.desc = [[element objectForKey:@"4"]description];
            long long longTime = [[element objectForKey:@"5"]longLongValue];
            item.time = [Utilities stringDateFromMiliseconds:longTime/1000];
            [data addObject:item];
        } else if([ObjType isEqualToString:@"TOPKEYWORD"]){
            TopKeyword *topkeyword = [[TopKeyword alloc]init];
            topkeyword.title = [[element objectForKey:@"1"] description];
            topkeyword.type = [[element objectForKey:@"2"] description];
            topkeyword.itemkey = [[element objectForKey:@"3"] description];
            [data addObject:topkeyword];
        } else if ([ObjType isEqualToString:@"FEEDBACK"]) {
            Feedback *item = [[Feedback alloc]init];
            item.feedbackId = [[element objectForKey:@"1"]shortValue];
            item.title = [[element objectForKey:@"2"]description];
            [data addObject:item];
        }
        
	}
    return data;
}

+ (id)getShowFromJson:(NSString *)json{
    if (json == nil) {
        return nil;
    }
    NSError *jsonError = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&jsonError];
    NSDictionary *data = [dict objectForKey:@"data"];
    if (data) {
        NSArray *items = [ParserObject getObjectsFromArray:@[data] withObjectType:@"SHOWFULL"];
        return [items lastObject];
    }
    return nil;
}

+(NSArray *)getVideosFromJson:(NSString *)json{
    if (json == nil) {
        return nil;
    }
    NSError *jsonError = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&jsonError];
    NSArray *data = [dict objectForKey:@"data"];
    if (data) {
        NSArray *items = [ParserObject getObjectsFromArray:data withObjectType:@"VIDEO"];
        for (Video *video in items) {
            video.stream_url = nil;
            video.link_down = nil;
        }
        return items;
    }
    return nil;
}

+ (NSString*)resizeShowThumb:(NSString*)image_thumb forType:(BOOL)isMovie{
    if (isMovie) {
        if (IS_IPHONE_6 || IS_IPHONE_6P || (IS_IPAD && IS_RETINA)) {
            if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
                NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
                NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
                subString = [[subString stringByAppendingString:@"_400"] stringByAppendingString:prefix];
                return subString;
            }
        }else{
            if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
                NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
                NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
                subString = [[subString stringByAppendingString:@"_240"] stringByAppendingString:prefix];
                return subString;
            }
        }
        return image_thumb;
    }else{
        if (IS_IPHONE_6 || IS_IPHONE_6P || (IS_IPAD && IS_RETINA)) {
            if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
                NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
                NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
                subString = [[subString stringByAppendingString:@"_500"] stringByAppendingString:prefix];
                return subString;
            }
        }else{
            if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
                NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
                NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
                subString = [[subString stringByAppendingString:@"_250"] stringByAppendingString:prefix];
                return subString;
            }
        }
    }
    return nil;
}

+ (NSString*)resizeShowCaseThumb:(NSString*)image_thumb{
    if (IS_IPHONE_6 || IS_IPHONE_6P || (IS_IPAD && IS_RETINA)) {
        if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
            NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
            NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
            subString = [[subString stringByAppendingString:@"_org"] stringByAppendingString:prefix];
            return subString;
        }
    }else{
        if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
            NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
            NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
            subString = [[subString stringByAppendingString:@"_org"] stringByAppendingString:prefix];
            return subString;
        }
    }
    return image_thumb;
}

+ (NSString*)resizeVideoThumb:(NSString*)image_thumb{
    if (IS_IPHONE_6 || IS_IPHONE_6P || (IS_IPAD && IS_RETINA)) {
        if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
            NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
            NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
            subString = [[subString stringByAppendingString:@"_268"] stringByAppendingString:prefix];
            return subString;
        }
    }else{
        if ([image_thumb rangeOfString:@".png"].location != NSNotFound || [image_thumb rangeOfString:@".jpg"].location != NSNotFound) {
            NSString *prefix = [image_thumb substringWithRange:NSMakeRange(image_thumb.length - 4, 4)];
            NSString *subString = [image_thumb substringWithRange:NSMakeRange(0, image_thumb.length - 4)];
            subString = [[subString stringByAppendingString:@"_268"] stringByAppendingString:prefix];
            return subString;
        }
    }
    return image_thumb;
}

#pragma mark - Parsing Subtitle

+ (void)parseString:(NSString *)string parsed:(void (^)(NSMutableDictionary*, NSError *))completion {
    // Create Scanner
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    // Subtitles parts
    NSMutableDictionary* subtitlesParts = [NSMutableDictionary dictionary];
    
    // Search for members
    while (!scanner.isAtEnd) {
        
        // Variables
        NSString *indexString;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:&indexString];
        
        NSString *startString;
        [scanner scanUpToString:@" --> " intoString:&startString];
        [scanner scanString:@"-->" intoString:NULL];
        
        NSString *endString;
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet]
                                intoString:&endString];
        
        NSString *textString;
        [scanner scanUpToString:@"\r\n\r\n" intoString:&textString];
        textString = [textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // Regular expression to replace tags
        NSError *error = nil;
        NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"[<|\\{][^>|\\^}]*[>|\\}]"
                                                                                options:NSRegularExpressionCaseInsensitive
                                                                                  error:&error];
        if (error) {
            completion(nil, error);
            return ;
        }
        
        textString = [regExp stringByReplacingMatchesInString:textString.length > 0 ? textString : @""
                                                      options:0
                                                        range:NSMakeRange(0, textString.length)
                                                 withTemplate:@""];
        
        
        // Temp object
        NSTimeInterval startInterval = [self timeFromString:startString];
        NSTimeInterval endInterval = [self timeFromString:endString];
        
        NSDictionary *tempInterval = @{
                                       kIndex : indexString,
                                       kStart : @(startInterval),
                                       kEnd : @(endInterval),
                                       kText : textString ? textString : @""
                                       };
        [subtitlesParts setObject:tempInterval
                                forKey:indexString];
        
        
//        NSString *indexString;
//        (void) [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&indexString];
//        
//        NSString *startString;
//        (void) [scanner scanUpToString:@" --> " intoString:&startString];
//        
//        // My string constant doesn't begin with spaces because scanners
//        // skip spaces and newlines by default.
//        (void) [scanner scanString:@"-->" intoString:NULL];
//        
//        NSString *endString;
//        (void) [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&endString];
//        
//        NSString *textString;
//        // (void) [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&textString];
//        // BEGIN EDIT
//        (void) [scanner scanUpToString:@"\r\n\r\n" intoString:&textString];
//        textString = [textString stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
//        // Addresses trailing space added if CRLF is on a line by itself at the end of the SRT file
//        textString = [textString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        // END EDIT
//        
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    indexString, kIndex,
//                                    startString, kStart,
//                                    endString , kEnd,
//                                    textString , kText,
//                                    nil];
//        
//        NSLog(@"%@", dictionary);
//        [subtitlesParts setObject:dictionary forKey:indexString];
        
    }
    
    if (completion != NULL) {
        completion(subtitlesParts, nil);
    }
}

+ (NSTimeInterval)timeFromString:(NSString *)timeString {
    
    NSScanner *scanner = [NSScanner scannerWithString:timeString];
    
    int h, m, s, c;
    [scanner scanInt:&h];
    [scanner scanString:@":" intoString:NULL];
    [scanner scanInt:&m];
    [scanner scanString:@":" intoString:NULL];
    [scanner scanInt:&s];
    [scanner scanString:@"," intoString:NULL];
    [scanner scanInt:&c];
    
    return (h * 3600) + (m * 60) + s + (c / 1000.0);
    
}

/* Load subtitle file .srt */
+ (NSString*) loadSubtitleFile:(NSString*)fileName {
    NSString *subtitlesPathStr = [[NSBundle mainBundle] pathForResource:fileName ofType:@"srt"];
    NSError *error = nil;
    
    // File to string
    NSString *subtitleString = [NSString stringWithContentsOfFile:subtitlesPathStr
                                                         encoding:NSUTF8StringEncoding
                                                            error:&error];
    
    if (!error) {
        return subtitleString;
    }
    return nil;
}

#pragma mark - Utils
+ (void)saveSubTitle:(SubTitle *)sub ofVideo:(Video *)video {
    if (sub) {
        // save encrypted content
        NSString *contentSub = [NSString stringWithContentsOfURL:[NSURL URLWithString:sub.subtitle_timed] encoding:NSUTF8StringEncoding error:nil];
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *subFileName = [NSString stringWithFormat:@"/%@.srt",sub.subtitle_id];
        NSString *subFileAtPath = [filePath stringByAppendingString:subFileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:subFileAtPath]) {
            [[NSFileManager defaultManager] createFileAtPath:subFileAtPath contents:nil attributes:nil];
        }
        [[contentSub dataUsingEncoding:NSUTF8StringEncoding] writeToFile:subFileAtPath atomically:NO];
        
        // encrypt and save key
//        NSString *hexString = [RC4Crypt stringToHex:kRC4IOSKey];
//        NSString *encryptedKey = [RC4Crypt doCipher:sub.subtitle_decryptionKey withKey:hexString operation:kCCEncrypt];
        NSString *keyFileName = [NSString stringWithFormat:@"/%@.txt",sub.subtitle_id];
        NSString *keyFileAtPath = [filePath stringByAppendingString:keyFileName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:keyFileAtPath]) {
            [[NSFileManager defaultManager] createFileAtPath:keyFileAtPath contents:nil attributes:nil];
        }
        [[sub.subtitle_decryptionKey dataUsingEncoding:NSUTF8StringEncoding] writeToFile:keyFileAtPath atomically:NO];
        
    }
}

+ (void)getExistContentSubTitle:(SubTitle*)sub ofVideo:(Video *)video _completed:(void(^)(NSString *str, NSError *error))completed  {
    if (sub) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        NSString *fileName = [NSString stringWithFormat:@"/%@.srt",sub.subtitle_id];
        NSString *fileAtPath = [filePath stringByAppendingString:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
            NSString *contentSub = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
            NSString *hexString = [RC4Crypt stringToHex:sub.subtitle_decryptionKey];
            NSString *string = [RC4Crypt doCipher:contentSub withKey:hexString operation:kCCDecrypt];
            if (string) {
                if (completed) {
                    completed(string,nil);
                }
            } else {
                NSError *error = [[NSError alloc]initWithDomain:@"Data Error" code:1 userInfo:nil];
                completed(nil, error);
            }
            
        } else {
            NSError *error = [[NSError alloc]initWithDomain:@"Data Error" code:1 userInfo:nil];
            completed(nil, error);
        }
    }
    
}

+ (void)getExistContentSubTitleOffline:(Video *)video _completed:(void(^)(NSString *str, NSError *error))completed {
    if (video.isHadSubtitle && video.subTitleId && !APPDELEGATE.internetConnnected) {
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        // load key
        NSString *key = nil;
        NSString *keyFileName = [NSString stringWithFormat:@"/%@.txt",video.subTitleId];
        NSString *keyFileAtPath = [filePath stringByAppendingString:keyFileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:keyFileAtPath]) {
            key = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:keyFileAtPath] encoding:NSUTF8StringEncoding];
//            NSString *hexString = [RC4Crypt stringToHex:kRC4IOSKey];
//            key = [RC4Crypt doCipher:contentKey withKey:hexString operation:kCCDecrypt];
        }
        NSString *fileName = [NSString stringWithFormat:@"/%@.srt",video.subTitleId];
        NSString *fileAtPath = [filePath stringByAppendingString:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
            NSString *contentSub = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
            NSString *hexString = [RC4Crypt stringToHex:key];
            NSString *string = [RC4Crypt doCipher:contentSub withKey:hexString operation:kCCDecrypt];
            if (string) {
                if (completed) {
                    completed(string,nil);
                }
            } else {
                NSError *error = [[NSError alloc]initWithDomain:@"Data Error" code:1 userInfo:nil];
                completed(nil, error);
            }
            
        } else {
            NSError *error = [[NSError alloc]initWithDomain:@"Data Error" code:1 userInfo:nil];
            completed(nil, error);
        }
    }
}

+ (BOOL)checkExistSub:(NSString*)subTitleId {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"/%@.srt",subTitleId];
    NSString *fileAtPath = [filePath stringByAppendingString:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        return YES;
    }
    return NO;
}

+ (void)saveSubTitleAndLoadFile:(SubTitle *)sub _completed:(void (^)(NSString *, NSError *))completed {
    [self saveSubTitle:sub ofVideo:nil];
    [self getExistContentSubTitle:sub ofVideo:nil _completed:^(NSString *str, NSError *error){
        if (error) {
            completed(nil, error);
        } else {
            completed(str, nil);
        }
    }];
}

@end
