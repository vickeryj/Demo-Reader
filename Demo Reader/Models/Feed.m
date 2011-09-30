//
//  Feed.m
//  Demo Reader
//
//  Created by Joshua Vickery on 9/30/11.
//  Copyright 2011 Joshua Vickery Inc. All rights reserved.
//

#import "Feed.h"
#import "FeedItem.h"

@interface Feed()

@property(nonatomic, retain) NSMutableArray *internalItems;
@property(nonatomic, retain) NSXMLParser *parser;
@property(nonatomic, retain) FeedItem *currentItem;
@end

@implementation Feed

@synthesize internalItems, parserDelegate, parser, currentItem;

- (void) parseData:(NSData *)data {
    
    //setup our internal state for parsing
    self.internalItems = [NSMutableArray array];

    //setup the XML parser and let it rip
    self.parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    self.parser.delegate = self;
    //turn off namespace support so we get "media:" tags without the "media:" stripped
    [self.parser setShouldProcessNamespaces:NO];
    [self.parser parse];

}

- (NSArray *)items {
    return self.internalItems;
}

#pragma mark NSXMLParserDelegate methods

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self.parserDelegate feedDidFinishParsing:self];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"]) {
        if (nil == self.currentItem) {
            self.currentItem = [[[FeedItem alloc] init] autorelease];
        }
        else {
            NSError *error = [NSError errorWithDomain:FEED_ERROR_DOMAIN 
                                                 code:FEED_ERROR_PARSING_ERROR 
                                             userInfo:[NSDictionary dictionaryWithObject:@"Items may not be nested"
                                                                                  forKey:@"Description"]];
            [self.parserDelegate feed:self failedToParseWithError:error];
        }
    }
    else {
        [self.currentItem beginElement:elementName attributes:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [self.internalItems addObject:currentItem];
        self.currentItem = nil;
    }
    else {
        [self.currentItem endElement:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.currentItem appendTextToCurrentTextProperty:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self.parser abortParsing];
    self.parser.delegate = nil;
    [self.parserDelegate feed:self failedToParseWithError:parseError];
}



#pragma mark cleanup
- (void)dealloc {
    [internalItems release];
    [parser release];
    [currentItem release];
    [super dealloc];
}

@end
