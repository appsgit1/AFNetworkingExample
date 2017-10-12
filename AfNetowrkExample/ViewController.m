#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

//Server url for the file upload handling.
static NSString *ServerPath = @"http://appsgit.com/appsgit-service/fileupload.php";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma Upload Capture Photo Action method implementation.

- (IBAction)capturePhoto:(id)sender {
    
    /*Check if the Device supports Camera feature. Camera feature is not available in Simulators. You can only select image in the simulator.
     */
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"File Exist" message:@" No Camera found." preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OKK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        
        [controller addAction:action];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:true completion:nil];
}


#pragma Upload Select Photo Action method implementation.

- (IBAction)selectPhoto:(id)sender {
    
    //Open Gallery to select an image.
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma Upload image button Action method implementation.

- (IBAction)uploadimage:(id)sender {
    
    //You must select or capture image inorder to upload it to the server.
    if (self.image == nil) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"File Exist" message:@"Please select an image or Capture image using camera." preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OKK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            //anything to do...
            NSLog(@"ok pressed...");
        }];
        
        [controller addAction:action];
        
        [self presentViewController:controller animated:YES completion:nil];
        
        return;
    }
    
    if (self.image != nil) {
        
        //Save the image to device temp location and get the path.
        NSString *path = [FileUtil saveImageTODocumentAndGetPath:self.image];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:path];
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        manager.operationQueue.maxConcurrentOperationCount = 2; //set to max downloads at once.
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:ServerPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileURL:fileURL name:@"file" fileName:@"file.jpg" mimeType:@"image/jpeg" error:nil];
            
            NSData *fileNameconvertedToUTF8data = [@"my_file_name.jpg" dataUsingEncoding:NSUTF8StringEncoding];
            
            [formData appendPartWithFormData:fileNameconvertedToUTF8data name:@"filename"];
            
        } error:nil];
        
        [request setTimeoutInterval:10000];
        
        NSURLSessionUploadTask *uploadTask;
        
        
        uploadTask = [manager
                      uploadTaskWithStreamedRequest:request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              //Update the progress view
                              NSLog(@"show progress here...");
                          });
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Throw if there is any Error: %@", error);
                          } else {
                              NSString *responseMessage = [NSString stringWithUTF8String:[responseObject bytes]];
                              
                              UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"File Upload" message:responseMessage preferredStyle: UIAlertControllerStyleAlert];
                              
                              UIAlertAction *action = [UIAlertAction actionWithTitle:@"OKK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                                  //anything to do...
                                  NSLog(@"ok button pressed...");
                              }];
                              
                              [controller addAction:action];
                              
                              [self presentViewController:controller animated:YES completion:nil];
                          }
                      }];
        
        [uploadTask resume];
    }
}


#pragma Image Picker Delegate methods.

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    //compress the image before upload. bigger size images takes tiime to upload.
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 0.5);
    
    self.image = [UIImage imageWithData:imageData];
    
    self.imageView.image = [UIImage imageWithData:imageData];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
