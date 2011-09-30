//
//  Feed.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FEED_ERROR_DOMAIN @"com.vickeryj.DemoReader.Feed"
#define FEED_ERROR_PARSING_ERROR 1


@class Feed;

@protocol FeedParserDelegate <NSObject>

- (void)feedDidFinishParsing:(Feed *)feed;
- (void)feed:(Feed *)feed failedToParseWithError:(NSError *)error;

@end

@interface Feed : NSObject <NSXMLParserDelegate> {
    
}

@property(nonatomic, assign) id<FeedParserDelegate>parserDelegate;


- (void)parseData:(NSData *)data;
- (NSArray *)items;

@end
