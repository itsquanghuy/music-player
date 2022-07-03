//
//  MusicPlayer.m
//  Music Player
//
//  Created by Vu Huy on 02/07/2022.
//

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"

@implementation AudioPlayer

static AudioPlayer *instance;

+ (id)getInstance {
    if (!instance) {
        instance = [[AudioPlayer alloc] init];
    }
    return instance;
}

- (id)init {
    if (!instance) {
        instance = [super init];
    }
    return instance;
}

@end
