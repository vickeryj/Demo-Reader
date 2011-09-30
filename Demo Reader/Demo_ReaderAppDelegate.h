//
//  Demo_ReaderAppDelegate.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedURLViewController;

@interface Demo_ReaderAppDelegate : NSObject <UIApplicationDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) FeedURLViewController *urlViewController;

@end
