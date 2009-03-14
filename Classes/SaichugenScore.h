//
//  SaichugenScore.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/22/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * SaichugenScore represents the score history of the player.
 */
@interface SaichugenScore : NSObject<UITableViewDataSource> {
	int numGames;
	int numWin1;
	int numWin2;
	int numDefeat1;
	int numDefeat2;
	int numDraw;
}

@property (nonatomic, assign) int numGames;
@property (nonatomic, assign) int numWin1;
@property (nonatomic, assign) int numWin2;
@property (nonatomic, assign) int numDefeat1;
@property (nonatomic, assign) int numDefeat2;
@property (nonatomic, assign) int numDraw;

/** load SaichugenScore from the file. The returned object will be released if you don't retain it. */
+ (SaichugenScore*)loadFromFile;

/** save SaichugenScore to the file. YES will be returned if succeeded. */
- (BOOL)saveToFile;

/** reset score */
- (void)resetScore;

@end
