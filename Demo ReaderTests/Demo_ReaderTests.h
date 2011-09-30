//
//  Demo_ReaderTests.h
//  Demo ReaderTests
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class Feed;

@interface Demo_ReaderTests : SenTestCase {
    
}

@property(nonatomic, retain) NSError *feedFetchError;
@property(nonatomic, retain) Feed *fetchedFeed;
@property(nonatomic, retain) Feed *parsedFeed;

@property(nonatomic, assign) BOOL feedFetched;
@property(nonatomic, assign) BOOL feedParsed;

@end
