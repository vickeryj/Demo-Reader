//
//  FeedItem.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedItem : NSObject {
    
}

//parsing methods
- (void)beginElement:(NSString *)element;
- (void)endElement:(NSString *)element;
- (void)appendTextToCurrentTextProperty:(NSString *)textToAppend;

//item properties
- (NSString *)title;
- (NSString *)pubDate;

@end
