//
//  TextEditView.m
//  ShiPinDemo
//
//  Created by 杨思宇 on 2017/11/9.
//  Copyright © 2017年 杨思宇. All rights reserved.
//

#import "TextEditBoard.h"
#import "TextEditButton.h"
//#import "GeometryTool.h"
#import "SXTextLayoutView.h"
#import "SXTextEditFontView.h"
#import "SXTextEditColorView.h"
//#import "NetTool.h"
//#import "FontTool.h"

#define YSYImageNamed(imageName)  [UIImage imageNamed:imageName]
#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height
#define iOSPP_W (Screen_W/375)
#define iOSPP_H (Screen_H/667)
#define ColorBase(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define ColorBaseWithAlpha(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define FontBase(N) [UIFont systemFontOfSize:N]
#define FontDIY(N,S) [UIFont fontWithName:N size:S]//自定义字体
#define FontBlodBase(N) [UIFont fontWithName:@"Helvetica-Bold" size:N]
#define kPinkColor @"ff00ff"
#define kTextViewHeight 54.0f

#define kMargin_LR 15*iOSPP_W

static const int kButtonStartTag = 1000;
@interface TextEditBoard ()<UITextViewDelegate>
{
    CGRect _frame;
}

@property (nonatomic, strong) NSArray *buttonTitleNameArr;

@property (nonatomic, strong) UIView *btnsView;
@property (nonatomic, strong) UIView *textInputView;
@property (nonatomic, strong) UIView *textAlignmentView;
@property (nonatomic, strong) UIView *textFontView;
@property (nonatomic, strong) UIView *textColorView;
@property (nonatomic, strong) UIButton *rigthAliBtn;
@property (nonatomic, strong) UIButton *centerAliBtn;
@property (nonatomic, strong) UIButton *leftAliBtn;
@property (nonatomic, strong) NSMutableArray *fontArr;
@property (nonatomic, strong) NSArray *txtColorArr;
@property (nonatomic, strong) NSArray *bgColorArr;
@property (nonatomic, strong) UITextView * titleTextInputView;
@property (nonatomic, strong) UIView * titleContainerView;
@property (nonatomic, strong) UILabel * textCountLabel;
@property (nonatomic, strong) UISlider * alphaSlider;
@property (nonatomic, strong) UISlider * fontSizeSlider;
@property (nonatomic, strong) UIView *textNumberView;
@property (nonatomic, strong)  UIView *bgTextView;
@property (nonatomic, weak) SXPinTuAssetModel * mAsset;
@property (nonatomic, weak) SXAssetModel * mUIAsset;
@property (nonatomic, strong) SXTextEditFontView *textEditFontView;
@property (nonatomic, strong) SXTextEditColorView *textEditColorView;
@property (nonatomic, assign) CGRect boardRct;

@end

@implementation TextEditBoard

- (instancetype)init
{
    self = [super init];
    if (self) {
        _frame = CGRectZero;
        _buttonTitleNameArr = @[L(@"content"),
                                L(@"font"),
                                L(@"color")];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame = frame;
        [self commonInit];
    }
    return self;
}

