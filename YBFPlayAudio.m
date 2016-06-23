//
//  YBFPlayAudio.m
//  gifAlect
//
//  Created by 建星 on 16/4/7.
//  Copyright © 2016年 建星. All rights reserved.
//

#import "YBFPlayAudio.h"
#import <AVFoundation/AVFoundation.h>
@interface YBFPlayAudio ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation YBFPlayAudio

+ (id)sharedAudioPlayer
{
    static YBFPlayAudio *audioPlayer ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[YBFPlayAudio alloc] init];
    });
    
    return audioPlayer;
}

- (instancetype)init{
    self = [super init];
    if (self) {

        
    }
    return self;
}

- (void)play
{
    [self.audioPlayer stop];
    [self.audioPlayer play]; 
}

- (void)stop
{
    if (self.audioPlayer) {
        [self.audioPlayer stop];
    }
}



- (void)setplayData:(NSData *)data
{
    NSError *error;
    
    if (self.audioPlayer != nil) {
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [self.audioPlayer prepareToPlay];
    
}

- (void)setplayURL:(NSURL *)url{
    NSError *error;
    if (self.audioPlayer != nil) {
        self.audioPlayer = nil;
    }
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    [self.audioPlayer prepareToPlay];
}

- (void)playWithFileName:(NSString *)name{
    
    if (name && name.length > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        [self setplayData:data];
        [self play];
    }
    
}

- (void)playSoundWithName:(NSString *)name
{
    NSString *audioFile=[[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    NSURL *fileUrl=[NSURL fileURLWithPath:audioFile];
    //1.获得系统声音ID
    SystemSoundID soundID=0;
    /**
     * inFileUrl:音频文件url
     * outSystemSoundID:声音id（此函数会将音效文件加入到系统音频服务中并返回一个长整形ID）
     */
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //    AudioServicesPlayAlertSound(soundID);//播放音效并震动
}
@end
