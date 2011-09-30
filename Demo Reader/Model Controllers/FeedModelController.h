//
//  FeedModelController.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Feed.h"

#define FEED_MODEL_CONTROLLER_ERROR_DOMAIN @"com.vickeryj.DemoReader.FeedModelController"
#define FEED_MODEL_CONTROLLER_ERROR_BAD_URL 1

@class FeedModelController;

@protocol FeedModelControllerProtocol <NSObject>

- (void)feedModelController:(FeedModelController *)controller didFetchFeed:(Feed *)feed;
- (void)feedModelController:(FeedModelController *)controller 
didFailToFetchFeedWithError:(NSError *)error;

@end

@interface FeedModelController : NSObject <FeedParserDelegate> {
    
}

@property(nonatomic, assign) id<FeedModelControllerProtocol> delegate;


+ (FeedModelController *)modelControllerForFeedAtURL:(NSString *)url;

- (void)fetchFeed;

@end
