//
//  Image.m
//  Music Player
//
//  Created by Vu Huy on 30/06/2022.
//

#import <Foundation/Foundation.h>
#import "Image.h"

struct pixel {
    unsigned char r, g, b, a;
};

@implementation ImageUtils

+ (UIImage * _Nullable)resize:(UIImage * _Nonnull)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIColor * _Nullable)getDominantColor:(UIImage *)image {
    NSUInteger red = 0;
    NSUInteger green = 0;
    NSUInteger blue = 0;


    // Allocate a buffer big enough to hold all the pixels

    struct pixel* pixels = (struct pixel*) calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
    if (pixels != nil)
    {

        CGContextRef context = CGBitmapContextCreate(
                                                 (void*) pixels,
                                                 image.size.width,
                                                 image.size.height,
                                                 8,
                                                 image.size.width * 4,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 kCGImageAlphaPremultipliedLast
                                                 );

        if (context != NULL)
        {
            // Draw the image in the bitmap

            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);

            // Now that we have the image drawn in our own buffer, we can loop over the pixels to
            // process it. This simple case simply counts all pixels that have a pure red component.

            // There are probably more efficient and interesting ways to do this. But the important
            // part is that the pixels buffer can be read directly.

            NSUInteger numberOfPixels = image.size.width * image.size.height;
            for (int i=0; i<numberOfPixels; i++) {
                red += pixels[i].r;
                green += pixels[i].g;
                blue += pixels[i].b;
            }


            red /= numberOfPixels;
            green /= numberOfPixels;
            blue/= numberOfPixels;


            CGContextRelease(context);
        }

        free(pixels);
    }
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

@end