-(void) commonInit
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(_frame) ? CGRectGetHeight(_frame) : 227);
//    [NetTool uploadUrl:@"App/Diy/fontList" parameters:[@{} mutableCopy] AndFinish:^(NSDictionary * _Nullable result, NSError * _Nullable error) {
//        NSLog(@"%@---%@",result, error);
//        if (error != nil && result[@"data"]) {
//        _fontArr = [NSMutableArray arrayWithArray:result[@"data"]];
//        }
//    }];
    
    //假数据
    _txtColorArr = @[@{@"r":@255,@"g":@255,@"b":@255, @"a":@1},//第一个固定白色
                     @{@"r":@255,@"g":@38,@"b":@0, @"a":@1},
                     @{@"r":@254,@"g":@127,@"b":@3, @"a":@1},
                     @{@"r":@254,@"g":@254,@"b":@0, @"a":@1},
                     @{@"r":@125,@"g":@255,@"b":@0, @"a":@1},
                     @{@"r":@0,@"g":@255,@"b":@255, @"a":@1},
                     @{@"r":@0,@"g":@126,@"b":@255, @"a":@1},
                     @{@"r":@253,@"g":@1,@"b":@254, @"a":@1},
                     @{@"r":@255,@"g":@126,@"b":@121, @"a":@1},
                     @{@"r":@252,@"g":@201,@"b":@101, @"a":@1},
                     @{@"r":@203,@"g":@254,@"b":@101, @"a":@1},
                     @{@"r":@102,@"g":@254,@"b":@102, @"a":@1},
                     @{@"r":@101,@"g":@254,@"b":@203, @"a":@1},
                     @{@"r":@100,@"g":@201,@"b":@251, @"a":@1},
                     @{@"r":@101,@"g":@101,@"b":@253, @"a":@1},
                     @{@"r":@199,@"g":@100,@"b":@250, @"a":@1},
                     @{@"r":@122,@"g":@3,@"b":@3, @"a":@1},
                     @{@"r":@127,@"g":@64,@"b":@4, @"a":@1},
                     @{@"r":@126,@"g":@126,@"b":@3, @"a":@1},
                     @{@"r":@62,@"g":@123,@"b":@1, @"a":@1},
                     @{@"r":@2,@"g":@64,@"b":@128, @"a":@1},
                     @{@"r":@65,@"g":@3,@"b":@127, @"a":@1},
                     @{@"r":@123,@"g":@3,@"b":@62, @"a":@1},
                     @{@"r":@0,@"g":@0,@"b":@0, @"a":@1}
                     ];
    _bgColorArr =  @[@{@"r":@255,@"g":@255,@"b":@255, @"a":@0},
                     @{@"r":@252,@"g":@161,@"b":@128, @"a":@1},
                     @{@"r":@255,@"g":@217,@"b":@142, @"a":@1},
                     @{@"r":@227,@"g":@255,@"b":@170, @"a":@1},
                     @{@"r":@185,@"g":@249,@"b":@255, @"a":@1},
                     @{@"r":@184,@"g":@185,@"b":@255, @"a":@1},
                     @{@"r":@235,@"g":@197,@"b":@255, @"a":@1},
                     @{@"r":@255,@"g":@190,@"b":@255, @"a":@1},
                     @{@"r":@255,@"g":@126,@"b":@121, @"a":@1},
                     @{@"r":@203,@"g":@254,@"b":@101, @"a":@1},
                     @{@"r":@102,@"g":@254,@"b":@102, @"a":@1},
                     @{@"r":@101,@"g":@254,@"b":@203, @"a":@1},
                     @{@"r":@100,@"g":@201,@"b":@251, @"a":@1},
                     @{@"r":@101,@"g":@101,@"b":@253, @"a":@1},
                     @{@"r":@199,@"g":@100,@"b":@250, @"a":@1},
                     @{@"r":@255,@"g":@38,@"b":@0, @"a":@1},
                     @{@"r":@254,@"g":@127,@"b":@3, @"a":@1},
                     @{@"r":@254,@"g":@254,@"b":@0, @"a":@1},
                     @{@"r":@125,@"g":@255,@"b":@0, @"a":@1},
                     @{@"r":@0,@"g":@255,@"b":@255, @"a":@1},
                     @{@"r":@0,@"g":@126,@"b":@255, @"a":@1},
                     @{@"r":@127,@"g":@2,@"b":@254, @"a":@1},
                     @{@"r":@253,@"g":@1,@"b":@254, @"a":@1},
                     @{@"r":@122,@"g":@3,@"b":@3, @"a":@1},
                     @{@"r":@127,@"g":@64,@"b":@4, @"a":@1},
                     @{@"r":@126,@"g":@126,@"b":@3, @"a":@1},
                     @{@"r":@62,@"g":@123,@"b":@1, @"a":@1},
                     @{@"r":@2,@"g":@64,@"b":@128, @"a":@1},
                     @{@"r":@65,@"g":@3,@"b":@127, @"a":@1},
                     @{@"r":@123,@"g":@3,@"b":@62, @"a":@1},
                     @{@"r":@0,@"g":@0,@"b":@0, @"a":@1},
                     ];
    self.backgroundColor = [UIColor blackColor];
    [self creatSubView];
    [self addKeyboardNotification];
}

