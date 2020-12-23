#pragma once

#include <opencv2/core.hpp>

#ifndef DUST_DENSITY_ESTIMATION_MODULE
#define DUST_DENSITY_ESTIMATION_MODULE

class DustDensityEstimationModule
{

public:
	struct centroid {
		cv::Point2f center;
		cv::Point2f lastCenter;
		bool isDead = false;
		float density = 0;
	};
private:
	struct rangei {
		int start;
		int end;

		rangei(int start, int end)
		{
			this->start = start;
			this->end = end;
		}
	};

public:
	float estimateDustDensity(const cv::Mat& binaryImg, cv::Mat* outputImg,
		const int& verSeg, const int& horSeg, const bool& isVisualize,
		const float& deadDist = 1, const float& radius = -1);

private:
	void mMakeSegList(const int& rows, const int& cols,
		const int& verSeg, const int& horSeg,
		std::vector<float>* verList, std::vector<float>* horList);
	void mVisualizeFrame(const cv::Mat& image, cv::Mat* outputImage, const std::vector<centroid>& centroids);

	void mDoMeanShift(const cv::Mat& image, const bool& isVisualize);
	float mEstimateDustDensity_withMeanShift(std::vector<centroid>* outputCentroids);

	std::vector<centroid> mCentroids;
	float mRadius;
	float mCircleSize;
	float mDeadDist;

};


#endif
