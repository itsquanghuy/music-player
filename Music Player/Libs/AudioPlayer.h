//
//  MusicPlayer.h
//  Music Player
//
//  Created by Vu Huy on 02/07/2022.
//

#ifndef MusicPlayer_h
#define MusicPlayer_h

#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *player;

+ (id)getInstance;

@end

#endif /* MusicPlayer_h */