-(void) addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidChangeFrameNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) removeKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification *) notification
{
    CGRect currentFrame = self.frame;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.boardRct = keyboardRect;
    if (keyboardRect.origin.y < Screen_H) {
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(currentFrame.origin.x, keyboardRect.origin.y - (currentFrame.size.height - 88 - 44), currentFrame.size.width, currentFrame.size.height);
        }];
    }
    
}
- (void) keyBoardDidChangeFrame:(NSNotification*)notification {
    
}

-(void) keyboardWillHide:(NSNotification *) notification
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
}

-(void)creatSubView{
    //初始值
    _titleStr = @"主标题";
    _fontName = [_fontArr firstObject][@"font_name"];
    _fontSzie = 10.0;
    _fontAlhpa = 1;
    _txtAlignment = 0;
    _txtColorDic = @{@"r":@0,@"g":@0,@"b":@0, @"a":@1};
    _bgColorDic = @{@"r":@0,@"g":@0,@"b":@0, @"a":@0};
    for (UIView *subV in self.subviews) {
        [subV removeFromSuperview];
    }
    
    [self creatTopBtnsView];
    [self creatTextInputView];
    [self creatTextAlignmentView];
    [self creatFontEditView];
    [self creatTextColorView];
}

-(void)creatTopBtnsView{
    CGFloat btnsView_H = 44.0;
    
    _btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, btnsView_H)];
    CGFloat btn_W = 60;
    CGFloat positionX = kMargin_LR;
    for (int i = 0; i < _buttonTitleNameArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(positionX, 10.0, btn_W, 24.0);
        button.titleLabel.font = [UIFont systemFontOfSize:10.0];
        [button setTitle:_buttonTitleNameArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        [button setBackgroundImage:[UIImage imageWithBorderWidth:1.0 corner:CGRectGetHeight(button.bounds) / 2 size:button.bounds.size fillColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithCorner:CGRectGetHeight(button.bounds) / 2 size:button.bounds.size fillColor:kMainColor] forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(handleSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = kButtonStartTag + i;
        [_btnsView addSubview:button];
        positionX += 5.0 + CGRectGetWidth(button.bounds);
    }
    UIButton *button = [_btnsView viewWithTag:kButtonStartTag];
    if (button) {
        [self handleSelectAction:button];
    }
    
    [self addSubview:_btnsView];
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDone.frame = CGRectMake(Screen_W - kMargin_LR - 60.0, 8.0, 60, 28);
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone setBackgroundImage:[UIImage imageWithCorner:CGRectGetHeight(btnDone.bounds) / 2 size:btnDone.bounds.size fillColor:kMainColor] forState:UIControlStateNormal];
    btnDone.layer.cornerRadius = CGRectGetHeight(btnDone.frame)/2;
    [btnDone setTitle:L(@"confirm") forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnDone addTarget:self action:@selector(handleDoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_btnsView addSubview:btnDone];
}

-(void)creatTextInputView{
    _textInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnsView.frame), Screen_W, CGRectGetHeight(self.bounds)-CGRectGetMaxY(_btnsView.frame))];
    [self addSubview:_textInputView];
    
    CGFloat textMargin_TB = 8.0;
    
    _bgTextView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, Screen_W, kTextViewHeight)];
    [_textInputView addSubview:_bgTextView];
    
    _titleContainerView = [[UIView alloc] initWithFrame:CGRectMake(kMargin_LR, textMargin_TB, Screen_W - kMargin_LR * 2, CGRectGetHeight(_bgTextView.bounds) - textMargin_TB * 2)];
    _titleContainerView.layer.cornerRadius = 4;
    _titleContainerView.layer.masksToBounds = true;
    _titleContainerView.backgroundColor = [UIColor whiteColor];
    [_bgTextView addSubview:_titleContainerView];
    
    _titleTextInputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _titleContainerView.frame.size.width - 44*iOSPP_W, _titleContainerView.frame.size.height)];
    _titleTextInputView.font = FontBase(17);
    _titleTextInputView.delegate = self;
    //_titleTextInputView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [_titleContainerView addSubview:_titleTextInputView];
    
    self.textNumberView = [[UIView alloc] initWithFrame:CGRectMake(_titleContainerView.frame.size.width - 54*iOSPP_W, 0, 54*iOSPP_W, _titleContainerView.frame.size.height)];
