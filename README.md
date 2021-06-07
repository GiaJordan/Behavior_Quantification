# Behavior Quantification System - Gianna Jordan

This repository has depnedencies from other repositories, so when cloning for the first time please use '$ git clone --recursive'.
If you've already cloned this repository, please use '$ git submodule update --init' to download the submodules necessary.



Software
	
Collection
	Two C++ scripts for use with arduino are included to administer the string pulling task. Both will automatically measure the distance pulled and will dispense a food reward at the specified distance(s). The scripts differ in study conditions of interest. 
	'MEGA-Varied_Distance' allows for an array of target distances to be set before the beginning of a task. This will be useful during the inital shaping and training of a naive animal. Shorter distances should be set initally that gradually increase to you desired pull distance. Each distance is rewarded 100% of the time.
	'MEGA-Varied_Reward' allows for two target distances to be set. Upon reaching the shorter distance, the rat will be rewarded a specified percentage of the time. The pseudorandom percentage can be set by inserting '1s' and '0s' in the percentRewarded array for how many trials out of 10 should be rewarded and unrewarded. It is currently configured to reward 80% of the pulls to the first distance. If the first distance is unrewarded, when the rodent continues pulling to the 2nd distance there is a 100% guarantee of a reward. 
	Also included is a configuration file for the MakoU130b camera for use with Matlab's Image Acquistion Toolbox. This configures the camera to record at 367 frames per second and exposure is set for use with an external light source (ring light). Paths to save video to must be set before each recording.


Video Processing
	Functions related to the inital processing of the behavior videos are in this directory. The 'Functions' directory in this directory should be added to your Matlab Path before softwarew use. For ease of file transfer, videos can be converted beforehad from .AVIs to .MP4s. To begin, 'DLC_Vido_Analysis-Initial' should be ran in the directory of the video to rotate the video to the correct orientation. Next, 'INTAN_Sync_Paws_DeepLabCut_To_Intan' should be ran in the session directory of interest to sync the video time stamps to the cordinates and to filter the position data. Afterward 'DLC_Create_Labled_Video' or 'DLC_Create_Segments_Videos' can be used to visualized the filtered position data on top of the recorded video.

Deeplabcut models in 
'G:\GitHub\Behavior_Quantification\Code\Video Processing\DeepLabCut\dlc-models\iteration-0\Paw TrackingOct14-trainset85shuffle1\train'

and

'G:\GitHub\Behavior_Quantification\Code\Video Processing\DeepLabCut\dlc-models\iteration-1\Paw TrackingOct14-trainset85shuffle1\train' 
must be unzipped (7Zip can be used for these) before use due to GitHub size limits.
	

Analysis
	Code for analysis of behaviorial data and identification on neural correlates is included in this directory. 'Startup.m' should be ran before anything else to add the necessary paths and to intialize settings. Global paths can be set in LK_Analyse_Sessions_Gia, and this can also be used to analyze a series of data sessions automatically. This functions requires an excel spreadsheet with attributes of each session that can be used to choose which sessions to analyze. All other functions should be run in the data directory of the session of interest.
	'Q5_Where_Do_Neurons_Fire'  produces heat maps of neuron firing rates over a session at different parts of the video frame.
	'Q6_When_Do_Neurons_Fire_After_Events' will calculate the firing rate for each recorded neuron over the reach and withdraw phases of a session. 'Q6_When_Do_Neurons_Fire_After_Events_Ana' will perform statistical tests on the distribtuions of firing rates for each rat for a given phase to determine if a neuron has a preferential firing phase. A summary table of neurons with preferred firing phases will also be created for further reference. 
	'Q7_What_Are_Segment_Kinematics' will calculate various movement kinematics of a session for each paw over all the identified segments and phses of a session and output a file for further analysis. 'Q7_What_Are_Segment_Kinematics_Ana' will iterate through the output files and display the kinematic data in multiple ways (distributions and violin plots). It will also perform statisical tests on the distributions of each kinematic to compare the movement of the two paws.



3D Printable Files
	.STL files are given for various components of the String Pulling setup. Included are files for the camera and ring light mount, the mount for the rotary encoder, and the wheel to be attached to the rotary encoder. .SLDPRT files are also available for the camera mount and encoder wheel.


Documentation, Diagrams, and Drawings
	The circuit diagram for the behavior quantfication system is given in the 'Ardiuno Mega Circuit Diagrams' .PDF file. Wiring suggestions for use with a DB25 pin connecter are also included in case extension is necessary.







