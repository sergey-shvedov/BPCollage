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

///////////////////////////////////////////
///////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UIView *viewForCollage;

@property (strong,nonatomic) UIImageView *collageView;      //UIImageView with subviews of other UIImageViews for each UIImage
@property (strong,nonatomic) UIImage *collage;              //Ready UIImage of our Collage
@property (strong,nonatomic) UIImageView *oneImageView;     //UIImageView with only one (UIImage* collage)
@property (strong,nonatomic) SchemeRules *rules;            //frames for all images in new Collage
@end

///////////////////////////////////////////
///////////////////////////////////////////

@implementation CollageVC

///////////////////////////////////////////
#pragma mark - Getters AND Setters
///////////////////////////////////////////

-(void)setImages:(NSSet *)images
{
    _images=images;
    if ([images count]) {
        SchemeRules *newRule=[[SchemeRules alloc]initWithCountOfImages:[images count] andForWidth:COLLAGEWIDTH];   //get array of frames for images
        self.rules=newRule;
    }
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

-(UIImageView *)collageView
{
    if (!_collageView) {
        _collageView=[self createImageView];
    }
    return _collageView;
}

////////////////////////////////////////////////////////////////// Combine all images using rules and create result UIImageView with Collage
-(UIImageView *) createImageView
{
    UIImageView *newImageView=[[UIImageView alloc]init];
    if (self.rules) {
        
        [newImageView setFrame:[self.rules.collageFrame CGRectValue]];                   //get collage frame from rules
        [newImageView setBackgroundColor:[UIColor yellowColor]];
        
        int i=0;
        for (UIImage *image in self.images)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
            [imageView setFrame:[[self.rules.imageFrames objectAtIndex:i] CGRectValue]]; //get frame from rules
            imageView.contentMode=UIViewContentModeScaleAspectFill;
            [imageView setClipsToBounds:YES];
            [newImageView addSubview:imageView];
            i++;
        }
    }
    
    return newImageView;
}


///////////////////////////////////////////
#pragma mark - IBAction & Creating MailView
///////////////////////////////////////////

////////////////////////////////////////////////////////////////// Create MFMailComposeViewController and new email with our Collage UIImage
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
    
    [self presentViewController:mc animated:YES completion:NULL];
}


///////////////////////////////////////////
#pragma mark - Mail result Handler
///////////////////////////////////////////


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

///////////////////////////////////////////
#pragma mark - Convertation VIEW -> IMAGE
///////////////////////////////////////////

-(UIImage *) changeImageViewToImage : (UIImageView *) view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


///////////////////////////////////////////
#pragma mark - View Methods and UpadteUI
///////////////////////////////////////////

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
}

-(void) setupView
{
    self.viewForCollage.contentMode=UIViewContentModeScaleAspectFit;
    [self.viewForCollage addSubview:self.oneImageView];                      //Show the Collage
    [self updateUI];
}

-(void) updateUI
{
    [self.oneImageView setFrame:self.viewForCollage.bounds];                 //Change frame in superview
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


///////////////////////////////////////////
///////////////////////////////////////////
@end
///////////////////////////////////////////
///////////////////////////////////////////