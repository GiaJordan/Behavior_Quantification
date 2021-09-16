<h1>Behavior Quantification System</h1>

<h2>An Open Source System and Software Toolbox for:</h2>
<ul>
	<li>String pulling task shaping and administration</li>
	<li>Synchronization of string pulling behavior data to neural activity</li> 
	<li>Automation of behavior segmentaion</li> 
	<li>Kinematic and neural activity analysis</li>
</ul>

https://user-images.githubusercontent.com/61707471/124198057-c1639800-da84-11eb-99bd-ec2cde397f62.mp4



This repository has depnedencies from other repositories, so when cloning for the first time please use 

	$ git clone --recursive

If you've already cloned this repository, please use 
	
	$ git submodule update --init
to download the submodules necessary.



<h2>Software</h2>
	
<h3>Task Administartion and Data Collection</h3>
	<p>Two C++ scripts for use with arduino microcontrollers are included to administer the string pulling task. Both will automatically measure the distance pulled and will dispense a food reward at the specified distance(s). The scripts differ in study conditions of interest. </p>
	<p><code>MEGA-Varied_Distance</code> allows for an array of target distances to be set before the beginning of a task. This will be useful during the inital shaping and training of a naive animal. Shorter distances should be set initally that gradually increase to you desired pull distance. Each distance is rewarded 100% of the time.</p>
	<p><code>MEGA-Varied_Reward</code> allows for two target distances to be set. Upon reaching the shorter distance, the rat will be rewarded a specified percentage of the time. The pseudorandom percentage can be set by inserting '1's and '0's in the percentRewarded array for how many trials out of 10 should be rewarded and unrewarded. It is currently configured to reward 80% of the pulls to the first distance. If the first distance is unrewarded, when the rodent continues pulling to the 2nd distance there is a 100% guarantee of a reward.</p>
	<p>Also included is a configuration file for the MakoU130b camera for use with Matlab's Image Acquistion Toolbox. This configures the camera to record at 367 frames per second and exposure is set for use with an external light source (ring light). Paths to save video to must be set before each recording.</p>


<h3>Video Processing</h3>

<p>Functions related to the inital processing of the behavior videos and subsequent analysis are housed in this directory.</p>

<h4>Pre-Processing with DeepLabCut</h4>
Deeplabcut models in 

	'Code\Video Processing\DeepLabCut\dlc-models\iteration-0\Paw TrackingOct14-trainset85shuffle1\train'

and

	'Code\Video Processing\DeepLabCut\dlc-models\iteration-1\Paw TrackingOct14-trainset85shuffle1\train' 
	
must be unzipped (7Zip should be used for these) before use due to GitHub size limits. The <code>project_path</code> in DeepLabCut's <code>config.yaml</code> file should also be updated for each user to include the appropriate paths of where the project directory is located.

<p>A python environment for use with Anaconda: <code>environment.yml</code> is included with the repository. The environment includes the version of python used in development and the necessary packages for video processing and analysis with DeepLabCut. The video processing environment can be created through the Anaconda command line by changing to the 'Code\Video Processing\Anaconda Environment' directory and executing <code>conda env create -f environment.yml</code>. Afterwards, cuDNN 7.4.1 should be downloaded from <a href="https://developer.nvidia.com/rdp/cudnn-archive">Nvidia</a> and each file should be copied to its corresponding folder in the Anaconda environment directory. A guide exists on <a href="https://stackoverflow.com/a/65646944">StackOverflow</a> for placing the cuDNN files. The files in the "Bin" directory should be placed in the main anaconda environment direcotry with the other .dll files. Executing the chmod command is not necessary. <a href="https://github.com/DeepLabCut/DeepLabCut/blob/master/docs/standardDeepLabCut_UserGuide.md"> Instructions for using Deeplabcut</a> are provided by Mathis et al.</p>

<h4>MatLab Analysis</h4>
	<p>The 'Functions' subdirectory in this directory should be added to your Matlab Path before software use. For ease of file transfer, videos can be converted beforehand from .AVIs to .MP4s. To begin, <code>DLC_Vido_Analysis-Initial</code> should be ran in the directory of the video to rotate the video to the correct orientation. Next, <code>INTAN_Sync_Paws_DeepLabCut_To_Intan</code> should be ran in the session directory of interest to sync the video time stamps to the cordinates and to filter the position data. Afterward <code>DLC_Create_Labled_Video</code> or <code>DLC_Create_Segments_Videos</code> can be used to visualized the filtered position data on top of the recorded video.</p>


<h3>Analysis</h3>
	<p>Code for analysis of behaviorial data and identification on neural correlates is included in this directory. <code>Startup</code> should be ran before anything else to add the necessary paths and to intialize settings. Global paths can be set in <code>LK_Analyze_Sessions_Gia</code>, and this can also be used to analyze a series of data sessions automatically. This functions requires an excel spreadsheet with attributes of each session that can be used to choose which sessions to analyze. All other functions should be run in the data directory of the session of interest.</p>
	<p><code>Q5_Where_Do_Neurons_Fire</code>  produces heat maps of neuron firing rates over a session at different parts of the video frame.</p>
	<p><code>Q6_When_Do_Neurons_Fire_After_Events</code> will calculate the firing rate for each recorded neuron over the reach and withdraw phases of a session. <code>Q6_When_Do_Neurons_Fire_After_Events_Ana</code> will perform statistical tests on the distribtuions of firing rates for each rat for a given phase to determine if a neuron has a preferential firing phase. A summary table of neurons with preferred firing phases will also be created for further reference.</p> 
	<p><code>Q7_What_Are_Segment_Kinematics</code> will calculate various movement kinematics of a session for each paw over all the identified segments and phses of a session and output a file for further analysis. <code>Q7_What_Are_Segment_Kinematics_Ana</code> will iterate through the output files and display the kinematic data in multiple ways (distributions and violin plots). It will also perform statisical tests on the distributions of each kinematic to compare the movement of the two paws.</p>



<h2>3D Printable Files</h2>
	<p>.STL files are given for various components of the String Pulling setup. Included are files for the camera and ring light mount, the mount for the rotary encoder, and the wheel to be attached to the rotary encoder. .SLDPRT files are also available for the camera mount and encoder wheel.</p>


<h2>Documentation, Diagrams, and Drawings</h2>
	<p>The circuit diagram for the behavior quantfication system is given in the 'Ardiuno Mega Circuit Diagrams' .PDF file. Wiring suggestions for use with a DB25 pin connecter are also included in case physical extension of the system is necessary.</p>







