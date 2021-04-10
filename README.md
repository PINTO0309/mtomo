# mtomo
**M**ultiple **t**ypes **o**f NN **m**odel **o**ptimization environments.

## 1. Environment
1. Docker 20.10.5, build 55c4c88

## 2. Model optimization environment to be built
1. Ubuntu 18.04 x86_64
2. TensorFlow v2.4.1 (MediaPipe Custom OP, FlexDelegate, XNNPACK enabled)
3. tflite_runtime v2.4.1 (MediaPipe Custom OP, FlexDelegate, XNNPACK enabled)
4. edgetpu-compiler
5. flatc 1.12.0
6. TensorRT cuda11.0-trt7.1.3.4-ga-20200617
7. PyTorch 1.7.1+cu110
8. TorchVision 0.8.2+cu110
9. TorchAudio 0.7.2
10. OpenVINO 2021.3.394
11. tensorflowjs
12. coremltools
13. onnx
14. tf2onnx
15. tensorflow-datasets
16. openvino2tensorflow
17. tflite2tensorflow
18. onnxruntime
19. onnx-simplifier
20. gdown
21. OpenCV 4.5.2-openvino

## 3. Usage
### 3-1. Docker Hub
```
$ xhost +local: && \
  docker run -it --rm \
    --gpus all \
    -v `pwd`:/home/user/workdir \
    -v /tmp/.X11-unix/:/tmp/.X11-unix:rw \
    --device /dev/video0:/dev/video0:mwr \
    -e DISPLAY=$DISPLAY \
    --privileged \
    pinto0309/mtomo:tf2.4.1_torch1.7.1_openvino2021.3.394
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
    -e DISPLAY=$DISPLAY \
    --privileged \
    {IMAGE_NAME}:{TAG}
```


