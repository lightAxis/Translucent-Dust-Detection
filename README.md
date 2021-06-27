# Translucent-Dust-Detection

Dust Detection using image of translunar glass surface with dust

## Previous research

Facade Contaminant detection & experiment optimiation code, using OpenCV, C++ YOLOv3

https://github.com/jisuk500/Facade-Contaminant-Detection

## 2 stage structure

1. Dust separation stage
use median filte, filter size 5

2. Density Estimation stage
use mean-shift initial posision of grid to propose global maximum density area

## Detection Result

![그림1](https://user-images.githubusercontent.com/62084431/103011839-f2b35680-457d-11eb-9e39-0d9bff6c4094.png)

|Image|Estimated Density|Elapsed Time(ms)|
|:-:|:-:|:-:|
|Pic 1|0.301|402|
|Pic 2|0.463|500|
|Pic 3|0.739|978|


## Used Library
OpenCV 4.01 / C++

## Paper
Preparing

## Follow-Up Research (GPU Acceleration)

Use GPU acceleration(CUDA) to process 5.4 times faster
https://github.com/jisuk500/Translunar-Dust-Detection-GPU-CUDA-/
