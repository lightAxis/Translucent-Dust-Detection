#include <opencv2/core.hpp>
#include <opencv2\highgui.hpp>
#include <opencv2\imgproc\imgproc.hpp>

#include <iostream>
#include <chrono>

#include "CVModules/DustSeparationModule.h"
#include "CVModules/DustDensityEstimationModule.h"


cv::Mat image;
cv::Mat separatedDustImage;
cv::Mat densityEstimationImage;


DustSeparationModule DustSeparation_Module = DustSeparationModule(5);
DustDensityEstimationModule DustDensityEstimation_Module = DustDensityEstimationModule();


int main()
{

	image = cv::imread("./TestImages/realWindow_3.jpg");

	std::chrono::steady_clock::time_point begin = std::chrono::steady_clock::now();

	DustSeparation_Module.separateDustFromImage(image, &separatedDustImage);

	bool isVisualize = false;
	float estimatedDensity = DustDensityEstimation_Module.estimateDustDensity(
		separatedDustImage,&densityEstimationImage,20, 36,isVisualize);

	std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();


	cv::imshow("originalImage", image);
	cv::imwrite("originalImage.png", image);

	cv::imshow("separatedDustImage", separatedDustImage);

	cv::imshow("proposedAreas", densityEstimationImage);
	cv::imwrite("proposedAreas.png", densityEstimationImage);

	std::cout << estimatedDensity << std::endl;
	std::cout << "Time difference = " << std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count() << "[µs]" << std::endl;

	cv::waitKey(0);
}
