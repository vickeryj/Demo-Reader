//
//  FeedModelController.m
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import "FeedModelController.h"

@interface FeedModelController()
//Private properties
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) Feed *feed;
@property(nonatomic, retain) NSMutableData *feedData;
@end

@implementation FeedModelController

@synthesize url, delegate, feed, feedData;

+ (FeedModelController *)modelControllerForFeedAtURL:(NSString *)url {
    FeedModelController *controller = [[[self alloc] init] autorelease];
    controller.url = url;
    return controller;
}

- (void)fetchFeed {
    NSError *error = nil;
    if (nil == self.url) {
        error = [NSError errorWithDomain:FEED_MODEL_CONTROLLER_ERROR_DOMAIN code:FEED_MODEL_CONTROLLER_ERROR_BAD_URL userInfo:nil];
    }
    else {
        NSURL *parsedURL = [NSURL URLWithString:self.url];
        if (nil == parsedURL) {
            error = [NSError errorWithDomain:FEED_MODEL_CONTROLLER_ERROR_DOMAIN code:FEED_MODEL_CONTROLLER_ERROR_BAD_URL userInfo:nil];
        }
        else {
            NSMutableURLRequest *feedRequest = [NSMutableURLRequest requestWithURL:parsedURL];
            NSURLConnection *feedConnection = [NSURLConnection connectionWithRequest:feedRequest delegate:self];
            [feedConnection start];
        }
    }
    
    if (nil != error) {
        [self.delegate feedModelController:self didFailToFetchFeedWithError:error];
    }
}

#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.feed = [[[Feed alloc] init] autorelease];
    self.feed.parserDelegate = self;
    self.feedData = [NSMutableData data];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.feedData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.feed parseData:self.feedData];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.delegate feedModelController:self didFailToFetchFeedWithError:error];
}

#pragma mark FeedParserDelegate methods
- (void)feedDidFinishParsing:(Feed *)feed {
    [self.delegate feedModelController:self didFetchFeed:self.feed];
}
- (void)feed:(Feed *)feed failedToParseWithError:(NSError *)error {
    [self.delegate feedModelController:self didFailToFetchFeedWithError:error];
}


#pragma mark cleanup
- (void)dealloc {
    [url release];
    [feed release];
    [feedData release];
    [super dealloc];
}

@end
