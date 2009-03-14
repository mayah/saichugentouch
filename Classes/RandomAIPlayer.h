//
//  RandomAIPlayer.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 2/14/09.
//  Copyright 2009 YUHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@class Card;

@interface RandomAIPlayer : Player {
}

/** choose Card. The chosen card should be removed from the array. */
- (Card*)selectCard;
- (void)willStartTurn:(int)turn round:(int)round;
@end