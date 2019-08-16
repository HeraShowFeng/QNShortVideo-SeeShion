//
//  SXTextLayoutView.m
//  ShiPinDemo
//
//  Created by Zhiqiang Li on 07/11/2017.
//  Copyright © 2017 杨思宇. All rights reserved.
//

#import "SXTextLayoutView.h"
#import "PhotoTool.h"


@interface UIImage (UIImageFunctions)
- (UIImage *) scaleToSize: (CGSize)size;
- (UIImage *) scaleProportionalToSize: (CGSize)size;
@end
@implementation UIImage (UIImageFunctions)

- (UIImage *) scaleToSize: (CGSize)size
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(self.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
    }
    else
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}

- (UIImage *) scaleProportionalToSize: (CGSize)size1
{
    if(self.size.width>self.size.height)
    {
        NSLog(@"LandScape");
        size1=CGSizeMake((self.size.width/self.size.height)*size1.height,size1.height);
    }
    else
    {
        NSLog(@"Potrait");
        size1=CGSizeMake(size1.width,(self.size.height/self.size.width)*size1.width);
    }
    
    return [self scaleToSize:size1];
}

@end


@interface PinTuLabel:UILabel
@property (nonatomic, strong) UIColor * mStrokeColor;
@property (nonatomic, strong) NSNumber * mStrokeWidth;
@end

@implementation PinTuLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mStrokeColor = [UIColor blackColor];
        _mStrokeWidth = @(0);
    }
    return self;
}


- (CGSize)contentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSStrokeWidthAttributeName : _mStrokeWidth,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [self.text boundingRectWithSize:self.frame.size
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}

-(void)drawTextInRect:(CGRect)rect
{
    CGSize shadowOffset = self.shadowOffset;
    UIColor *textColor = self.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    if(_mStrokeColor != nil && _mStrokeWidth != nil && _mStrokeWidth.floatValue > 0)
    {
        CGContextSetLineWidth(c, _mStrokeWidth.floatValue);
        CGContextSetLineJoin(c, kCGLineJoinRound);
        
        CGContextSetTextDrawingMode(c, kCGTextStroke);
        self.textColor = _mStrokeColor;
        [super drawTextInRect:rect];
    }
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    self.textColor = textColor;
    self.shadowOffset = CGSizeMake(0, 0);
    [super drawTextInRect:rect];
    
    self.shadowOffset = shadowOffset;
}

@end

@interface SXTextLayoutView()
{
    CGFloat mFontSize;
    CGFloat mBackupFontSize;
    CGFloat mContentFontSize;
    CGFloat mBackupContentFontSize;
    NSTextAlignment mBackupAlignment;
    CGFloat mBackupAlpha;
}
@property(nonatomic, strong) PinTuLabel * mMainLabel;
@property(nonatomic, strong) PinTuLabel * mContentLabel;
@property(nonatomic, strong) UIFont * mTitleFont;
@property(nonatomic, strong) UIFont * mBackupTitleFont;
@property(nonatomic, strong) UIFont * mContentFont;
@property(nonatomic, strong) UIFont * mBackupContentFont;

@property(nonatomic, strong) UIColor * mBackupTextColor;
@property(nonatomic, strong) UIColor * mBackupBgColor;

@property(nonatomic, strong) NSValue * mFixedSize;
@end

@implementation SXTextLayoutView

-(void)saveState
{
    mBackupFontSize = mFontSize;
    mBackupContentFontSize = mContentFontSize;
    mBackupAlignment = _mMainLabel.textAlignment;
    mBackupAlpha = [self getTextAlpha];
    _mBackupTitleFont = _mTitleFont;
    _mBackupContentFont = _mContentFont;
    _mBackupTextColor = _mMainLabel.textColor;
    _mBackupBgColor = self.backgroundColor;
}

-(void)restoreState
{
    [self setFontSize:mBackupFontSize];
    [self setFont:_mBackupTitleFont];
    [self setTextAlpha:mBackupAlpha];
    _mMainLabel.textColor = _mBackupTextColor;
    _mContentLabel.textColor = _mBackupTextColor;
    self.backgroundColor = _mBackupBgColor;
    _mMainLabel.textAlignment = mBackupAlignment;
    _mContentLabel.textAlignment = mBackupAlignment;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        mFontSize = 15;
        mContentFontSize = 0;
        _mContentFont = nil;
        self.backgroundColor = [UIColor clearColor];
        _mMainLabel = [[PinTuLabel alloc] init];
        _mMainLabel.numberOfLines = 0;
        _mMainLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _mContentLabel = [[PinTuLabel alloc] init];
        _mContentLabel.numberOfLines = 0;
        _mContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_mMainLabel];
        [self addSubview:_mContentLabel];
        _mTitleFont = [UIFont boldSystemFontOfSize:mFontSize];
        [self updateFont];
        _mMainLabel.textAlignment = NSTextAlignmentCenter;
        _mContentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(BOOL)mHasDetailLabel
{
    return _mContentLabel != nil;
}

