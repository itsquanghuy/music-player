//
//  AudioViewController.m
//  Music Player
//
//  Created by Vu Huy on 02/07/2022.
//

#import "AudioViewController.h"

@interface AudioViewController () <AVAudioPlayerDelegate>

@end

@implementation AudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AudioPlayer *audioPlayer = [AudioPlayer getInstance];
    _musicPlayer = audioPlayer.player;
    if (_musicPlayer == nil || _musicPlayer.url != _song.URL) {
        audioPlayer.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_song.URL error:nil];
        _musicPlayer = audioPlayer.player;
    }
    _musicPlayer.delegate = self;
    
    NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
    [_song loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        AVMetadataItem *artwork = [[AVMetadataItem metadataItemsFromArray:self.song.commonMetadata
            withKey:AVMetadataCommonKeyArtwork
            keySpace:AVMetadataKeySpaceCommon
        ] objectAtIndex:0];
        
        UIImage *artworkImage = [UIImage imageWithData:[artwork.value copyWithZone:nil]];
        
        [self.musicPlayer prepareToPlay];
        [self initBackgroundColor:artworkImage];
        [self initArtwork:artworkImage];
        [self initTitle];
        [self initArtists];
        [self initPlaybackSlider];
        [self initPlaybackControls];
        [self.musicPlayer play];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([_musicPlayer isPlaying]) {
        [_playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        [_playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
}

- (void)initBackgroundColor:(UIImage *)artworkImage {
    self.view.backgroundColor = [ImageUtils getDominantColor:artworkImage];
}

- (void)initArtwork:(UIImage *)image {
    _artworkView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:_artworkView];
    _artworkView.translatesAutoresizingMaskIntoConstraints = NO;
    [[[_artworkView centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[[_artworkView topAnchor] constraintEqualToAnchor:self.view.topAnchor constant:50] setActive:YES];
    [[[_artworkView widthAnchor] constraintEqualToConstant:self.view.frame.size.width - 35] setActive:YES];
    [[[_artworkView heightAnchor] constraintEqualToConstant:self.view.frame.size.width - 35] setActive:YES];
    _artworkView.layer.cornerRadius = 10;
    _artworkView.clipsToBounds = YES;
}

- (void)initTitle {
    AVMetadataItem *title = [[AVMetadataItem metadataItemsFromArray:_song.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon] objectAtIndex:0];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = [title.value copyWithZone:nil];
    _titleLabel.font = [UIFont systemFontOfSize:24];
    _titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_titleLabel];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[[_titleLabel topAnchor] constraintEqualToAnchor:_artworkView.bottomAnchor constant:40] setActive:YES];
    [[[_titleLabel widthAnchor] constraintEqualToConstant:self.view.frame.size.width - 45] setActive:YES];
    [[[_titleLabel centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
}

- (void)initArtists {
    AVMetadataItem *artists = [[AVMetadataItem metadataItemsFromArray:_song.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon] objectAtIndex:0];
    
    _artistsLabel = [[UILabel alloc] init];
    _artistsLabel.text = [artists.value copyWithZone:nil];
    _artistsLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:_artistsLabel];
    _artistsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[[_artistsLabel topAnchor] constraintEqualToAnchor:_titleLabel.bottomAnchor] setActive:YES];
    [[[_artistsLabel widthAnchor] constraintEqualToConstant:self.view.frame.size.width - 45] setActive:YES];
    [[[_artistsLabel centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
}

- (void)initPlaybackSlider {
    _playbackSlider = [[UISlider alloc] init];
    [_playbackSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_playbackSlider setThumbImage:[ImageUtils resize:_playbackSlider.currentThumbImage scaledToSize:CGSizeMake(10, 10)] forState:UIControlStateNormal];
    [_playbackSlider addTarget:self action:@selector(seek:) forControlEvents:UIControlEventTouchUpInside];
    _playbackSlider.maximumValue = _musicPlayer.duration;
    _playbackSlider.value = _musicPlayer.currentTime;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updatePlaybackSlider) userInfo:nil repeats:YES];
    _playbackSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_playbackSlider];
    [[[_playbackSlider topAnchor] constraintEqualToAnchor:_artistsLabel.bottomAnchor constant:20] setActive:YES];
    [[[_playbackSlider centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[[_playbackSlider widthAnchor] constraintEqualToConstant:self.view.frame.size.width - 45] setActive:YES];
}

- (void)seek:(UISlider *)slider {
    _musicPlayer.currentTime = slider.value;
}

- (void)updatePlaybackSlider {
    _playbackSlider.value = _musicPlayer.currentTime;
}

- (void)initPlaybackControls {
    UIImage *btnImage = nil;
    _playPauseButton = [[UIButton alloc] init];
    if ([_musicPlayer isPlaying]) {
        btnImage = [UIImage imageNamed:@"pause"];
    } else {
        btnImage = [UIImage imageNamed:@"play"];
    }
    [_playPauseButton setImage:btnImage forState:UIControlStateNormal];
    [_playPauseButton setTintColor:[UIColor whiteColor]];
    [_playPauseButton addTarget:self action:@selector(togglePlayPause) forControlEvents:UIControlEventTouchUpInside];
    _playPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [[[_playPauseButton widthAnchor] constraintEqualToConstant:50] setActive:YES];
    [[[_playPauseButton heightAnchor] constraintEqualToConstant:50] setActive:YES];
    UIStackView *controlsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[_playPauseButton]];
    controlsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:controlsStackView];
    [[[controlsStackView centerXAnchor] constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[[controlsStackView topAnchor] constraintEqualToAnchor:_playbackSlider.bottomAnchor constant:40] setActive:YES];
}

- (void)togglePlayPause {
    if ([_musicPlayer isPlaying]) {
        [_musicPlayer pause];
        [_playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [_musicPlayer play];
        [_playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
}

@end
