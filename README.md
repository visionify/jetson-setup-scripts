# jetson-setup-scripts
Installing different ML packages on top of Jetson. This should work for Jetson Nano, Xavier NX and Xavier AGX.

## What's included?
* Install and configure Azure IoTEdge
* Set Docker container runtime to NVIDIA.
* Install Tensorflow, TensorRT, jetson-inference etc.

## JetPack 4.4 (L4T R32.4.3)
* Follow instructions [here](https://developer.nvidia.com/jetpack-sdk-44-archive) to get SD card image & write to your SD card.
* Put the SD card into your device, follow on-screen instructions to accept license, create a user and login.
* Open a terminal window & run the following script:

```
git clone https://github.com/visionify/jetson-setup-scripts.git
cd jetson-setup-scripts
sudo ./jetpack.4.4.sh
```
* This process will take around 30 minutes to install everything.