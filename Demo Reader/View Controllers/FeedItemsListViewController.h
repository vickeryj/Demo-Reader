//
//  FeedItemsListViewController.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@class Feed;

@interface FeedItemsListViewController : UITableViewController<FeedItemDelegate> {
    
}

@property(nonatomic, retain) Feed *feed;

@end
