//
//  HumanPlayer.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 2/14/09.
//  Copyright 2009 YUHA. All rights reserved.
//

#import "HumanPlayer.h"
#import "GameViewController.h"

@implementation HumanPlayer

- (BOOL)isHumanPlayer {
	return YES;
}

- (void)willStartTurn:(int)turn round:(int)round {
	NSLog(@"HumanPlayer#willStartTurn");
	[gameViewController setCardSelectingMode:YES];
}


@end