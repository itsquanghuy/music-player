//
//  AudioViewController.h
//  Music Player
//
//  Created by Vu Huy on 02/07/2022.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPlayer.h"
#import "Image.h"

NS_ASSUME_NONNULL_BEGIN

@interface AudioViewController : UIViewController

@property (nonatomic, strong) AVURLAsset *song;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) UIImageView *artworkView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *artistsLabel;
@property (nonatomic, strong) UIButton *playPauseButton;
@property (nonatomic, strong) UISlider *playbackSlider;
@property (nonatomic, strong) NSTimer *timer;

@end

NS_ASSUME_NONNULL_END