//    self.textNumberView.backgroundColor = [UIColor colorWithHexString:kPinkColor];
//    self.textNumberView.alpha = 0.2;
    [_titleContainerView addSubview:self.textNumberView];

    
    _textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_titleContainerView.bounds) - 0.0, 0.0, 0.0, _titleContainerView.frame.size.height)];
    _textCountLabel.font = FontBase(10);
    _textCountLabel.textColor = UIColor.blackColor;
    _textCountLabel.textAlignment = NSTextAlignmentCenter;
    [_titleContainerView addSubview:_textCountLabel];
}

-(void) removeDetailTextInput
{
    for (UIView * view in _textInputView.subviews) {
        [view removeFromSuperview];
    }
    
    _textInputView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnsView.frame), Screen_W, CGRectGetHeight(self.bounds)-CGRectGetMaxY(_btnsView.frame))];
    [self addSubview:_textInputView];
    
    CGFloat TV_H = CGRectGetHeight(_textInputView.frame)*8/9;
    CGFloat margin_TB = CGRectGetHeight(_textInputView.frame)/9/3;
    
    UIView *zhuV = [self creatLabTxtView:CGRectMake(0, margin_TB, Screen_W, TV_H) labTitle:@"主" txtVTag:101 isTitle:YES];
    [_textInputView addSubview:zhuV];
}

-(UIView *)creatLabTxtView:(CGRect)frame labTitle:(NSString *)labTitle txtVTag:(NSInteger)txtVTag  isTitle:(BOOL) isTitle{
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45*iOSPP_W, CGRectGetHeight(frame))];
    lab.text = labTitle;
    lab.font = FontBase(15);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = ColorBase(255, 255, 255);
    UITextView *TV = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lab.frame), 0, Screen_W-CGRectGetMaxX(lab.frame)-kMargin_LR, CGRectGetHeight(frame))];
    TV.layer.borderColor = ColorBase(112, 112, 112).CGColor;
    TV.layer.borderWidth = 1;
    TV.layer.cornerRadius = 4;
    TV.textColor = ColorBase(255, 255, 255);
    TV.font = FontBase(13);
    TV.tag = txtVTag;
    TV. delegate = self;
    TV.backgroundColor = [UIColor blackColor];
    _titleTextInputView = TV;
    [bgView addSubview:lab];
    [bgView addSubview:TV];
    return bgView;
}

-(void)creatTextAlignmentView{
    self.textEditFontView = [[SXTextEditFontView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnsView.frame), Screen_W, CGRectGetHeight(self.bounds)-CGRectGetMaxY(_btnsView.frame))];
    self.textEditFontView.hidden = YES;
    [self.textEditFontView upDateTableView];
    self.textEditFontView.selectTextFontBlock = ^(NSString *fontName) {
        _fontName = fontName;
        UIFont * font = FontDIY(_fontName, 15);
        [[_mAsset getSXTextLayoutView] setFont:font];
        [_mAsset updateTextAsset];
        if ([self.delegate respondsToSelector:@selector(textEditBoardFontChanged:)])
        {
            [self.delegate textEditBoardFontChanged:font];
        }
    };
    [self addSubview:self.textEditFontView];

}

