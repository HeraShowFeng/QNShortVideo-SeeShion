//
//  SXTextLayoutView.h
//  ShiPinDemo
//
//  Created by Zhiqiang Li on 07/11/2017.
//  Copyright © 2017 杨思宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXTextLayoutView : UIView

@property (nonatomic) BOOL mHasDetailLabel;

/**
 set title string

 @param content title string to draw
 */
-(void) setTitleContent:(NSString *) content;

/**
 set the content string

 @param content content string to draw
 */
-(void) setDetailContent:(NSString *) content;

/**
 set the font size of the title

 @param size font size, default is 30
 */
-(void) setFontSize:(CGFloat) size;

/**
 set the font of the title

 @param font title font, if nil, will be set to system bold font
 */
-(void) setFont:(UIFont *) font;

/**
 set the font of the content

 @param font content font, of not set, will be set the same font as the title
 */
-(void) setContentFont:(UIFont *) font;

/**
 set the font size of the content font, if not set, will be set to 0.6*titleFontSize

 @param fontSize content font size
 */
-(void) setContentFontSize:(CGFloat) fontSize;

/**
 set the over all alpha for the content

 @param alpha content alpha
 */
-(void) setTextAlpha:(CGFloat) alpha;

/**
 set the fill color of the content

 @param color fill color, if nil, set to black
 */
-(void) setColor:(UIColor *) color;

/**
 set stroke color

 @param color stroke color, set to nil to disable stroke
 */
-(void) setStrokeColor:(UIColor *) color;

/**
 set stroke width

 @param width stroke with, set to 0 to disable stroke
 */
-(void) setStrokeWidth:(CGFloat) width;

/**
 set text alignment

 @param alignment 0-->left alignment   1-->right alignment   2-->center alignment
 */
-(void) setAlignment:(int) alignment;

/**
 get the content of the title label

 @return title content
 */
-(NSString *) getTitleContent;

/**
 get the content of the detail label
 
 @return detail content
 */
-(NSString *) getDetailContent;

/**
 get current font size

 @return font size
 */
-(CGFloat) getFontSize;

-(CGFloat) getTextAlpha;

/**
 snap the view and save the content as a jpg format image at specified output path

 @param outputPath output path, with file name, should end with ".jpg" extension
 @return the snaped UIImage
 */
-(UIImage *) snapViewToPath:(NSString *) outputPath;

/**
 snap the view and return the result as a UIImage

 @return the snaped UIImage
 */
-(UIImage *) snapView;

/**
 set a fixed size for the view

 @param size fixed size, if is CGSizeZero, then disable the fixed size
 */
-(void) setFixedSize:(CGSize) size;

/**
 update the layout
 */
-(void) update;

/**
 update the size of the view, and layout title and content

 @param size the new view size
 */
-(void) updateLayout:(CGSize) size;

/**
 save the current style
 */
-(void) saveState;

/**
 restore saved style
 */
-(void) restoreState;

@end
