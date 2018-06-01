# unsupervised_patch_extraction
Unsupervised Algorithm to extract foreground and background patches from a video

### Introduction
  - The code is for the unsupervised extraction of foreground and background patches from a video.
  - This patches after the extraction are provided to the convolutional neural network for the feature learning process.

### Installation Steps
  - The frames of the videos used in this paper can be downloaded from [here](http://people.eecs.berkeley.edu/~pathak/unsupervised_video/) 
  - The frames has to be kept in the folder under data/frames_dump folder.
  - The paper uses caffe version ResNet-50 model which can be downloaded from [here](https://github.com/KaimingHe/deep-residual-networks)
  - It requires both the deploy.prototxt file and .caffemodel file to be downloaded. These files are kept in external/models folder.
  - The mean file of the imagenet also needs to be kept in the external/models folder.

### Other External Dependencies
  - [EdgeBoxes](https://github.com/pdollar/edges)
  - [MatConvNet](http://www.vlfeat.org/matconvnet/)
  - OpticalFlow from [here](https://people.csail.mit.edu/celiu/OpticalFlow/)
  - Piotr Matlab toolbox which can be downloaded from [here](https://pdollar.github.io/toolbox/)
  - [VLFeat](http://www.vlfeat.org/)
 
 **Note:** All the dependencies are present in the /external folder, however they are required to be recompiled.