-(UIButton *)creatAlignmentBtnWithFrame:(CGRect)frame
                           cornerRadius:(CGFloat)cornerRadius
                                  title:(NSString *)title
                             titleColor:(UIColor *)titleColor
                              titleFont:(UIFont *)titleFont
                                imgName:(NSString *)imgName
                                 btnTag:(NSInteger)btnTag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.tag = btnTag;
    btn.layer.cornerRadius = cornerRadius;
    if (![SXCommonUtil isBlank:title]) {
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = titleFont;
    }else{
        [btn setImage:YSYImageNamed(imgName) forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(handleAlignmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(UILabel *)creatLabWithFrame:(CGRect)frame txt:(NSString *)txt txtFont:(UIFont *)txtfont TxtAlignment:(NSTextAlignment)txtAlignment {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.text = txt;
    lab.textColor = [UIColor whiteColor];
    lab.font = txtfont;
    lab.textAlignment = txtAlignment;
    return lab;
}

-(UIButton *)creatButtonWithFrame:(CGRect)frame
                              txt:(NSString *)txt
                         txtColor:(UIColor *)txtColor
                          txtFont:(UIFont *)txtfont
                     txtAlignment:(NSTextAlignment)txtAlignment
                           btnTag:(NSInteger)btnTag{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:txt forState:UIControlStateNormal];
    [btn setTitleColor:txtColor forState:UIControlStateNormal];
    btn.titleLabel.font = txtfont;
    btn.titleLabel.textAlignment = txtAlignment;
    [btn addTarget:self action:@selector(handleTxtFontAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

-(void)creatFontEditView{
    
    self.textEditColorView = [[SXTextEditColorView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnsView.frame), Screen_W, CGRectGetHeight(self.bounds)-CGRectGetMaxY(_btnsView.frame))];
    self.textEditColorView.hidden = YES;
    [self.textEditColorView updateColllectionView:_txtColorArr WithBorderColors:_bgColorArr];
    self.textEditColorView.selectColorBlock = ^(BOOL isText, NSDictionary * _Nonnull colorDict) {
        _txtColorDic = colorDict;
        [[_mAsset getSXTextLayoutView] setColor:[UIColor colorWithRed:((NSNumber*)_txtColorDic[@"r"]).floatValue / 255.0
                                                                green:((NSNumber*)_txtColorDic[@"g"]).floatValue / 255.0
                                                                 blue:((NSNumber*)_txtColorDic[@"b"]).floatValue / 255.0
                                                                alpha:((NSNumber*)_txtColorDic[@"a"]).floatValue]];
        [_mAsset updateTextAsset];
        if ([self.delegate respondsToSelector:@selector(textEditBoardTextColorChanged:)])
        {
            [self.delegate textEditBoardTextColorChanged:[UIColor colorWithRed:((NSNumber*)_txtColorDic[@"r"]).floatValue / 255.0
                                                                         green:((NSNumber*)_txtColorDic[@"g"]).floatValue / 255.0
                                                                          blue:((NSNumber*)_txtColorDic[@"b"]).floatValue / 255.0
                                                                         alpha:((NSNumber*)_txtColorDic[@"a"]).floatValue]];
        }
    };
    self.textEditColorView.selectBorderWidthBlock = ^(CGFloat borderwidth) {
        NSLog(@"这是改变边框大小%f",borderwidth);
    };
    [self addSubview:self.textEditColorView];
}

-(void)creatTextColorView{
    _textColorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_btnsView.frame), Screen_W, CGRectGetHeight(self.bounds)-CGRectGetMaxY(_btnsView.frame))];
    _textColorView.hidden = YES;
    
    CGFloat textColorView_H = CGRectGetHeight(_textColorView.frame);
    CGFloat lab_H = 30*iOSPP_H;
    UILabel *txtColorLab = [self creatLabWithFrame:CGRectMake(kMargin_LR, textColorView_H/3-lab_H/2, lab_H*3/2, lab_H) txt:@"文字" txtFont:FontBase(13) TxtAlignment:NSTextAlignmentCenter];
    
    UIScrollView *txtColorSV = [self creatColorScrollViewWithFrame:CGRectMake(CGRectGetMaxX(txtColorLab.frame), CGRectGetMinY(txtColorLab.frame), Screen_W-CGRectGetMaxX(txtColorLab.frame), lab_H) colorArr:_txtColorArr tagOrigin:2000];
    [_textColorView addSubview:txtColorLab];
    [_textColorView addSubview:txtColorSV];
    [self addSubview:_textColorView];
}

-(UIScrollView *)creatColorScrollViewWithFrame:(CGRect)frame colorArr:(NSArray *)colorArr tagOrigin:(NSInteger)tagOrigin{
    
    UIScrollView *colorSV = [[UIScrollView alloc] initWithFrame:frame];
    colorSV.showsHorizontalScrollIndicator = NO;
    CGFloat btn_W = 24*iOSPP_H;
    CGFloat tempX = 0.0;
    for (int i = 0; i < colorArr.count; i++) {
        NSDictionary *colorDic = colorArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = tagOrigin + i;
        btn.frame = CGRectMake((btn_W + btn_W/2)*i, (CGRectGetHeight(frame) - btn_W)/2, btn_W, btn_W);
        btn.backgroundColor = ColorBase([colorDic[@"r"] floatValue], [colorDic[@"g"] floatValue], [colorDic[@"b"] floatValue]);
        if([colorDic[@"a"] floatValue] == 0)
        {
            [btn setImage:YSYImageNamed(@"icon_colourless") forState:UIControlStateNormal];
        }
        btn.layer.cornerRadius = btn_W/2;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 1;
        [btn addTarget:self action:@selector(handleColorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [colorSV addSubview:btn];
        tempX = CGRectGetMaxX(btn.frame);
    }
    colorSV.contentSize = CGSizeMake(tempX, CGRectGetHeight(frame));
    return colorSV;
}

- (void)layoutInputView {
    int maxLength = _mUIAsset.editModel.maxLength;
    CGRect frame = _textCountLabel.frame;
    if (maxLength > 0) {
        frame.size.width = 44;
        _textCountLabel.text = [NSString stringWithFormat:@"%i/%i", (int)_titleTextInputView.text.length, maxLength];
    }else {
        frame.size.width = 0.0;
        _textCountLabel.text = @"";
    }
    frame.origin.x = CGRectGetWidth(_titleContainerView.bounds) - frame.size.width;
    _textCountLabel.frame = frame;
    frame = _titleTextInputView.frame;
    frame.size.width = CGRectGetWidth(_titleContainerView.bounds) - CGRectGetWidth(_textCountLabel.bounds);
    _titleTextInputView.frame = frame;
}

#pragma mark -- btn Actions
-(void)handleSelectAction:(UIButton *)btn{
    for (int i = 0; i < _buttonTitleNameArr.count; i++) {
        UIView *view = [_btnsView viewWithTag:kButtonStartTag + i];
        if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton*)view setEnabled:view != btn];
        }
    }
    _textInputView.hidden = btn.tag == 1000 ? NO : YES;
    self.textEditFontView.hidden = btn.tag == 1001 ? NO : YES;
    self.textEditColorView.hidden = btn.tag == 1002 ? NO : YES;
    _textColorView.hidden = btn.tag == 1003 ? NO : YES;
    if(_textInputView.hidden == YES)
    {
        [_titleTextInputView resignFirstResponder];
    }
}

