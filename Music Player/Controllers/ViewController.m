//
//  ViewController.m
//  Music Player
//
//  Created by Vu Huy on 30/06/2022.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AudioPlayer *audioPlayer = [AudioPlayer getInstance];
    _musicPlayer = audioPlayer.player;
    _musicPlayer.delegate = self;
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeDefault error:nil];
    [[AVAudioSession sharedInstance] setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.fileManager = [NSFileManager defaultManager];
    
    [self loadSongs];
    
    [self.view addSubview:self.tableView];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)loadSongs {
    self.songs = [[NSMutableArray alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable fileName, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [[fileName pathExtension] isEqual:@"mp3"];
    }];
    NSArray *mp3Filenames = [[self.fileManager contentsOfDirectoryAtPath:bundlePath error:nil] filteredArrayUsingPredicate:predicate];
    
    for (NSString *filename in mp3Filenames) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:@"mp3"];
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
        
        [self.songs addObject:asset];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleSubtitle
            reuseIdentifier:@"cell"
        ];
    }
    
    AVURLAsset *song = self.songs[indexPath.row];
    AVMetadataItem *title = [[AVMetadataItem metadataItemsFromArray:song.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon] objectAtIndex:0];
    AVMetadataItem *artists = [[AVMetadataItem metadataItemsFromArray:song.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon] objectAtIndex:0];
    
    cell.textLabel.text = [title.value copyWithZone:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.detailTextLabel.text = [artists.value copyWithZone:nil];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
    [song loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        AVMetadataItem *artwork = [[AVMetadataItem metadataItemsFromArray:song.commonMetadata
            withKey:AVMetadataCommonKeyArtwork
            keySpace:AVMetadataKeySpaceCommon
        ] objectAtIndex:0];
        
        cell.imageView.image = [ImageUtils resize:[UIImage imageWithData:[artwork.value copyWithZone:nil]] scaledToSize:CGSizeMake(47.5, 47.5)];
        cell.imageView.layer.cornerRadius = 5;
        cell.imageView.clipsToBounds = YES;
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVURLAsset *song = self.songs[indexPath.row];
       
    AudioViewController *audioVC = [[AudioViewController alloc] init];
    audioVC.song = song;
    [self presentViewController:audioVC animated:YES completion:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            [_musicPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [_musicPlayer pause];
            break;
        default:
            break;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

@end
