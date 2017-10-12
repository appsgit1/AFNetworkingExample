//
//  ViewController.h
//  AfNetowrkExample
//
//  Created by Zumry Gapstars on 2/3/17.
//  Copyright © 2017 Appsgit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileUtil.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)uploadimage:(id)sender;
- (IBAction)capturePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@property UIImage* image;

@end