//字体选择
-(void)handleTxtFontAction:(UIButton *)fontBtn{
    _fontName = _fontArr[fontBtn.tag][@"font_name"];
    UIFont * font = FontDIY(_fontName, 15);
    [[_mAsset getSXTextLayoutView] setFont:font];
    [_mAsset updateTextAsset];
    if ([self.delegate respondsToSelector:@selector(textEditBoardFontChanged:)])
    {
        [self.delegate textEditBoardFontChanged:font];
    }
}

//完成事件
-(void)handleDoneBtnAction:(UIButton *)doneBtn{
    [_titleTextInputView resignFirstResponder];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_titleStr forKey:@"title"];
    [dic setObject:[NSNumber numberWithFloat:_fontSzie] forKey:@"fontSzie"];
    [dic setObject:[NSNumber numberWithFloat:_fontAlhpa] forKey:@"fontAlhpa"];
    [dic setObject:[NSNumber numberWithInteger:_txtAlignment] forKey:@"txtAlignment"];
//    [dic setObject:_fontName forKey:@"fontName"];
//    [dic setObject:_txtColorDic forKey:@"txtColorDic"];
//    [dic setObject:_bgColorDic forKey:@"bgColorDic"];
    [self dismiss];
    //dic 待赋值
    if ([self.delegate respondsToSelector:@selector(textEditBoardDone:)]) {
        [self.delegate textEditBoardDone:dic];
    }
}

