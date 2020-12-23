#pragma once

#include <opencv2/core.hpp>

#ifndef DUST_SEPARATION_MODULE
#define DUST_SEPARATION_MODULE

class DustSeparationModule
{
public:
	void separateDustFromImage(const cv::Mat& image, cv::Mat* binaryDustImage);
private:
	int mMedianFilterSize;
	int mThreshold;
public:

	DustSeparationModule(int medianFilterSize = 5);

};



#endif 
