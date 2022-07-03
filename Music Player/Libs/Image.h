//
//  Image.h
//  Music Player
//
//  Created by Vu Huy on 30/06/2022.
//

#ifndef Image_h
#define Image_h

#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

+ (UIImage * _Nullable)resize:(UIImage * _Nonnull)image scaledToSize:(CGSize)newSize;
+ (UIColor * _Nullable)getDominantColor:(UIImage * _Nonnull)image;

@end

#endif /* Image_h */
