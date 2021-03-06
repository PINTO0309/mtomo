FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ARG OSVER=ubuntu1804
ARG TENSORFLOWVER=2.5.0rc1
ARG TENSORRTVER=cuda11.1-trt7.2.3.4-ga-20210226
ARG OPENVINOVER=2021.3.394
ARG OPENVINOROOTDIR=/opt/intel/openvino_2021
# PyTorch==1.8.1+cu112
# TorchVision==0.9.1+cu112
# TorchAudio==0.8.1
ARG TORCHVER=1.8.0a0+56b43f4
ARG TORCHVISIONVER=0.9.0a0+8fb5838
ARG TORCHAUDIOVER=0.8.0a0+e4e171a
ARG wkdir=/home/user

# dash -> bash
RUN echo "dash dash/sh boolean false" | debconf-set-selections \
    && dpkg-reconfigure -p low dash
COPY bashrc ${wkdir}/.bashrc
WORKDIR ${wkdir}

# Install dependencies - apt command
RUN apt-get update && apt-get install -y \
        automake autoconf libpng-dev nano python3-pip \
        curl zip unzip libtool swig zlib1g-dev pkg-config \
        python3-mock libpython3-dev libpython3-all-dev \
        g++ gcc cmake make pciutils cpio gosu wget \
        libgtk-3-dev libxtst-dev sudo apt-transport-https \
        build-essential gnupg git xz-utils vim \
        libmfx1 libmfx-tools libva-drm2 libva-x11-2 vainfo \
        libva-wayland2 libva-glx2 intel-media-va-driver \
        libva-dev libmfx-dev libdrm-dev xorg xorg-dev \
        openbox libx11-dev libgl1-mesa-glx libgl1-mesa-dev \
        libtbb2 libtbb-dev clinfo since apt-utils \
        libopenmpi-dev libopenmpi3 libopenblas-dev libcusolver10 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# nano settings
RUN sed -i 's/# set linenumbers/set linenumbers/g' /etc/nanorc

# Install dependencies- pip command
RUN pip3 install --upgrade pip \
    && pip install --upgrade tensorflowjs \
    && pip install --upgrade coremltools \
    && pip install --upgrade onnx \
    && pip install --upgrade tf2onnx \
    && pip install --upgrade tensorflow-datasets \
    && pip install --upgrade openvino2tensorflow \
    && pip install --upgrade tflite2tensorflow \
    && pip install --upgrade onnxruntime \
    && pip install --upgrade onnx-simplifier \
    && pip install --upgrade gdown \
    && pip install --upgrade PyYAML \
    && ldconfig \
    && pip cache purge \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install custom tflite_runtime, flatc, edgetpu-compiler
RUN gdown --id 172QlW8MGzDMDgMkDOGFix54oFZ6FFIe- \
    && chmod +x tflite_runtime-${TENSORFLOWVER}-cp38-none-linux_x86_64.whl \
    && pip install tflite_runtime-${TENSORFLOWVER}-cp38-none-linux_x86_64.whl \
    && rm tflite_runtime-${TENSORFLOWVER}-cp38-none-linux_x86_64.whl \
    && gdown --id 1yOJ_F3IYAo2SlThyRNDoXuxADuM3XdGz \
    && tar -zxvf flatc.tar.gz \
    && chmod +x flatc \
    && rm flatc.tar.gz \
    && wget https://github.com/PINTO0309/tflite2tensorflow/raw/main/schema/schema.fbs \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list \
    && apt-get update \
    && apt-get install edgetpu-compiler \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install OpenVINO
RUN gdown --id 1GfpkEn_rnfYEYY_QzTTM2oiaCPlfbvex \
    && tar xf l_openvino_toolkit_p_${OPENVINOVER}.tgz \
    && rm l_openvino_toolkit_p_${OPENVINOVER}.tgz \
    && l_openvino_toolkit_p_${OPENVINOVER}/install_openvino_dependencies.sh -y \
    && sed -i 's/decline/accept/g' l_openvino_toolkit_p_${OPENVINOVER}/silent.cfg \
    && l_openvino_toolkit_p_${OPENVINOVER}/install.sh --silent l_openvino_toolkit_p_${OPENVINOVER}/silent.cfg \
    && source ${OPENVINOROOTDIR}/bin/setupvars.sh \
    && ${INTEL_OPENVINO_DIR}/install_dependencies/install_openvino_dependencies.sh \
    && sed -i 's/sudo -E //g' ${INTEL_OPENVINO_DIR}/deployment_tools/model_optimizer/install_prerequisites/install_prerequisites.sh \
    && sed -i 's/tensorflow/#tensorflow/g' ${INTEL_OPENVINO_DIR}/deployment_tools/model_optimizer/requirements.txt \
    && sed -i 's/numpy/#numpy/g' ${INTEL_OPENVINO_DIR}/deployment_tools/model_optimizer/requirements.txt \
    && sed -i 's/onnx/#onnx/g' ${INTEL_OPENVINO_DIR}/deployment_tools/model_optimizer/requirements.txt \
    && ${INTEL_OPENVINO_DIR}/deployment_tools/model_optimizer/install_prerequisites/install_prerequisites.sh \
    && rm -rf l_openvino_toolkit_p_${OPENVINOVER} \
    && echo "source ${OPENVINOROOTDIR}/bin/setupvars.sh" >> .bashrc \
    && echo "${OPENVINOROOTDIR}/deployment_tools/ngraph/lib/" >> /etc/ld.so.conf \
    && echo "${OPENVINOROOTDIR}/deployment_tools/inference_engine/lib/intel64/" >> /etc/ld.so.conf \
    && pip cache purge \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install TensorRT additional package
