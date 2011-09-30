//
//  FeedURLViewController.h
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedModelController.h"


@interface FeedURLViewController : UIViewController <UITextFieldDelegate, 
    FeedModelControllerProtocol> 
{
    
    UITextField *rssURLField;
    UIActivityIndicatorView *activityIndicator;
    UIButton *viewFeedButton;
}

@property (nonatomic, retain) IBOutlet UITextField *rssURLField;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIButton *viewFeedButton;

- (IBAction)viewFeedButtonTapped:(id)sender;


@end