-(void)setMHasDetailLabel:(BOOL)mHasDetailLabel
{
    if (mHasDetailLabel && _mContentLabel == nil) {
        _mContentLabel = [[PinTuLabel alloc] init];
        _mContentLabel.numberOfLines = 0;
        _mContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self updateFont];
        _mContentLabel.textAlignment = _mMainLabel.textAlignment;
        _mContentLabel.textColor = _mMainLabel.textColor;
        [self update];
    }
    else if (!mHasDetailLabel && _mContentLabel != nil)
    {
        _mContentLabel = nil;
        [self update];
    }
}

-(void) setTitleContent:(NSString *) content
{
    _mMainLabel.text = content;
}

-(void) setDetailContent:(NSString *) content
{
    _mContentLabel.text = content;
}

-(void) updateFont
{
    _mTitleFont = [_mTitleFont fontWithSize:mFontSize];
    _mMainLabel.font = _mTitleFont;
    _mContentLabel.font = _mContentFont == nil  || mContentFontSize == 0 ? [_mTitleFont fontWithSize:mFontSize * 0.6] : [_mContentFont fontWithSize:mContentFontSize];
}

-(void) setFontSize:(CGFloat) size
{
    mFontSize = size;
    [self updateFont];
}

-(void) setFont:(UIFont *) font
{
    _mTitleFont = font;
    [self updateFont];
}

-(void) setContentFont:(UIFont *) font
{
    _mContentFont = font;
    [self updateFont];
}

-(void) setContentFontSize:(CGFloat) fontSize
{
    mContentFontSize = fontSize;
    [self updateFont];
}

-(void) setTextAlpha:(CGFloat) alpha
{
    _mMainLabel.alpha = alpha;
    _mContentLabel.alpha = alpha;
}

-(CGFloat) getTextAlpha
{
    return _mMainLabel.alpha;
}

-(void) setStrokeColor:(UIColor *) color
{
    _mMainLabel.mStrokeColor = color;
    _mContentLabel.mStrokeColor = color;
}

-(void) setStrokeWidth:(CGFloat) width
{
    _mMainLabel.mStrokeWidth = @(width);
    _mContentLabel.mStrokeWidth = @(width);
}

-(void) setColor:(UIColor *) color
{
    _mMainLabel.textColor = color;
    _mContentLabel.textColor = color;
}

-(void) setAlignment:(int) alignment
{
    switch (alignment)
    {
        case 0:
            _mMainLabel.textAlignment = NSTextAlignmentLeft;
            _mContentLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case 1:
            _mMainLabel.textAlignment = NSTextAlignmentRight;
            _mContentLabel.textAlignment = NSTextAlignmentRight;
            break;
        case 2:
            _mMainLabel.textAlignment = NSTextAlignmentCenter;
            _mContentLabel.textAlignment = NSTextAlignmentCenter;
            break;
        default:
            break;
    }
}

-(NSString *) getTitleContent
{
    return _mMainLabel.text;
}

-(NSString *) getDetailContent
{
    return _mContentLabel.text;
}

-(CGFloat) getFontSize
{
    return mFontSize;
}

-(UIImage *) snapViewToPath:(NSString *) outputPath
{
    UIImage *viewImage = [self snapView];
    viewImage = [viewImage scaleToSize:viewImage.size];
    NSData *data = nil;
    if ([outputPath containsString:@".jpg"] || [outputPath containsString:@".JPG"])
    {
        data = UIImageJPEGRepresentation(viewImage, 0.8);
    }
    else
    {
        data = UIImagePNGRepresentation(viewImage);
    }
    
    [data writeToFile:outputPath atomically:YES];
    return viewImage;
}

-(UIImage *) snapView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

-(void) setFixedSize:(CGSize) size
{
    if(CGSizeEqualToSize(size, CGSizeZero))
    {
        _mFixedSize = nil;
        [self update];
    }
    else
    {
        _mFixedSize = [NSValue valueWithCGSize:size];
        self.frame = CGRectMake(0, 0, size.width, size.height);
        _mMainLabel.frame = self.bounds;
        _mContentLabel.frame = self.bounds;
    }
}

-(void) update
{
    if(_mFixedSize == nil)
    {
        _mMainLabel.bounds = self.bounds;
        _mContentLabel.bounds = self.bounds;
        CGSize titleSize = [_mMainLabel contentSize];
        CGSize detalSize = [_mContentLabel contentSize];
        CGFloat height = titleSize.height + detalSize.height + ([self mHasDetailLabel] ? 10 : 0.0);
        CGFloat originY = (self.bounds.size.height - height) * 0.5;
        if (height < self.bounds.size.height) {
            originY = 0.0;
        }
        _mMainLabel.frame = CGRectMake(0, originY, self.bounds.size.width + 1, titleSize.height);
        _mContentLabel.frame = CGRectMake(0, _mMainLabel.frame.origin.y + titleSize.height + 10, self.bounds.size.width, detalSize.height);
    }
    else
    {
        [self setFixedSize:_mFixedSize.CGSizeValue];
    }
}

-(void) updateLayout:(CGSize) size
{
    self.frame = CGRectMake(0, 0, size.width, size.height);
    [self update];
}


@end





