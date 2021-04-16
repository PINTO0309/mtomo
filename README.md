# mtomo
<p align="center">
  <img src="https://user-images.githubusercontent.com/33194443/114279517-12f51b80-9a70-11eb-868d-a68620344ca1.png" />
</p>

**M**ultiple **t**ypes **o**f NN **m**odel **o**ptimization environments. It is possible to directly access the host PC GUI and the camera to verify the operation. And, Intel iHD GPU (iGPU) support. NVIDIA GPU (dGPU) support.

## 1. Environment
1. Docker 20.10.5, build 55c4c88

## 2. Model optimization environment to be built
1. Ubuntu 20.04 x86_64
2. CUDA 11.2
3. cuDNN 8.1
4. TensorFlow v2.5.0-rc1 (MediaPipe Custom OP, FlexDelegate, XNNPACK enabled)
5. tflite_runtime v2.5.0-rc1 (MediaPipe Custom OP, FlexDelegate, XNNPACK enabled)
6. edgetpu-compiler
7. flatc 1.12.0
8. TensorRT cuda11.1-trt7.2.3.4-ga-20210226
9. PyTorch 1.8.1+cu112
10. TorchVision 0.9.1+cu112
11. TorchAudio 0.8.1
12. OpenVINO 2021.3.394
13. tensorflowjs
14. coremltools
15. onnx
16. tf2onnx
17. tensorflow-datasets
18. openvino2tensorflow
19. tflite2tensorflow
20. onnxruntime
21. onnx-simplifier
22. MXNet
23. gdown
24. OpenCV 4.5.2-openvino
25. Intel-Media-SDK
26. Intel iHD GPU (iGPU) support

## 3. Usage
### 3-1. Docker Hub
https://hub.docker.com/repository/docker/pinto0309/mtomo/tags?page=1&ordering=last_updated
```
$ xhost +local: && \
  docker run -it --rm \
    --gpus all \
    -v `pwd`:/home/user/workdir \
    -v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
    --device /dev/video0:/dev/video0:mwr \
    --net=host \
    -e LIBVA_DRIVER_NAME=iHD \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -e DISPLAY=$DISPLAY \
    --privileged \
    pinto0309/mtomo:ubuntu2004_tf2.5.0-rc1_torch1.8.1_openvino2021.3.394
```

### 3-2. Docker Build
```
$ git clone https://github.com/PINTO0309/mtomo.git && cd mtomo
$ docker build -t {IMAGE_NAME}:{TAG} .
```

### 3-3. Docker Run
```
$ xhost +local: && \
  docker run -it --rm \
    --gpus all \
    -v `pwd`:/home/user/workdir \
    -v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
    --device /dev/video0:/dev/video0:mwr \
    --net=host \
    -e LIBVA_DRIVER_NAME=iHD \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -e DISPLAY=$DISPLAY \
    --privileged \
    {IMAGE_NAME}:{TAG}
```

## 4. Reference articles
1. [openvino2tensorflow](https://github.com/PINTO0309/openvino2tensorflow.git)
2. [tflite2tensorflow](https://github.com/PINTO0309/tflite2tensorflow.git)
3. [tensorflow-onnx (a.k.a tf2onnx)](https://github.com/onnx/tensorflow-onnx.git)
4. [tensorflowjs](https://pypi.org/project/tensorflowjs/)
5. [coremltools](https://github.com/apple/coremltools.git)
6. [OpenVINO](https://docs.openvinotoolkit.org/latest/openvino_docs_MO_DG_prepare_model_convert_model_Converting_Model.html)
7. [onnx](https://github.com/onnx/onnx.git)
8. [onnx-simplifier](https://github.com/daquexian/onnx-simplifier.git)
9. [TensorFLow](https://github.com/tensorflow/tensorflow.git)
10. [PyTorch](https://github.com/pytorch/pytorch.git)
11. [flatbuffers (a.k.a flatc)](https://google.github.io/flatbuffers/)
12. [TensorRT](https://developer.nvidia.com/tensorrt)
13. [Intel-Media-SDK/MediaSDK - Running on GPU under docker](https://github.com/Intel-Media-SDK/MediaSDK/wiki/Running-on-GPU-under-docker)
14. [Intel-Media-SDK/MediaSDK - Intel media stack on Ubuntu](https://github.com/Intel-Media-SDK/MediaSDK/wiki/Intel-media-stack-on-Ubuntu)

