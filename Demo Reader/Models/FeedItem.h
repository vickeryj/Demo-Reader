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

- (void)beginElement:(NSString *)element;
- (void)appendTextToCurrentTextProperty:(NSString *)textToAppend;


- (NSString *)title;

@end
