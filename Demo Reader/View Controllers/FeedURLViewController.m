//
//  FeedURLViewController.m
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery. All rights reserved.
//

#import "FeedURLViewController.h"
#import "FeedItemsListViewController.h"

@interface FeedURLViewController()
@property(nonatomic, retain) FeedModelController *feedFetcher;
@end

@implementation FeedURLViewController

@synthesize activityIndicator;
@synthesize viewFeedButton;
@synthesize rssURLField, feedFetcher;

- (void) doFetchFeed {
    
    [self.rssURLField resignFirstResponder];
    self.viewFeedButton.hidden = YES;
    [self.activityIndicator startAnimating];
    self.rssURLField.enabled = NO;
    
    self.feedFetcher = [FeedModelController modelControllerForFeedAtURL:self.rssURLField.text];
    self.feedFetcher.delegate = self;
    [self.feedFetcher fetchFeed];
}

- (IBAction)viewFeedButtonTapped:(id)sender {
    [self doFetchFeed];
}

#pragma FeedModelControllerProtocol methods

- (void) feedFetchDone {
    self.viewFeedButton.hidden = NO;
    [self.activityIndicator stopAnimating];
    self.rssURLField.enabled = YES;
}

- (void)feedModelController:(FeedModelController *)controller didFetchFeed:(Feed *)feed {
    [self feedFetchDone];
    FeedItemsListViewController *listController = [[[FeedItemsListViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    listController.feed = feed;

    UINavigationController *listNav = [[[UINavigationController alloc] initWithRootViewController:listController] autorelease];
                                      
    listNav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:listNav animated:YES];
}
- (void)feedModelController:(FeedModelController *)controller 
didFailToFetchFeedWithError:(NSError *)error 
{
    [self feedFetchDone];
    UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error" 
                                                          message:nil 
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil] autorelease];
    [errorAlert show];
}


#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doFetchFeed];
    return YES;
}


#pragma mark UIViewController methods
- (void)viewDidUnload
{
    [self setRssURLField:nil];
    [self setActivityIndicator:nil];
    [self setViewFeedButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark cleanup
- (void)dealloc
{
    [rssURLField release];
    [feedFetcher release];
    [activityIndicator release];
    [viewFeedButton release];
    [super dealloc];
}

@end
