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
@property(nonatomic, retain) NSString *imageURL;
@property(nonatomic, retain) UIImage *internalImage;
@property(nonatomic, retain) NSMutableData *downloadingImageData;
@property(nonatomic, retain) NSURLConnection *downloadConnection;

@property(nonatomic, assign) NSMutableString *currentTextProperty;
@property(nonatomic, assign) BOOL downloadInProgress;


@end

@implementation FeedItem

@synthesize internalTitle, currentTextProperty, internalPubDate, imageURL;
@synthesize internalImage, delegate, downloadInProgress, downloadingImageData;
@synthesize downloadConnection;

#pragma mark RSS parsing support
- (void)beginElement:(NSString *)element attributes:(NSDictionary *)attributes {
    if ([element isEqualToString:@"title"]) {
        self.internalTitle = [NSMutableString string];
        self.currentTextProperty = self.internalTitle;
    }
    else if ([element isEqualToString:@"pubDate"]) {
        self.internalPubDate = [NSMutableString string];
        self.currentTextProperty = self.internalPubDate;
    }
    else if ([element isEqualToString:@"media:thumbnail"]) {
        self.imageURL = [attributes valueForKey:@"url"];
    }
    else if (nil == self.imageURL) {
        //Prefer media:thumbnail images, but also support media:content and enclosure images
        if([element isEqualToString:@"media:content"] || [element isEqualToString:@"enclosure"]) {
            if (NSNotFound != [[attributes valueForKey:@"type"] rangeOfString:@"image/"].location) {
                self.imageURL = [attributes valueForKey:@"url"];
            }
        }
    }
    else {
        self.currentTextProperty = nil;
    }
}

- (void)endElement:(NSString *)element {
    //trim whitespace
    NSString *trimmedString = [self.currentTextProperty stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self.currentTextProperty setString:trimmedString];
    
    //remove newlines
    [self.currentTextProperty replaceOccurrencesOfString:@"\n" withString:@" "
                                                 options:0 
                                                   range:NSMakeRange(0, [self.currentTextProperty length])];
    
    self.currentTextProperty = nil;
}

- (void)appendTextToCurrentTextProperty:(NSString *)textToAppend {
    [self.currentTextProperty appendString:textToAppend];
}

#pragma mark property access
- (NSString *)title {
    return self.internalTitle;
}

- (NSString *)pubDate {
    return self.internalPubDate;
}

- (UIImage *)itemImage {
    UIImage *image = nil;
    if (nil != self.imageURL && nil == self.internalImage) {
        //placeholder for items with images that aren't loaded yet
        image = [UIImage imageNamed:@"Placeholder.png"];
    }
    else {
        image = self.internalImage;
    }
    return image;
}

#pragma mark image downloading
- (void)downloadImage {
    if (nil != self.imageURL && nil == self.internalImage && !self.downloadInProgress) 
    {
        //Only download an image if there is one to download, it is not
        //already downloaded and we are not currently downloading it.
        self.downloadInProgress = YES;
        self.downloadingImageData = [NSMutableData data];
        self.downloadConnection = [NSURLConnection connectionWithRequest:
                                   [NSURLRequest requestWithURL:
                                    [NSURL URLWithString:self.imageURL]] delegate:self];
    }
}

#pragma mark NSURLConnectionDelegate methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadingImageData appendData:data];
}

- (void) cleanupConnection {
    self.downloadInProgress = NO;
    self.downloadingImageData = nil;
    self.downloadConnection = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //Image download failed, use a placeholder instead
    self.internalImage = [UIImage imageNamed:@"Placeholder.png"];
    
    [self cleanupConnection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //explicit retain here so that we don't hang on to this image
    //any longer than necessary
    UIImage *image = [[UIImage alloc] initWithData:self.downloadingImageData];
    
    if (image.size.width != 60 && image.size.height != 60)
	{
        CGSize itemSize = CGSizeMake(60, 60);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.internalImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.internalImage = image;
    }
    
    //explicit release
    [image release];
        
    [self cleanupConnection];
    
    [self.delegate feedItemDidFinishDownloadingImage:self];
}


#pragma mark cleanup
- (void)dealloc {
    [internalTitle release];
    [internalPubDate release];
    [imageURL release];
    [internalImage release];
    [downloadingImageData release];
    [downloadConnection cancel];
    [downloadConnection release];
    [super dealloc];
}

@end