//重置
-(void)handleBackBtnAction:(UIButton *)backBtn{
    [_alphaSlider setValue:0.0 animated:YES];
    [self sliderValueChanged:_alphaSlider];
    [_fontSizeSlider setValue:1.0 animated:YES];
    [self sliderValueChanged:_fontSizeSlider];
    [_leftAliBtn setImage:YSYImageNamed(@"12_icon_left_nor") forState:UIControlStateNormal];
    [_centerAliBtn setImage:YSYImageNamed(@"12_icon_center_nor") forState:UIControlStateNormal];
    [_rigthAliBtn setImage:YSYImageNamed(@"12_icon_right_nor") forState:UIControlStateNormal];
   [[_mAsset getSXTextLayoutView] setAlignment:1];
    
    [[_mAsset getSXTextLayoutView] restoreState];
    if ([self.delegate respondsToSelector:@selector(textEditBoardRequestForStyleReset)])
    {
        [self.delegate textEditBoardRequestForStyleReset];
    }
}

-(void)sliderValueChanged:(UISlider *)slider{
    switch (slider.tag) {
        case 101://大小
        {
            _fontSzie = slider.value;
            [[_mAsset getSXTextLayoutView] setFontSize:_fontSzie * 70 + 10];
            [_mAsset updateTextAsset];
            if([self.delegate respondsToSelector:@selector(textEditBoardTextFontSizeChanged:)])
            {
                [self.delegate textEditBoardTextFontSizeChanged:_fontSzie];
            }
        }
            break;
        case 102://透明度
        {
            _fontAlhpa = slider.value;
            [[_mAsset getSXTextLayoutView] setAlpha:1.0 - _fontAlhpa];
            [_mAsset updateTextAsset];
            if([self.delegate respondsToSelector:@selector(textEditBoardContentAlphaChanged:)])
            {
                [self.delegate textEditBoardContentAlphaChanged:_fontAlhpa];
            }
        }
            break;
        default:
            break;
    }
}

-(void)handleAlignmentBtnAction:(UIButton *)btn{
    _txtAlignment = btn.tag;
    NSString *leftAliBtnImgName = [NSString stringWithFormat:@"12_icon_left%@",(NSTextAlignment)_txtAlignment == NSTextAlignmentLeft ? @"" :@"_nor"];
    [_leftAliBtn setImage:YSYImageNamed(leftAliBtnImgName) forState:UIControlStateNormal];
    NSString *centerAliBtnImgName = [NSString stringWithFormat:@"12_icon_center%@",(NSTextAlignment)_txtAlignment == NSTextAlignmentCenter ? @"" :@"_nor"];
    [_centerAliBtn setImage:YSYImageNamed(centerAliBtnImgName) forState:UIControlStateNormal];
    NSString *rigthAliBtnImgName = [NSString stringWithFormat:@"12_icon_right%@",(NSTextAlignment)_txtAlignment == NSTextAlignmentRight ? @"" :@"_nor"];
    [_rigthAliBtn setImage:YSYImageNamed(rigthAliBtnImgName) forState:UIControlStateNormal];
    switch ((NSTextAlignment)_txtAlignment)
    {
        case NSTextAlignmentLeft:
        {
            [[_mAsset getSXTextLayoutView] setAlignment:0];
        }
            break;
        case NSTextAlignmentRight:
            [[_mAsset getSXTextLayoutView] setAlignment:1];
            break;
        case NSTextAlignmentCenter:
            [[_mAsset getSXTextLayoutView] setAlignment:2];
        default:
            break;
    }
    [_mAsset updateTextAsset];
    
    if ([self.delegate respondsToSelector:@selector(textEditBoardTextAlignmentChanged:)])
    {
        [self.delegate textEditBoardTextAlignmentChanged:(NSTextAlignment)_txtAlignment];
    }
}

-(void)handleColorBtnAction:(UIButton *)colorBtn
{
    _txtColorDic = [NSDictionary dictionaryWithDictionary:_txtColorArr[colorBtn.tag-2000]];
    [[_mAsset getSXTextLayoutView] setColor:[UIColor colorWithRed:((NSNumber*)_txtColorDic[@"r"]).floatValue / 255.0
                                                          green:((NSNumber*)_txtColorDic[@"g"]).floatValue / 255.0
                                                           blue:((NSNumber*)_txtColorDic[@"b"]).floatValue / 255.0
                                                          alpha:((NSNumber*)_txtColorDic[@"a"]).floatValue]];
    [_mAsset updateTextAsset];
    if ([self.delegate respondsToSelector:@selector(textEditBoardTextColorChanged:)])
    {
        [self.delegate textEditBoardTextColorChanged:[UIColor colorWithRed:((NSNumber*)_txtColorDic[@"r"]).floatValue / 255.0
                                                                     green:((NSNumber*)_txtColorDic[@"g"]).floatValue / 255.0
                                                                      blue:((NSNumber*)_txtColorDic[@"b"]).floatValue / 255.0
                                                                     alpha:((NSNumber*)_txtColorDic[@"a"]).floatValue]];
    }
}

