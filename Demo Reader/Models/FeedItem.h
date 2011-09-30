//
//  FeedItem.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedItem;

@protocol FeedItemDelegate <NSObject>

-  (void)feedItemDidFinishDownloadingImage:(FeedItem *)item;

@end

@interface FeedItem : NSObject {
    
}

@property(nonatomic, assign) id<FeedItemDelegate> delegate;

//parsing methods
- (void)beginElement:(NSString *)element attributes:(NSDictionary *)attributes;
- (void)endElement:(NSString *)element;
- (void)appendTextToCurrentTextProperty:(NSString *)textToAppend;

//item properties
- (NSString *)title;
- (NSString *)pubDate;
- (UIImage *)itemImage;

//remote image fetch
- (void)downloadImage;

@end
