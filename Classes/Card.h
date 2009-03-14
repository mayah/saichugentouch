//
//  Card.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/6/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardView;

/**
 * Card Suit
 */
enum CardSuit {
	CLUB, DIAMOND, HEART, SPADE	
};

/**
 * Card represents a card.
 */
@interface Card : NSObject {
	enum CardSuit suit;
	int rank;
	UIView* imageView;
	
	UIImage* cardImage;
	UIImage* backImage;             // TODO: backImage can be shared among the cards.
	UIImageView* cardImageView;
	UIImageView* backImageView;
	
	BOOL top;						// true if showing the top face.
	BOOL highlighting;				// true if highlighting.
}

@property (nonatomic, readonly, assign) enum CardSuit suit;
@property (nonatomic, readonly, assign) int rank;
@property (nonatomic, readonly, assign) UIView* imageView;
@property (nonatomic, readonly, assign) BOOL top;
@property (nonatomic, readonly, assign) BOOL highlighting;

+ (int)height;
+ (int)width;

// ----------------------------------------------------------------------
// initializers

- (Card*)initWithSuit:(enum CardSuit)suit withRank:(int)rank;

// ----------------------------------------------------------------------
// card utilities

/**
 * return the card id of the card. 
 * a smaller id will be allocated for a weaker card.
 */
- (int)cardID;

- (NSComparisonResult) compare:(Card*)rhs;

// ----------------------------------------------------------------------
// flip

- (void)flip;
- (void)flipToTop;
- (void)flipToBottom;

// ----------------------------------------------------------------------
// highlight
- (void)highlight:(BOOL)lighting;

@end
