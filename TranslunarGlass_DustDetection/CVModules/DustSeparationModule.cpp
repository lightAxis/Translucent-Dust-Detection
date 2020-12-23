#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>
#include <iostream>


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


DustSeparationModule::DustSeparationModule(int medianFilterSize)
{
	this->mMedianFilterSize = medianFilterSize;
	this->mThreshold = 6;
}

void DustSeparationModule::separateDustFromImage(const cv::Mat& image, cv::Mat* binaryDustImage)
{
	auto& binaryDustImage_ = *binaryDustImage;

	cv::Mat grayImage = cv::Mat(image.rows, image.cols, CV_8UC1);
	cv::Mat medianFilteredImage = cv::Mat(image.rows, image.cols, CV_8UC1);
	cv::Mat newMap = cv::Mat(image.rows, image.cols, CV_8UC1);

	cv::cvtColor(image, grayImage, cv::ColorConversionCodes::COLOR_BGR2GRAY);

	cv::medianBlur(grayImage, medianFilteredImage, this->mMedianFilterSize);

	cv::absdiff(grayImage, medianFilteredImage, newMap);

	cv::threshold(newMap, binaryDustImage_, this->mThreshold, 255, cv::THRESH_BINARY);

}

