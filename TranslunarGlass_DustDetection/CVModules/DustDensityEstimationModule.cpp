#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>

#include <vector>
#include <queue>


class DustDensityEstimationModule
{

public:
	struct centroid {
		cv::Point2f center;
		cv::Point2f lastCenter;
		bool isDead=false;
		float density=0;
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
		const int& verSeg, const int& horSeg, const bool& isVisualize ,
		const float& deadDist = 1, const float& radius = -1);

private:
	void mMakeSegList(const int& rows, const int& cols, 
		const int& verSeg, const int& horSeg,
		std::vector<float>* verList, std::vector<float>* horList);
	void mVisualizeFrame(const cv::Mat& image, cv::Mat* outputImage,const std::vector<centroid>& centroids);
	
	void mDoMeanShift(const cv::Mat& image, const bool& isVisualize);
	float mEstimateDustDensity_withMeanShift(std::vector<centroid>* outputCentroids);

	std::vector<centroid> mCentroids;
	float mRadius;
	float mCircleSize;
	float mDeadDist;

};

void DustDensityEstimationModule::mMakeSegList(const int& rows, const int& cols, const int& verSeg, const int& horSeg, std::vector<float>* verList, std::vector<float>* horList)
{
	auto& verList_ = *verList;
	auto& horList_ = *horList;

	int ver = rows;
	int hor = cols;

	float verPer = ver / (float)verSeg;
	float horPer = hor / (float)horSeg;

	verList_.clear();
	verList_.reserve(verSeg);
	for (int i = 1; i < verSeg; i++)
	{
		verList_.push_back(i * verPer);
	}

	horList_.clear();
	horList_.reserve(horSeg);
	for (int i = 1; i < horSeg; i++)
	{
		horList_.push_back(i * horPer);
	}
}

float DustDensityEstimationModule::estimateDustDensity(const cv::Mat& binaryImg, cv::Mat* outputImg, 
	const int& verSeg, const int& horSeg, const bool& isVisualize, 
	const float& deadDist, const float& radius)
{
	auto& outputImg_ = *outputImg;

	std::vector<float> verList;
	std::vector<float> horList;


	mMakeSegList(binaryImg.rows, binaryImg.cols, verSeg, horSeg, &verList, &horList);


	mCentroids.clear();
	for (auto verIter = verList.begin(); verIter!=verList.end();verIter++)
	{
		for (auto horIter = horList.begin(); horIter != horList.end(); horIter++)
		{
			centroid tempCentroid;
			tempCentroid.center = cv::Point2f(*horIter, *verIter);
			tempCentroid.lastCenter = tempCentroid.center;
			tempCentroid.isDead = false;
			tempCentroid.density = 0.0f;
			mCentroids.push_back(tempCentroid);
		}
	}


	mRadius = radius;
	if (mRadius <= -1)
	{
		mRadius = std::hypotf(verList[0] - verList[1], horList[0] - horList[1]);
	}
	mCircleSize = mRadius * mRadius * 3.14159f;
	mDeadDist = deadDist;


	mDoMeanShift(binaryImg, isVisualize);
	

	std::vector<centroid> outputCentroids;
	float density = mEstimateDustDensity_withMeanShift(&outputCentroids);
	mVisualizeFrame(binaryImg, &outputImg_, outputCentroids);
	
	return density;

}

void DustDensityEstimationModule::mDoMeanShift(const cv::Mat& image, const bool& isVisualize)
{
	int ver = image.rows;
	int hor = image.cols;

	bool done = false;
	rangei temp_x = rangei(0, 0);
	rangei temp_y = rangei(0, 0);

	long dot_x = 0;
	long dot_y = 0;
	float n = 0;

	float dist = 0;

	while (done == false)
	{
		done = true;
		for (auto centroidIter = mCentroids.begin(); centroidIter != mCentroids.end(); centroidIter++)
		{

			if (centroidIter->isDead == true)
			{
				continue;
			}
			else
			{
				done = false;
			}

			

			temp_x = rangei((int)(centroidIter->center.x - mRadius), (int)(centroidIter->center.x + mRadius));
			temp_y = rangei((int)(centroidIter->center.y - mRadius), (int)(centroidIter->center.y + mRadius));
			if (temp_x.start < 0) temp_x.start = 0;
			if (temp_x.end >= hor) temp_x.end = hor;
			if (temp_y.start < 0) temp_y.start = 0;
			if (temp_y.end >= ver) temp_y.end = ver;



			dot_x = 0;
			dot_y = 0;
			n = 0;
			for (int x = temp_x.start; x < temp_x.end; x++)
			{
				for (int y = temp_y.start; y < temp_y.end; y++)
				{
					if (image.at<uchar>(y, x) != 0)
					{
						dist = std::hypotf(centroidIter->center.x - x, centroidIter->center.y - y);

						if (dist <= mRadius)
						{
							dot_x += x;
							dot_y += y;
							n++;
						}
					}

				}
			}
			if (n >= 1.0f)
			{
				centroidIter->center.x = dot_x / n;
				centroidIter->center.y = dot_y / n;
			}
			centroidIter->density = n / mCircleSize;



			dist = std::hypotf(centroidIter->center.x - centroidIter->lastCenter.x,
				centroidIter->center.y - centroidIter->lastCenter.y);

			if (dist <= mDeadDist)
			{
				centroidIter->isDead = true;
			}
			else
			{
				centroidIter->lastCenter = centroidIter->center;
			}
		}
		if (isVisualize)
		{
			cv::Mat newImg;
			mVisualizeFrame(image, &newImg,mCentroids);

			cv::imshow("mean_shifting", newImg);
			cv::waitKey(1);
		}

	}
}

void DustDensityEstimationModule::mVisualizeFrame(const cv::Mat& image, cv::Mat* outputImage, const std::vector<centroid>& centroids)
{
	auto& outputImage_ = *outputImage;

	cv::cvtColor(image, outputImage_, cv::COLOR_GRAY2BGR);

	for (auto centroidIter = centroids.begin(); centroidIter != centroids.end(); centroidIter++)
	{
		if (centroidIter->isDead)
		{
			outputImage_.at<cv::Vec3b>(centroidIter->center.y, centroidIter->center.x) = cv::Vec3b(255, 0, 0);
		}
		else
		{
			outputImage_.at<cv::Vec3b>(centroidIter->center.y, centroidIter->center.x) = cv::Vec3b(0, 0, 255);
			cv::circle(outputImage_, cv::Point(centroidIter->center.x, centroidIter->center.y), (int)mRadius, cv::Scalar(0, 255, 0), 1, 8);
		}
	}
}

float DustDensityEstimationModule::mEstimateDustDensity_withMeanShift(std::vector<centroid>* outputCentroids)
{
	auto& outputCentroids_ = *outputCentroids;

	std::sort(mCentroids.begin(), mCentroids.end(),
		[](centroid a, centroid b) {
			return a.density > b.density;
		}
	);

	int target_size = 8;
	if (target_size > mCentroids.size()) target_size = mCentroids.size();
	
	outputCentroids_.clear();
	float densities = 0;
	for (int i = 0; i < target_size; i++)
	{
		densities += mCentroids[i].density;
		mCentroids[i].isDead = false;
		outputCentroids_.push_back(mCentroids[i]);
	}

	return densities / target_size;
}