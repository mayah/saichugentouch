//
//  Card.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/6/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize suit;
@synthesize rank;
@synthesize imageView;
@synthesize top;
@synthesize highlighting;

// ----------------------------------------------------------------------
// alloc/dealloc

- (void)dealloc {
	[imageView release];
	[cardImageView release];
	[backImageView release];
	[cardImage release];
	[backImage release];	
	[super dealloc];
}

// ----------------------------------------------------------------------
// initializers

- (Card*)initWithSuit:(enum CardSuit)cardSuit withRank:(int)cardRank {
	if ((self = [self init]) == nil) { return nil; }
	suit = cardSuit;
	rank = cardRank;
	
	char c;
	switch (cardSuit) {
		case CLUB:    c = 'c'; break;			
		case DIAMOND: c = 'd'; break;
		case HEART:   c = 'h'; break;
		case SPADE:   c = 's'; break;
		default:
			assert(false);
	}

	NSString* cardFilename = [NSString stringWithFormat:@"%c%02d.png", c, cardRank];
	cardImage = [[UIImage imageNamed:cardFilename] retain];
	assert(cardImage);
	
	backImage = [[UIImage imageNamed:@"back.png"] retain];
	assert(backImage);
	
	CGRect frame;
	frame.origin.x = 0;
	frame.origin.y = 0;
	frame.size.width = [Card width];
	frame.size.height = [Card height];
	
	imageView = [[UIView alloc] init];
	imageView.backgroundColor = [UIColor clearColor];
	imageView.frame = frame;
	cardImageView = [[UIImageView alloc] initWithImage:cardImage];
	cardImageView.contentMode = UIViewContentModeScaleToFill;
	cardImageView.frame = frame;
	backImageView = [[UIImageView alloc] initWithImage:backImage];
	backImageView.contentMode = UIViewContentModeScaleToFill;
	backImageView.frame = frame;
	
	[imageView addSubview:cardImageView];
	top = YES;
	[self highlight:NO];

	return self;
}

// ----------------------------------------------------------------------
// 

+ (int)height {
	return 48;
}

+ (int)width {
	return 32;
}

// -----------------------------------------------------------------
// 

- (int)cardID {
	return rank * 4 + suit;
}

- (NSComparisonResult) compare:(Card*)rhs {
	int lhsID = [self cardID];
	int rhsID = [rhs cardID];
	if (lhsID < rhsID) {
		return NSOrderedAscending;
	} else if (lhsID == rhsID) {
		return NSOrderedSame;
	} else {
		return NSOrderedDescending;
	}
}

// ----------------------------------------------------------------------
// 
- (void)flip {
	if (top) {
		[self flipToBottom];
	} else {
		[self flipToTop];
	}
}

- (void)flipToTop {
	[backImageView removeFromSuperview];
	[imageView addSubview:cardImageView];
	top = YES;
}

- (void)flipToBottom {
	[cardImageView removeFromSuperview];
	[imageView addSubview:backImageView];
	top = NO;
}

// ----------------------------------------------------------------------
// 
- (void)highlight:(BOOL)lighting {
	highlighting = lighting;
	if (highlighting) {
		imageView.backgroundColor = [UIColor blueColor];
		cardImageView.alpha = 0.7;
	} else {
		imageView.backgroundColor = [UIColor clearColor];
		cardImageView.alpha = 1.0;
	}
	
	[imageView setNeedsDisplay];
	[cardImageView setNeedsDisplay];
}

@end
