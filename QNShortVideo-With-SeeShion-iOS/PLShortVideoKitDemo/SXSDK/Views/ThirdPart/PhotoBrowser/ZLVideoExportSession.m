//
//  ZLVideoExportSession.m
//  ShiPinDemo
//
//  Created by Zhiqiang Li on 08/11/2017.
//  Copyright © 2017 杨思宇. All rights reserved.
//

#import "ZLVideoExportSession.h"

@interface ZLVideoExportSession()
@property (strong, nonatomic) NSString * mInput;
@property (strong, nonatomic) NSString * mOutput;
@property (nonatomic, strong) AVAsset * mAsset;
@property (nonatomic, strong) NSArray * mVideoTracks;
@property (nonatomic, strong) NSArray * mAudioTracks;

@property (nonatomic, strong) AVMutableComposition * mComposition;
@property (nonatomic, strong) AVMutableVideoCompositionLayerInstruction *mVideoLayerInstruction;
@property (nonatomic, strong) AVMutableVideoCompositionInstruction *mVideoCompositionInstruction;
@property (nonatomic, strong) AVMutableVideoComposition * mOutputVideoComposition;
@property (nonatomic, strong) AVAssetExportSession * mAssetExport;

@property float mOutputVolume;
@property int mFrameRate;
@property CGSize mRenderSize;
@property CMTimeRange mTimeRange;
@property CGAffineTransform mRenderTransform;

@property (strong, nonatomic) AVMutableAudioMix * mAudioMix;
@property (strong, nonatomic) NSMutableArray * mAudioParameters;
@property (strong, nonatomic) NSMutableArray <NSNumber *> * mVolumes;
@end

@implementation ZLVideoExportSession

-(instancetype _Nullable) init:(NSString * _Nonnull) input_video
                        output:(NSString * _Nonnull) output_url
{
    self = [super init];
    if (self)
    {
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:output_url error:nil];
        
        _mOutputVolume = 1.0;
        _mOutput = [output_url copy];
        _mInput    = [input_video copy];
        _mAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:input_video]
                                      options:@{AVURLAssetPreferPreciseDurationAndTimingKey:@YES}];
        _mVideoTracks = [_mAsset tracksWithMediaType:AVMediaTypeVideo];
        _mAudioTracks = [_mAsset tracksWithMediaType:AVMediaTypeAudio];
        
        for (int i = 0; i < _mAudioTracks.count; i++)
        {
            [_mVolumes addObject:@1.0F];
        }
        
        if (_mVideoTracks.count == 0)
        {
            self = nil;
            return self;
        }
        
        _mRenderSize = [((AVAssetTrack *) [_mVideoTracks firstObject]) naturalSize];
        _mFrameRate = (int)ceilf([((AVAssetTrack *) [_mVideoTracks firstObject]) nominalFrameRate]);
        _mRenderTransform = [((AVAssetTrack *) [_mVideoTracks firstObject]) preferredTransform];
        _mTimeRange = [((AVAssetTrack *) [_mVideoTracks firstObject]) timeRange];
    }
    return self;
}

-(instancetype _Nullable) initWithAsset:(AVAsset * _Nonnull) asset
                                 output:(NSString * _Nonnull) output
{
    self = [super init];
    if (self)
    {
        
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:output error:nil];
        
        _mOutputVolume = 1.0;
        _mOutput = [output copy];
        _mAsset = asset;
        _mVideoTracks = [_mAsset tracksWithMediaType:AVMediaTypeVideo];
        _mAudioTracks = [_mAsset tracksWithMediaType:AVMediaTypeAudio];
        
        for (int i = 0; i < _mAudioTracks.count; i++)
        {
            [_mVolumes addObject:@1.0F];
        }
        
        if (_mVideoTracks.count == 0)
        {
            self = nil;
            return self;
        }
        
        _mRenderSize = [((AVAssetTrack *) [_mVideoTracks firstObject]) naturalSize];
        _mFrameRate = (int)ceilf([((AVAssetTrack *) [_mVideoTracks firstObject]) nominalFrameRate]);
        _mRenderTransform = [((AVAssetTrack *) [_mVideoTracks firstObject]) preferredTransform];
        _mTimeRange = [((AVAssetTrack *) [_mVideoTracks firstObject]) timeRange];
    }
    return self;
}

-(void)setOutputFrameRate:(int)frameRate
{
    _mFrameRate = frameRate > 0 && frameRate < _mFrameRate ? frameRate : _mFrameRate;
}

-(void)setOutputSize:(CGSize) size
{
    _mRenderSize = size;
}

-(void)setOutputTransform:(CGAffineTransform) transform
{
    _mRenderTransform = transform;
}

