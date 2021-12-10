#!/usr/bin/env bash
# This script installs additional packages on top of vanilla JetPack.
#

echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " Jetson Additional ML Frameworks Installation Script."
echo " This will install following additional packages on top of JetPack"
echo " ---> Tensorflow"
echo " ---> ONNX Runtime"
echo " ---> Azure IoTEdge"

source l4t-jetpack-version.sh > /dev/null
echo " Your device: L4T_VERSION: R$L4T_VERSION, JetPack: $JP_VERSION"
echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo

if [ `id -u` -ne 0 ] ; then echo " Please run script as root."; echo; exit 1 ; fi

# All apt-get installs are using noninteractive shell
export DEBIAN_FRONTEND=noninteractive

INSTALL_IOTEDGE=0
while true; do
    read -p "Do you wish to to install IoTEdge (Y/N)? " yn
    case $yn in
        [Yy]* ) INSTALL_IOTEDGE=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

CONFIGURE_IOTEDGE=0
while true; do
    read -p "Do you wish to to configure IoTEdge Connection String (Y/N)? " yn
    case $yn in
        [Yy]* ) CONFIGURE_IOTEDGE=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $CONFIGURE_IOTEDGE = 1 ]; then
    read -rep $'Enter IoTEdge Connection String (Azure Portal -> IoTHub -> IoT Edge -> Your device -> Primary Connection String.): \n' conn_str
    if [ -z $conn_str ]; then
        echo "No connection string provided, skipping IoTEdge configuration."; CONFIGURE_IOTEDGE=0;
    fi
fi

INSTALL_TENSORFLOW=0
while true; do
    read -p "Do you wish to to install Tensorflow (Y/N)? " yn
    case $yn in
        [Yy]* ) INSTALL_TENSORFLOW=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

INSTALL_ONNX_RUNTIME=0
while true; do
    read -p "Do you wish to to install ONNX Runtime (Y/N)? " yn
    case $yn in
        [Yy]* ) INSTALL_ONNX_RUNTIME=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $INSTALL_TENSORFLOW != 0 ]; then
    if [ $JP_VERSION = "4.6" ]; then
        TENSORFLOW_URL="https://developer.download.nvidia.com/compute/redist/jp/v46/"
    elif [ $JP_VERSION = "4.5" ]; then
        TENSORFLOW_URL="https://developer.download.nvidia.com/compute/redist/jp/v45/"
    elif [ $JP_VERSION = "4.4.1" ]; then
        TENSORFLOW_URL="https://developer.download.nvidia.com/compute/redist/jp/v44/"
    elif [ $JP_VERSION = "4.4" ]; then
        TENSORFLOW_URL="https://developer.download.nvidia.com/compute/redist/jp/v44/"
    elif [ $JP_VERSION = "4.4.DP" ]; then
        TENSORFLOW_URL="https://developer.download.nvidia.com/compute/redist/jp/v44/"
    elif [ $JP_VERSION = "4.3" ]; then
        TENSORFLOW_URL="https://developer.download.nvidia.com/compute/redist/jp/v43/"
    else
        echo "Unsupported JetPack Version: $JP_VERSION for Tensorflow Installation."
        exit 1
    fi
fi

echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " Installation Summary"
echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " JetPack Version           : L4T $L4T_VERSION"
echo " Install IoTEdge?          : $INSTALL_IOTEDGE"
echo " Configure IoTEdge?        : $CONFIGURE_IOTEDGE"
echo " IoTEdge Connection String : $conn_str"
echo " Install Tensorflow        : $INSTALL_TENSORFLOW"
echo " Install ONNXRuntime       : $INSTALL_ONNX_RUNTIME"
echo
echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

while true; do
    read -p "Do you wish to to continue? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "[$yn] Quitting."; exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $INSTALL_IOTEDGE = 0 ] && [ $CONFIGURE_IOTEDGE = 0 ] && [ $INSTALL_TENSORFLOW = 0 ] && [ $INSTALL_ONNX_RUNTIME = 0 ]; then
    echo "No packages selected. Skipping install."
    exit
else
    echo "Continuing installation";
fi

echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " Install selected frameworks."

if [ $INSTALL_IOTEDGE != 0 ]; then
    curl -s https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
    cp ./microsoft-prod.list /etc/apt/sources.list.d/
    curl -s https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
fi

echo " Update apt-get"
apt-get -y update -qq > /dev/null

echo " Install utilities: curl, pip, dialog"
apt-get -y install curl python3-pip dialog -qq > /dev/null

if [ $INSTALL_IOTEDGE != 0 ]; then
    echo " Install IoTEdge"
    apt-get -y install aziot-edge -qq > /dev/null
    echo " Set NVIDIA as the default container-runtime"
    cp -f docker_daemon.json /etc/docker/daemon.json
fi

if [ $CONFIGURE_IOTEDGE != 0 ]; then
    echo " Configuring IoTEdge"
    sudo iotedge config mp --connection-string $conn_str
    sudo iotedge config apply -c '/etc/aziot/config.toml'
fi

if [ $INSTALL_TENSORFLOW != 0 ]; then
    echo " Install Tensorflow. (Be patient.. this takes ~30 mins)"
    apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran -qq > /dev/null
    pip3 install -U pip testresources setuptools==49.6.0 -q > /dev/null
    pip3 install -U --no-deps numpy==1.19.4 future==0.18.2 mock==3.0.5 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.4.0 protobuf pybind11 cython pkgconfig -q > /dev/null
    H5PY_SETUP_REQUIRES=0 pip3 install -U --no-build-isolation h5py==3.1.0 -q > /dev/null
    pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow
fi

# echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
# echo " Install NVCC and PYCUDA."
# grep -q /usr/local/cuda/bin ~/.bashrc || printf "\nexport PATH=\${PATH}:/usr/local/cuda/bin" >> ~/.bashrc
# grep -q /usr/local/cuda/lib64 ~/.bashrc || printf "\nexport LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:/usr/local/cuda/lib64\n" >> ~/.bashrc

# export PATH=${PATH}:/usr/local/cuda/bin
# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64

# echo " Checking NVCC Version"
# nvcc --version

# echo " Installing protobuf, pycuda, keras2onnx, tf2onnx, scikit-image"
# apt-get -y install libprotobuf-dev protobuf-compiler --qq
# pip3 install keras2onnx tf2onnx==1.8.2 pillow pycuda scikit-image -q

if [ $INSTALL_ONNX_RUNTIME != 0 ]; then
    echo " Install OnnxRuntime (Details: https://elinux.org/Jetson_Zoo#ONNX_Runtime)"
    wget -nc -q https://nvidia.box.com/shared/static/jy7nqva7l88mq9i8bw3g3sklzf4kccn2.whl -O onnxruntime_gpu-1.10.0-cp36-cp36m-linux_aarch64.whl
    pip3 install -U onnxruntime_gpu-1.10.0-cp36-cp36m-linux_aarch64.whl -q > /dev/null
fi

echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " Done"
echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