#pragma mark -- UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    self.textCountLabel.text = [NSString  stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length,_mUIAsset.editModel.maxLength];
    _titleStr = textView.text;
    [[_mAsset getSXTextLayoutView] setTitleContent:_titleStr];
    [_mAsset updateTextAsset];
    if ([self.delegate respondsToSelector:@selector(textEditBoardTitleContentChanged:)])
    {
        [self.delegate textEditBoardTitleContentChanged:_titleStr];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *nowTextStr = [NSString stringWithFormat:@"%@%@",textView.text,text];
    if (nowTextStr.length > _mUIAsset.editModel.maxLength) {
        return NO;
    }
    
    CGRect frame = textView.frame;
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    
    frame.size.height = height;
    if (height < 88) {
        [UIView animateWithDuration:0.5 animations:^{
            [self changeTextViewWithHeight:height];
        } completion:nil];
    }
    
    return YES;
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    float textHeight;
    if (size.size.height < kTextViewHeight - 16.0) {
        
        textHeight = kTextViewHeight;
        
    } else {
        textHeight = size.size.height+16.0f;
    }
    
    return textHeight *iOSPP_H;
}
- (void)changeTextViewWithHeight:(CGFloat)height{
    CGRect titViewFrame = self.titleContainerView.frame;
    CGRect bgViewFrame = self.bgTextView.frame;
    CGRect textLableFrame = self.textCountLabel.frame;
    CGRect textViewFrame = self.titleTextInputView.frame;
    CGRect numberViewFrame = self.textNumberView.frame;
    titViewFrame.size.height = height - 16;
    bgViewFrame.size.height =  height;
    textLableFrame.size.height = height - 16;
    textViewFrame.size.height = height - 16;
    numberViewFrame.size.height = height - 16;
    self.bgTextView.frame = bgViewFrame;
    self.titleContainerView.frame = titViewFrame;
    self.textCountLabel.frame = textLableFrame;
    self.titleTextInputView.frame = textViewFrame;
    self.textNumberView.frame = numberViewFrame;
    [self changeInPutView:height];
}
- (void)changeInPutView:(CGFloat)height {
    CGRect currentFrame = self.frame;
    CGFloat index = height - kTextViewHeight*iOSPP_H;
    if (index > 0) {
        self.frame = CGRectMake(currentFrame.origin.x, self.boardRct.origin.y - (currentFrame.size.height -88 -44 + index), currentFrame.size.width, currentFrame.size.height);
    }
}
-(void) setTitle:(NSString *) title
{
    _titleTextInputView.text = title;
}

-(void) setFontSize:(CGFloat) size
{
    _fontSizeSlider.value = size;
}

-(void) setTextAlpha:(CGFloat) alpha
{
    _alphaSlider.value = alpha;
}

-(void) showWithAsset:(SXAssetModel *) asset inView:(UIView*) view
{
    _mAsset = asset.editModel.assetModel;
    _mUIAsset = asset;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTitle:[[asset.editModel.assetModel getSXTextLayoutView] getTitleContent]];
        [self setFontSize:([[asset.editModel.assetModel getSXTextLayoutView] getFontSize] - 10.0) / 70.0];
        [self setTextAlpha:1.0 - [asset.editModel.assetModel getSXTextLayoutView].alpha];
        [[asset.editModel.assetModel getSXTextLayoutView] saveState];
        self.frame = CGRectMake(0, view.bounds.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        [self layoutInputView];
        [view addSubview:self];
    });
}

-(void) dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(void)dealloc
{
    [self removeKeyboardNotification];
    [_titleTextInputView resignFirstResponder];
}

@end
