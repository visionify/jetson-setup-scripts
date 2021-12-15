#!/usr/bin/env bash
# This script installs additional packages on top of vanilla JetPack.
#

echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " Jetson Additional ML Frameworks Installation Script."
echo " This will install following additional packages on top of JetPack"
echo " ---> Tensorflow"
echo " ---> ONNX Runtime"
echo " ---> PyTorch"
echo " ---> Azure IoTEdge"
echo " ---> Scikit-Learn (not working)"
echo " ---> Jetson Inference library"
echo " ---> Bugfix for nvidia-runtime-container"

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
    read -p "Do you wish to to install Tensorflow (Y/N)? (Takes 30 mins): " yn
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

INSTALL_PYTORCH=0
while true; do
    read -p "Do you wish to to install PyTorch (Y/N)? " yn
    case $yn in
        [Yy]* ) INSTALL_PYTORCH=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

INSTALL_SCIKIT_LEARN=0
while true; do
    read -p "Do you wish to to install Scikit-Learn (Y/N)? (Takes 30 mins) (Not fully working): " yn
    case $yn in
        [Yy]* ) INSTALL_SCIKIT_LEARN=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

INSTALL_JETSON_INFERENCE=0
while true; do
    read -p "Do you wish to to install Jetson Inference (Hello AI World) (Y/N)? " yn
    case $yn in
        [Yy]* ) INSTALL_JETSON_INFERENCE=1; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

INSTALL_NVIDIA_DOCKER=0
while true; do
    read -p "nvidia-container-runtime has some issues with latest version. Do you wish to install fix for this? (Y/N)? " yn
    case $yn in
        [Yy]* ) INSTALL_NVIDIA_DOCKER=1; break;;
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
echo " JetPack Version                      : L4T $L4T_VERSION"
echo " Install IoTEdge?                     : $INSTALL_IOTEDGE"
echo " Configure IoTEdge?                   : $CONFIGURE_IOTEDGE"
echo " IoTEdge Connection String            : $conn_str"
echo " Install Tensorflow (takes 30 mins)   : $INSTALL_TENSORFLOW"
echo " Install ONNXRuntime                  : $INSTALL_ONNX_RUNTIME"
echo " Install PyTorch                      : $INSTALL_PYTORCH"
echo " Install scikit-learn (takes 30 mins) : $INSTALL_SCIKIT_LEARN"
echo " Install jetson-inference             : $INSTALL_JETSON_INFERENCE"
echo " Fix nvidia-docker container runtime  : $INSTALL_NVIDIA_DOCKER"
echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "

while true; do
    read -p "Do you wish to to continue? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "[$yn] Quitting."; exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ $INSTALL_IOTEDGE = 0 ] && [ $CONFIGURE_IOTEDGE = 0 ] && [ $INSTALL_TENSORFLOW = 0 ] && [ $INSTALL_ONNX_RUNTIME = 0 ] && [ $INSTALL_PYTORCH = 0 ] && [ $INSTALL_SCIKIT_LEARN = 0 ] && [ $INSTALL_JETSON_INFERENCE = 0 ] && [ $INSTALL_NVIDIA_DOCKER = 0 ]; then
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

echo " Fix numpy coredump error"
grep -q OPENBLAS_CORETYPE ~/.bashrc || printf "\nexport OPENBLAS_CORETYPE=ARMV8\n" >> ~/.bashrc

if [ $INSTALL_IOTEDGE != 0 ]; then
    echo " Install IoTEdge"
    apt-get -y install aziot-edge -qq > /dev/null
    echo " Set NVIDIA as the default container-runtime"
    cp -f docker_daemon.json /etc/docker/daemon.json
fi

if [ $CONFIGURE_IOTEDGE != 0 ]; then
    echo " Configuring IoTEdge"
    iotedge config mp --connection-string $conn_str --force
    iotedge config apply -c '/etc/aziot/config.toml'
fi

if [ $INSTALL_TENSORFLOW != 0 ]; then
    echo " Install Tensorflow. (Be patient.. this takes ~30 mins)"
    echo " .... Install dependencies: hdf5, zlib, zip, jpeg, liblapack, libblas, gfortran"
    apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran -qq > /dev/null
    echo " .... Install dependencies: pip, testresources, setuptools"
    pip3 install -U pip testresources setuptools==49.6.0 -q > /dev/null
    echo " .... Install dependencies: numpy 1.19.4, future, mock, keras dependencies, gast, protobuf, cython, pkgconfig"
    pip3 install -U --no-deps numpy==1.19.4 future==0.18.2 mock==3.0.5 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.4.0 protobuf pybind11 cython pkgconfig -q > /dev/null
    echo " .... Install dependencies: h5py"
    H5PY_SETUP_REQUIRES=0 pip3 install -U --no-build-isolation h5py==3.1.0 -q > /dev/null
    echo " .... Install Tensorflow"
    pip3 install --pre --extra-index-url $TENSORFLOW_URL tensorflow -q > /dev/null
    echo " .... Install keras"
    pip3 install -U keras -q > /dev/null
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
# apt-get -y install libprotobuf-dev protobuf-compiler -qq
# pip3 install keras2onnx tf2onnx==1.8.2 pillow pycuda scikit-image -q

