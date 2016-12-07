//
//  NYSegmentLabel.m
//  NYSegmentLabel
//
//  Copyright (c) 2015 Peter Gammelgaard. All rights reserved.
//
//  https://github.com/nealyoung/NYSegmentedControl
//

#import "NYSegmentLabel.h"

@implementation NYSegmentLabel {
    CGSize _textSize;// FIXME: Suta
}

- (void)setMaskFrame:(CGRect)maskFrame {
    _maskFrame = maskFrame;
    [self setNeedsDisplay];
}

- (void)setMaskCornerRadius:(CGFloat)maskCornerRadius {
    _maskCornerRadius = maskCornerRadius;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw text normally
    [super drawTextInRect:rect];
    
    if (self.alternativeTextColor) {
        CGImageRef mask = NULL;
        
        // Create a mask from the text
        mask = CGBitmapContextCreateImage(context);
        
        CGContextSaveGState(context);
        
        // FIXME: Suta
        CGContextTranslateCTM(context, 0, self.frame.size.height + [self textDeltaY]);
        
        CGContextScaleCTM(context, 1.0, (CGFloat) -1.0);
        
        // Clip the current context to our mask
        CGContextClipToMask(context, rect, mask);
        
        // Set fill color
        CGContextSetFillColorWithColor(context, [self.alternativeTextColor CGColor]);
        
        // Path from mask
        CGPathRef path;
        
        if (CGRectIsEmpty(self.maskFrame)) {
            path = CGPathCreateMutable();
        } else {
            UIBezierPath *roundRectBezierPath = [UIBezierPath bezierPathWithRoundedRect:self.maskFrame
                                                                           cornerRadius:self.maskCornerRadius];
            path = CGPathCreateCopy([roundRectBezierPath CGPath]);
        }
        
        CGContextAddPath(context, path);
        
        // Fill the path
        CGContextFillPath(context);
        CFRelease(path);
        
        // Clean up
        CGContextRestoreGState(context);
        CGImageRelease(mask);
    }
}

- (UIColor *)alternativeTextColor {
    if (!_alternativeTextColor) {
        _alternativeTextColor = self.textColor;
    }
    
    return _alternativeTextColor;
}

#pragma mark - getter & setter

// FIXME: Suta
- (void)setText:(NSString *)text {
    [super setText:text];
    _textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
}

// FIXME: Suta
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
}

// FIXME: Suta
- (CGFloat)textDeltaY {
    if ([self textOnlyEnglish]) {
        return 0;
    }
    if (![self textSystemFont]) {
        return 0;
    }
    if (![self textBoldFont]) {
        return _textSize.height / 9;
    } else {
        return _textSize.height / 22;
    }
}

// FIXME: Suta
- (BOOL)textOnlyEnglish {
    NSString *myRegex = @"[A-Z0-9a-z_]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    NSString *string = self.text;
    return [myTest evaluateWithObject:string];
}

// FIXME: Suta
- (BOOL)textSystemFont {
    BOOL systemFont = [self.font isEqual:[UIFont systemFontOfSize:self.font.pointSize]];
    BOOL boldSystemFont = [self.font isEqual:[UIFont boldSystemFontOfSize:self.font.pointSize]];
    return systemFont || boldSystemFont;
}

// FIXME: Suta
- (BOOL)textBoldFont {
    UIFontDescriptor *fontDescriptor = self.font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    return (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
}

@end