RUN gdown --id 1nZ8RQU12Zv6JA4726we1Sf3Trcbyt0-W \
    && dpkg -i nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb \
    && apt-key add /var/nv-tensorrt-repo-${OSVER}-${TENSORRTVER}/7fa2af80.pub \
    && apt-get update \
    && apt-get install uff-converter-tf graphsurgeon-tf \
    && rm nv-tensorrt-repo-${OSVER}-${TENSORRTVER}_1-1_amd64.deb \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install Custom PyTorch
RUN gdown --id 1L257ptjP1EnQCDEHwarrDCZw23n4S8rJ \
    && pip install torch-${TORCHVER}-cp38-cp38-linux_x86_64.whl \
    && rm torch-${TORCHVER}-cp38-cp38-linux_x86_64.whl \
    && gdown --id 1B7dsmZYQdiMDWHuEMz-wCMEb-3yz-H9j \
    && pip install torchvision-${TORCHVISIONVER}-cp38-cp38-linux_x86_64.whl \
    && rm torchvision-${TORCHVISIONVER}-cp38-cp38-linux_x86_64.whl \
    && gdown --id 1Y5ZOkRB0dN8fu9J6jrxSbvAm19wnO2v9 \
    && pip install torchaudio-${TORCHAUDIOVER}-cp38-cp38-linux_x86_64.whl \
    && rm torchaudio-${TORCHAUDIOVER}-cp38-cp38-linux_x86_64.whl \
    && pip cache purge \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Install Custom TensorFlow (MediaPipe Custom OP, FlexDelegate, XNNPACK enabled)
RUN gdown --id 1fDris22yvzJpJmdc-AJvlIpYsW0YmLDH \
    && mv tensorflow-${TENSORFLOWVER}-cp38-cp38-linux_x86_64.whl tensorflow-${TENSORFLOWVER}-cp38-none-linux_x86_64.whl \
    && pip install --force-reinstall tensorflow-${TENSORFLOWVER}-cp38-none-linux_x86_64.whl \
    && rm tensorflow-${TENSORFLOWVER}-cp38-none-linux_x86_64.whl \
    && pip install numpy==1.20.2 \
    && pip cache purge \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Download the ultra-small sample data set for INT8 calibration
RUN mkdir sample_npy \
    && gdown --id 1e-Zg2OVgeTDgpndIBrwW5Ka07C5WrhSS -O sample_npy/calibration_data_img_sample.npy

# Clear caches
RUN apt clean \
    && rm -rf /var/lib/apt/lists/*

# Create a user who can sudo in the Docker container
ENV username=user
RUN echo "root:root" | chpasswd \
    && adduser --disabled-password --gecos "" "${username}" \
    && echo "${username}:${username}" | chpasswd \
    && echo "%${username}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${username} \
    && chmod 0440 /etc/sudoers.d/${username}
USER ${username}
RUN sudo chown ${username}:${username} ${wkdir}

# OpenCL settings - https://github.com/intel/compute-runtime/releases
RUN cd ${OPENVINOROOTDIR}/install_dependencies/ \
    && yes | sudo -E ./install_NEO_OCL_driver.sh \
    && cd ${wkdir} \
    && wget https://github.com/intel/compute-runtime/releases/download/21.14.19498/intel-gmmlib_20.4.1_amd64.deb \
    && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.6812/intel-igc-core_1.0.6812_amd64.deb \
    && wget https://github.com/intel/intel-graphics-compiler/releases/download/igc-1.0.6812/intel-igc-opencl_1.0.6812_amd64.deb \
    && wget https://github.com/intel/compute-runtime/releases/download/21.14.19498/intel-opencl_21.14.19498_amd64.deb \
    && wget https://github.com/intel/compute-runtime/releases/download/21.14.19498/intel-ocloc_21.14.19498_amd64.deb \
    && wget https://github.com/intel/compute-runtime/releases/download/21.14.19498/intel-level-zero-gpu_1.0.19498_amd64.deb \
    && sudo dpkg -i *.deb \
    && rm *.deb \
    && sudo apt clean \
    && sudo rm -rf /var/lib/apt/lists/*