-(void)setOutputVolume:(float) volume
{
    _mOutputVolume = volume;
}

-(void)setOutputRange:(CMTimeRange) range
{
    CMTimeRange temp_range = range;
    // 做长度检测，如果设置的时间段长度比视频的长度长，那么对设置的长度进行裁剪
    if (CMTimeCompare(CMTimeAdd(temp_range.start, temp_range.duration), _mTimeRange.duration) > 0)
    {
        temp_range.duration = CMTimeSubtract(_mTimeRange.duration, temp_range.start);
    }
    _mTimeRange = temp_range;
}

-(void)setSourceVolume:(float) volume
{
    if(_mAudioTracks.count > 0)
    {
        for (int i = 0; i < _mAudioTracks.count; i++)
        {
            _mVolumes[i] = @(volume);
        }
    }
}

-(void)setupMusicTracks:(AVMutableComposition*)composition
{
    if (_mAudioTracks.count > 0)
    {
        _mAudioMix = [AVMutableAudioMix audioMix];
        _mAudioParameters = [NSMutableArray array];
        
        if (_mAudioTracks.count > 0)
        {
            NSUInteger i = 0;
            for (AVAssetTrack * audio_track in _mAudioTracks)
            {
                if([_mVolumes[i] floatValue] > 0)
                {
                    AVMutableCompositionTrack *source_audio_comp_track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                                  preferredTrackID:kCMPersistentTrackID_Invalid];
                    [_mAudioParameters addObject:(id)[AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:source_audio_comp_track]];
                    [[_mAudioParameters lastObject] setVolume:[_mVolumes[i] floatValue] atTime:kCMTimeZero];
                    [source_audio_comp_track insertTimeRange:_mTimeRange ofTrack:audio_track atTime:kCMTimeZero error:nil];
                }
                i++;
            }
        }
        _mAudioMix.inputParameters = _mAudioParameters;
    }
}

-(void)setupVideoTrack:(AVMutableComposition *) composition
{
    if (_mVideoTracks.count > 0)
    {
        for (AVAssetTrack * video_track in _mVideoTracks){
            AVMutableCompositionTrack *comp_video_track = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            [comp_video_track insertTimeRange:_mTimeRange ofTrack:video_track atTime:kCMTimeZero error:nil];
            
            _mVideoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:comp_video_track];
            [_mVideoLayerInstruction setTransform:_mRenderTransform atTime:kCMTimeZero];
            
            _mVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            _mVideoCompositionInstruction.timeRange = comp_video_track.timeRange;
            _mVideoCompositionInstruction.layerInstructions = @[_mVideoLayerInstruction];
        }
        
        _mOutputVideoComposition = [AVMutableVideoComposition videoComposition];
        _mOutputVideoComposition.instructions = @[_mVideoCompositionInstruction];
        _mOutputVideoComposition.frameDuration = CMTimeMake(1, _mFrameRate);
        _mOutputVideoComposition.renderSize = _mRenderSize;
    }
}

-(NSString *)getPreset:(ZLVideoExportPreset) preset
{
    switch (preset)
    {
        case VIDEO_EXPORT_PRESET_LOW:
            return AVAssetExportPresetLowQuality;
            
        case VIDEO_EXPORT_PRESET_MEDIUM:
            return AVAssetExportPresetMediumQuality;
            
        case VIDEO_EXPORT_PRESET_HIGH:
            return AVAssetExportPresetHighestQuality;
    }
    return AVAssetExportPresetMediumQuality;
}

-(void)finish:(ZLVideoExportPreset)preset finishHandle:(void(^ _Nullable)(BOOL))finishHandle
{
    _mComposition = [AVMutableComposition composition];
    [self setupVideoTrack:_mComposition];
    [self setupMusicTracks:_mComposition];
    
    _mAssetExport = [[AVAssetExportSession alloc] initWithAsset:_mComposition presetName:[self getPreset:preset] ];
    _mAssetExport.shouldOptimizeForNetworkUse = YES;
    _mAssetExport.videoComposition = _mOutputVideoComposition;
    _mAssetExport.outputFileType = AVFileTypeMPEG4; //设置导出格式，此处为"H.264"编码的mp4格式
    _mAssetExport.outputURL = [NSURL fileURLWithPath:_mOutput];
    _mAssetExport.audioMix = _mAudioMix;
    [_mAssetExport exportAsynchronouslyWithCompletionHandler:^(void ) {
        finishHandle(_mAssetExport.status == AVAssetExportSessionStatusCompleted);
    }];
    NSLog(@"%@", _mAssetExport.error);
}


@end