if [ $INSTALL_ONNX_RUNTIME != 0 ]; then
    echo " Install OnnxRuntime (Details: https://elinux.org/Jetson_Zoo#ONNX_Runtime)"
    wget -nc -q https://nvidia.box.com/shared/static/jy7nqva7l88mq9i8bw3g3sklzf4kccn2.whl -O onnxruntime_gpu-1.10.0-cp36-cp36m-linux_aarch64.whl
    pip3 install -U onnxruntime_gpu-1.10.0-cp36-cp36m-linux_aarch64.whl -q > /dev/null
fi

if [ $INSTALL_PYTORCH != 0 ]; then
    echo " Install PyTorch (Details: https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-10-now-available/72048)"
    wget -nc -q https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
    apt-get -y install libopenblas-base libopenmpi-dev -qq > /dev/null
    pip3 install -U Cython -q > /dev/null
    pip3 install -U numpy torch-1.8.0-cp36-cp36m-linux_aarch64.whl -q > /dev/null
    echo " Install TorchVision (Details: https://qengineering.eu/install-pytorch-on-jetson-nano.html"
    pip3 install -U gdown -q > /dev/null
    gdown -q https://drive.google.com/uc?id=1BdvXkwUGGTTamM17Io4kkjIT6zgvf4BJ
    pip3 install -U torchvision-0.9.0a0+01dfa8e-cp36-cp36m-linux_aarch64.whl -q > /dev/null
    rm torchvision-0.9.0a0+01dfa8e-cp36-cp36m-linux_aarch64.whl
fi

function changedir() {
    cd $1
}

if [ $INSTALL_SCIKIT_LEARN != 0 ]; then
    echo " Install scikit-learn (Takes 30 mins) (Not working fully.) (Details: https://forums.developer.nvidia.com/t/how-to-install-numpy-scikit-image-scikit-learn-on-jetson-tx2/83819/7)"
    apt-get -y install liblapack-dev gfortran -qq > /dev/null
    wget -nc -q https://github.com/scipy/scipy/releases/download/v1.3.3/scipy-1.3.3.tar.gz
    tar -xzvf scipy-1.3.3.tar.gz scipy-1.3.3
    changedir scipy-1.3.3/
    python3 setup.py install --user
    changedir ..

    wget https://download.osgeo.org/libtiff/tiff-4.1.0.tar.gz
    tar -xzvf tiff-4.1.0.tar.gz
    changedir tiff-4.1.0/
    source configure
    make
    make install
    changedir ..

    apt-get -y install python3-sklearn -qq
    apt-get -y install libaec-dev libblosc-dev libffi-dev libbrotli-dev libboost-all-dev libbz2-dev -qq
    apt-get -y install libgif-dev libopenjp2-7-dev liblcms2-dev libjpeg-dev libjxr-dev liblz4-dev liblzma-dev libpng-dev libsnappy-dev libwebp-dev libzopfli-dev libzstd-dev -qq
    pip3 -U install imagecodecs
    pip3 -U install scikit-image
fi


if [ $INSTALL_JETSON_INFERENCE != 0 ]; then

    if [ -d "jetson-inference" ]; then
        echo "jetson-inference/ directory already exists. Skipping install."

    else
        echo " Installing Jetson Inference module"

        echo " ... Installing dependency: python3-numpy"
        apt-get -y install python3-numpy python-numpy -qq > /dev/null
        echo " ... Cloning jetson-inference"
        git clone --recursive https://github.com/dusty-nv/jetson-inference > /dev/null
        echo " ... Building jetson-inference"
        cd jetson-inference
        mkdir build
        cd build
        cmake ../   > /dev/null
        make -j4    > /dev/null
        echo " ... Installing jetson-inference"
        make install > /dev/null
        ldconfig
    fi
fi

if [ $INSTALL_NVIDIA_DOCKER != 0 ]; then

    echo " Installing Fixes for nvidia-container-runtime."
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |  tee /etc/apt/sources.list.d/nvidia-docker.list
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    apt-get -y update -qq
    echo " ... Installing nvidia-container-runtime 1.6.rc.2.1 (from Nov 15, 2021) which has the fix"
    apt-get install -y nvidia-docker2 -qq
    apt-get install -y nvidia-container-toolkit=1.6.0~rc.2-1 -qq
    echo " ... Restarting docker service"
    systemctl restart docker
fi





echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
echo " Done"
echo " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
