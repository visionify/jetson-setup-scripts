# jetson-setup-scripts
Installing different ML packages on top of Jetson Device. This should work for Jetson Nano, Xavier NX and Xavier AGX, from JetPack 4.3 onwards.

## What's included?
* Install and configure Azure IoTEdge
* Set Docker container runtime to NVIDIA.
* Install Tensorflow based on the Jetpack version
* Install ONNX Runtime for ONNX file inferencing.
* Install PyTorch framework.
* Install [jetson-inference](https://github.com/dusty-nv/jetson-inference) library.


## How to use?
* Follow instructions [here](https://developer.nvidia.com/jetpack-sdk-44-archive) to get SD card image & write to your SD card.
* Put the SD card into your device, follow on-screen and login.
* Open a terminal window & run the following script:

```
git clone https://github.com/visionify/jetson-setup-scripts.git
cd jetson-setup-scripts
sudo ./jetson-setup.sh
```
* The script is interactive & you can pick & choose what you want to install.

## Examples:
###  Install and Configure Azure IoTEdge
```
$ sudo ./jetson-setup.sh
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Jetson Additional ML Frameworks Installation Script.
 This will install following additional packages on top of JetPack
 ---> Tensorflow
 ---> ONNX Runtime
 ---> Azure IoTEdge
 Your device: L4T_VERSION: R32.4.4, JetPack: 4.4.1
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Do you wish to to install IoTEdge (Y/N)? y
Do you wish to to configure IoTEdge Connection String (Y/N)? y
Enter IoTEdge Connection String (Azure Portal -> IoTHub -> IoT Edge -> Your device -> Primary Connection String):
HostName=<hostname>;DeviceId=<deviceid>;SharedAccessKey=<shared-access-key>
Do you wish to to install Tensorflow (Y/N)? n
Do you wish to to install ONNX Runtime (Y/N)? n
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Installation Summary
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 JetPack Version           : L4T 32.4.4
 Install IoTEdge?          : 1
 Configure IoTEdge?        : 1
 IoTEdge Connection String : HostName=<hostname>;DeviceId=<deviceid>;SharedAccessKey=<shared-access-key>
 Install Tensorflow        : 0
 Install ONNXRuntime       : 0

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Do you wish to to continue? y
Continuing installation
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Install selected frameworks.
 Update apt-get
 Install utilities: curl, pip, dialog
 Install IoTEdge
 Set NVIDIA as the default container-runtime
 Configuring IoTEdge
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Done
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```

### Example: Install everything (Tensorflow, ONNXRuntime, AzureIoTEdge)
```
$ sudo ./jetson-setup.sh
[sudo] password for harsh:
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Jetson Additional ML Frameworks Installation Script.
 This will install following additional packages on top of JetPack
 ---> Tensorflow
 ---> ONNX Runtime
 ---> Azure IoTEdge
 Your device: L4T_VERSION: R32.4.4, JetPack: 4.4.1
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Do you wish to to install IoTEdge (Y/N)? y
Do you wish to to configure IoTEdge Connection String (Y/N)? y
Enter IoTEdge Connection String (Azure Portal -> IoTHub -> IoT Edge -> Your device -> Primary Connection String.):
HostName=<hostname>;DeviceId=<deviceid>;SharedAccessKey=<shared-access-key>
Do you wish to to install Tensorflow (Y/N)? y
Do you wish to to install ONNX Runtime (Y/N)? y
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Installation Summary
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 JetPack Version           : L4T 32.4.4
 Install IoTEdge?          : 1
 Configure IoTEdge?        : 1
 IoTEdge Connection String : HostName=<hostname>;DeviceId=<deviceid>;SharedAccessKey=<shared-access-key>
 Install Tensorflow        : 1
 Install ONNXRuntime       : 1

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Do you wish to to continue? y
Continuing installation
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Install selected frameworks.
 Update apt-get
 Install utilities: curl, pip, dialog
 Install IoTEdge
 Set NVIDIA as the default container-runtime
 Configuring IoTEdge
 Install Tensorflow. (Be patient.. this takes ~30 mins)
 Install ONNX Runtime.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Done
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```
## Troubleshooting/Feedback
* Please raise any bugs as issues on this Github repo, we will check it asap.
* You can email me at hmurari@visionify.ai
