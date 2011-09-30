//
//  FeedItem.m
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery Inc. All rights reserved.
//

#import "FeedItem.h"

@interface FeedItem()

@property(nonatomic, retain) NSMutableString *internalTitle;
@property(nonatomic, retain) NSMutableString *internalPubDate;

@property(nonatomic, assign) NSMutableString *currentTextProperty;


@end

@implementation FeedItem

@synthesize internalTitle, currentTextProperty, internalPubDate;


- (void)beginElement:(NSString *)element {
    if ([element isEqualToString:@"title"]) {
        self.internalTitle = [NSMutableString string];
        self.currentTextProperty = self.internalTitle;
    }
    else if ([element isEqualToString:@"pubDate"]) {
        self.internalPubDate = [NSMutableString string];
        self.currentTextProperty = self.internalPubDate;
    }
    else {
        self.currentTextProperty = nil;
    }
}

- (void)endElement:(NSString *)element {
    self.currentTextProperty = nil;
}

- (void)appendTextToCurrentTextProperty:(NSString *)textToAppend {
    [self.currentTextProperty appendString:textToAppend];
}

- (NSString *)title {
    return self.internalTitle;
}

- (NSString *)pubDate {
    return self.internalPubDate;
}


#pragma mark cleanup
- (void)dealloc {
    [internalTitle release];
    [internalPubDate release];
    [super dealloc];
}

@end
