//
//  CollageVC.m
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "CollageVC.h"
#import <MessageUI/MessageUI.h>
#import "SchemeRules.h"
#import "Const.h"

@interface CollageVC ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewForCollage;
@property (strong,nonatomic) UIImageView *collageView;
@property (strong,nonatomic) UIImage *collage;
@property (strong,nonatomic) UIImageView *oneImageView;
@property (strong,nonatomic) SchemeRules *rules;
@end

@implementation CollageVC

-(void)setImages:(NSSet *)images
{
    _images=images;
    if ([images count]) {
        SchemeRules *newRule=[[SchemeRules alloc]initWithCountOfImages:[images count] andForWidth:COLLAGEWIDTH];
        self.rules=newRule;
    }
}


-(UIImageView *)collageView
{
    if (!_collageView) {
        _collageView=[self createImageView];
    }
    return _collageView;
}
-(UIImage *)collage
{
    if (!_collage) {
        _collage=[self changeImageViewToImage:self.collageView];
    }
    return _collage;
}
-(UIImageView *)oneImageView
{
    if (!_oneImageView) {
        UIImageView *iv=[[UIImageView alloc] initWithImage: self.collage];
        iv.contentMode=UIViewContentModeScaleAspectFit;
        _oneImageView= iv;
    }
    return _oneImageView;
}
- (IBAction)sendMail:(id)sender
{
    NSString *emailTitle = @"Коллаж";
    // Email Content
    NSString *messageBody = @"Новый коллаж!";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"swedoff@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    NSData *data = UIImageJPEGRepresentation(self.collage,1);
    [mc addAttachmentData:data  mimeType:@"image/jpeg" fileName:@"Collage.jpg"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(UIImageView *) createImageView
{
    UIImageView *newImageView=[[UIImageView alloc]init];
    if (self.rules) {
        
        
        [newImageView setFrame:[self.rules.collageFrame CGRectValue]];
        [newImageView setBackgroundColor:[UIColor yellowColor]];
        
        int i=0;
        for (UIImage *image in self.images)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
            [imageView setFrame:[[self.rules.imageFrames objectAtIndex:i] CGRectValue]];
            imageView.contentMode=UIViewContentModeScaleAspectFill;
            [imageView setClipsToBounds:YES];
            [newImageView addSubview:imageView];
            i++;
        }
    }
    
    
    return newImageView;
}

-(UIImage *) changeImageViewToImage : (UIImageView *) view
{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
    
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}

-(void) setupView
{
    self.viewForCollage.contentMode=UIViewContentModeScaleAspectFit;
    
    [self.viewForCollage addSubview:self.oneImageView];
    
    [self updateUI];
}
-(void) updateUI
{
    [self.oneImageView setFrame:self.viewForCollage.bounds];
    
}

-(void)viewDidLayoutSubviews
{
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
