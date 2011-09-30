//
//  Demo_ReaderTests.m
//  Demo ReaderTests
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import "Demo_ReaderTests.h"
#import "FeedModelController.h"
#import "SyncAsyncRunner.h"
#import "Feed.h"
#import "FeedItem.h"

@implementation Demo_ReaderTests

@synthesize feedFetched, feedFetchError, fetchedFeed, feedParsed, parsedFeed;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)fetchFeedAtURL:(NSString *)url {
    
    FeedModelController *feedFetcher = [FeedModelController modelControllerForFeedAtURL:url];
    
    SyncAsyncRunner *runner = [[[SyncAsyncRunner alloc] init] autorelease];
    
    runner.callbackDelegate = self;
    
    feedFetcher.delegate = (id<FeedModelControllerProtocol>)runner;
    
    self.feedFetched = NO;
    self.fetchedFeed = nil;
    self.feedFetchError = nil;
    
    BOOL callbackReceived = [runner waitForResponseFromTarget:feedFetcher 
                                                    toMessage:@selector(fetchFeed)];
    
    STAssertTrue(callbackReceived, 
                 @"There should have been a response from our request to fetch the feed at %@", url);
    
    
}

- (void)testFetchFeeds
{
    
    //Fetch a good url
    NSString *url = @"http://www.questionablecontent.net/QCRSS.xml";
 
    [self fetchFeedAtURL:url];
    
    STAssertTrue([[self.fetchedFeed items] count] > 0, @"The feed at %@ should have items in it.", url);
        
    STAssertTrue(self.feedFetched, 
                 @"We should have been able to fetch the feed at %@, but there was an error: %@", 
                 url, self.feedFetchError);
    
    
    //Fetch a bad url
    url = @"http://abcdefg.hijklmnop";
    [self fetchFeedAtURL:url];
    
    STAssertFalse(self.feedFetched, @"we should not be able to fetch a feed at %@",url);
                  
    //nil test
    url = nil;
    [self fetchFeedAtURL:url];
    STAssertFalse(self.feedFetched, @"we should not be able to fetch a nil url");

}

- (void)parseFeedData:(NSData *)feedData {
    
    self.feedParsed = NO;
    self.parsedFeed = nil;
    
    Feed *feed = [[[Feed alloc] init] autorelease];
    
    SyncAsyncRunner *runner = [[[SyncAsyncRunner alloc] init] autorelease];
    
    runner.callbackDelegate = self;
    
    feed.parserDelegate = (id<FeedParserDelegate>)runner;
    
    
    BOOL parserCallbackReceived = [runner waitForResponseFromTarget:feed 
                                                          toMessage:@selector(parseData:) 
                                                        withObjects:feedData];
    
    STAssertTrue(parserCallbackReceived, @"We should get a callback after calling parseData");
    
}

- (void)testFeedParsing
{
    
    //parse known good rss
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"QCRSS"
                                                                          ofType:@"xml"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    [self parseFeedData:[NSData dataWithContentsOfURL:fileURL]];
    
    STAssertTrue(self.feedParsed, @"We should be able to parse QCRSS.xml");
    
    STAssertTrue([[self.parsedFeed items] count] > 0, @"QCRSS should have items in it.");
    
    for (FeedItem *item in self.parsedFeed.items) {
        STAssertNotNil([item title], @"every item in QCRSS should have a title");
        STAssertNotNil([item pubDate], @"every item in QCRSS should have a pubDate");
    }


    //parse bad rss
    filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"badRSS"
                                                                          ofType:@"xml"];
    fileURL = [NSURL fileURLWithPath:filePath];
    
    [self parseFeedData:[NSData dataWithContentsOfURL:fileURL]];
    
    STAssertFalse(self.feedParsed, @"We should not be able to parse badRSS");

    
    //nil check
    [self parseFeedData:nil];
    
    STAssertFalse(self.feedParsed, @"We should not be able to parse nil data");
                                   
}

- (void)testImageLoading
{
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"JoshDemoRSS"
                                                                          ofType:@"xml"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    [self parseFeedData:[NSData dataWithContentsOfURL:fileURL]];
    
    STAssertTrue(self.feedParsed, @"We should be able to parse JoshDemo.xml");
    
    STAssertTrue([[self.parsedFeed items] count] == 4, @"JoshDemoRSS should have 4 items in it.");
    
    
    STAssertNil([[self.parsedFeed.items objectAtIndex:3] itemImage], 
                @"items with no image in the RSS should not have an image");
    
    for (int i = 0; i < 3; i++) {
        STAssertNotNil([[self.parsedFeed.items objectAtIndex:i] itemImage], 
                       @"items with an image in the RSS should have an image, even if it's just a placeholder");

        SyncAsyncRunner *runner = [[[SyncAsyncRunner alloc] init] autorelease];    
        
        FeedItem *item = [self.parsedFeed.items objectAtIndex:i];
        item.delegate = (id<FeedItemDelegate>)runner;
        
        BOOL callbackReceived = [runner waitForResponseFromTarget:item 
                                                        toMessage:@selector(downloadImage)];
        
        STAssertTrue(callbackReceived, @"We should get a callback when an image is downloaded");

    }

    
}

#pragma mark FeedModelControllerProtocol methods
- (void)feedModelController:(FeedModelController *)controller didFetchFeed:(Feed *)feed {
    self.feedFetched = YES;
    self.fetchedFeed = feed;
}
- (void)feedModelController:(FeedModelController *)controller 
didFailToFetchFeedWithError:(NSError *)error
{
    self.feedFetched = NO;
    self.feedFetchError = error;
}

#pragma mark FeedParserDelegate methods
- (void)feedDidFinishParsing:(Feed *)feed {
    self.feedParsed = YES;
    self.parsedFeed = feed;
}
- (void)feed:(Feed *)feed failedToParseWithError:(NSError *)error {
    self.feedParsed = NO;
    self.parsedFeed = feed;
}


#pragma mark cleanup
- (void)dealloc {
    [feedFetchError release];
    [fetchedFeed release];
    [parsedFeed release];
    [super dealloc];
}

@end
