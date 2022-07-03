//
//  ViewController.h
//  Music Player
//
//  Created by Vu Huy on 30/06/2022.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import "Image.h"
#import "AudioPlayer.h"
#import "AudioViewController.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSMutableArray<AVURLAsset *> *songs;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@end
