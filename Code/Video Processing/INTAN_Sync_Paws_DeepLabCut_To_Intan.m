function INTAN_Sync_DeepLabCut_To_Intan %(runAll)
% function INTAN_Sync_DeepLabCut_To_Intan(deeplab_file, frame_times_uS, outfile, sFreq)
%
% Cowen 2020
% Jordan 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  deeplab_file = 'C:\Temp\5.1DLC_resnet50_Digit Tracking +Nov22shuffle1_1030000.csv'; % note:Day 4 seems like we lost the timestmaps.
%  load('C:\Users\Stephen Cowen\Box Sync\Cowen Laboratory\Data\LID_Ketame_Single_Unit_R56\Rat315\05\EVT.mat');
%  sFreq = 30000; % sampling rate of data acquisition.
%  frame_times_uS = 1e6*EVT.front_camera_frame_ID/sFreq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


folders = split(pwd,'\');
session = {folders{end}};
video=session;
rat=folders{end-1};

runAll = 0;


PXmap   =  [386,386,387];
BoxPath = 'C:\Users\Sam.Jordan\Box\'; %%%include last '\'
networkIt=1;
Filt = 1;

fprintf("Using network iteration %d\n",networkIt)
pause(3)
InsideBox = 'Cowen Laboratory\Data\LID_Ketamine_Single_Unit_R56';
curr=pwd;
cd 'G:\GitHub\DeepLabCut_CowenLabMods\String_Pulling';
addpath(genpath('Paws'))
cd(curr);

if runAll
    fprintf("Analyzing all sessions\n");
    session = [40,39,38,37,36,33,32,31,30,29,28,27,26,24,20,10];
    video   = [40,39,38,37,36,33,32,31,30,29,28,27,26,24,20,10];
else
    fprintf("Analyzing sessions(s) %d\n", str2double(session{1}));
end


for v=1:length(video)
    
    
    EVTFile = join([BoxPath,InsideBox]);
    FullBox = fullfile(EVTFile,"Rat" + rat,(session{v}));
    EVTFile = fullfile(EVTFile,"Rat" + rat,(session{v}),'EVT.mat');
    
    
    
    master_path = 'G:\DATA\LID_Ketamine_SingleUnit_R56';
    
    
    switch networkIt
        case 0
             switch Filt
                case false
                    DLC_Network_Version = 'DLC_resnet101_Paw TrackingOct14shuffle1_730000.csv';
                case true
                    DLC_Network_Version = 'DLC_resnet101_Paw TrackingOct14shuffle1_730000_filtered.csv';
            end
        case 1
            switch Filt
                case false
                    DLC_Network_Version = 'DLC_resnet101_Paw TrackingOct14shuffle1_730000.csv';
                case true
                    DLC_Network_Version = 'DLC_resnet101_Paw TrackingOct14shuffle1_730000_filtered.csv';
            end
        case 2
            switch Filt
                case false
                    DLC_Network_Version = '';
                case true
                    DLC_Network_Version = '';
            end
        case 3
            switch Filt
                case false
                    DLC_Network_Version = '';
                case true
                    DLC_Network_Version = '';
            end
            
    end
    
    
    csv_filepath = join([(video{v}),DLC_Network_Version]);
    if strcmp((session{v}),(video{v})) == 1
        deeplab_file = fullfile(master_path,rat,(session{v}),csv_filepath);
    else
        deeplab_file = fullfile(master_path,rat,(session{v}),(video{v}),csv_filepath);
    end
    
    
    opts = delimitedTextImportOptions();
    opts.DataLines = [2 3];
    
    
    try H = readmatrix(deeplab_file,opts);
        
    catch
        switch networkIt
            case 0
               switch Filt
                case false
                    DLC_Network_Version = 'DeepCut_resnet101_Paw TrackingOct14shuffle1_730000.csv';
                case true
                    DLC_Network_Version = 'DeepCut_resnet101_Paw TrackingOct14shuffle1_730000_filtered.csv';
            end
            case 1
               switch Filt
                case false
                    DLC_Network_Version = 'DeepCut_resnet101_Paw TrackingOct14shuffle1_730000.csv';
                case true
                    DLC_Network_Version = 'DeepCut_resnet101_Paw TrackingOct14shuffle1_730000_filtered.csv';
            end
            case 2
                switch Filt
                    case false
                        DLC_Network_Version = '';
                    case true
                        DLC_Network_Version = '';
                end
            case 3
                switch Filt
                    case false
                        DLC_Network_Version = '';
                    case true
                        DLC_Network_Version = '';
                end
        end
        
        csv_filepath = join([num2str(video{v}),DLC_Network_Version]);
        
        if strcmp((session{v}),(video{v})) == 1
            deeplab_file = fullfile(master_path,rat,(session{v}),csv_filepath);
        else
            deeplab_file = fullfile(master_path,rat,(session{v}),(video{v}),csv_filepath);
        end
        H = readmatrix(deeplab_file,opts);
    end
    fprintf('\nReading from file: %s\n', deeplab_file)
    
    
    
    
    

    load(EVTFile);
    if ~isempty(EVT.front_camera_frame_ID)
    sFreq = 30000; % sampling rate of data acquisition.
    frame_times_uS = 1e6*EVT.front_camera_frame_ID/sFreq;
    
    recording_start_index=0;
    
    dFR2=diff(diff(frame_times_uS));
    slp_change=abs(dFR2(1:length(dFR2)/2))>100;
    chg_idx=find(slp_change(1:length(slp_change)/2));

    
    to_high=strfind(slp_change, [0 1]);
    to_low=strfind(slp_change, [1 0]);
    recording_start_index=to_low(1)+1;
    
        %%% Eliminates pulses generated from plugging in the BNC cable
        fprintf("Removing pulses generated by BnC cable insertion\n")

    
    
    frame_times_uS = frame_times_uS(recording_start_index:end);
    else
    
    
    end
    
    [out_dir,fname,ext] = fileparts(deeplab_file);
    if nargin < 3
        outfile = fullfile(out_dir,'DeepLabCutCoords.mat');
        outfile2 = fullfile(FullBox,'DeepLabCutTS.csv');
        outfile3 = fullfile(FullBox,'DeepLabCutTS_Oriented.csv');
    end
    
    
    
    
    
    
    % Create new variable names
    new_vbl = [];
    for iV = 1:length(H)
        new_vbl{iV} = [H{1,iV} '_' H{2,iV}];
    end
    
    %Account change DLC variable names to ones readable by matlab
    new_vbl{find(strcmp('Left Paw_x',new_vbl))}='Left_Paw_x';
    new_vbl{find(strcmp('Left Paw_y',new_vbl))}='Left_Paw_y';
    new_vbl{find(strcmp('Left Paw_likelihood',new_vbl))}='Left_Paw_likelihood';
    new_vbl{find(strcmp('Right Paw_x',new_vbl))}='Right_Paw_x';
    new_vbl{find(strcmp('Right Paw_y',new_vbl))}='Right_Paw_y';
    new_vbl{find(strcmp('Right Paw_likelihood',new_vbl))}='Right_Paw_likelihood';
    
    
    new_vbl{1} = 'frame';
    T = readtable(deeplab_file,'HeaderLines',2);
    % Convert to singles to save space.
    f = fieldnames(T);
    for iF = 1:size(T,2)
        T.(f{iF}) = single(T.(f{iF}));
    end
    % rename the variables...
    T.Properties.VariableNames = new_vbl;
    S=size(T);
    
    if isempty(EVT.front_camera_frame_ID)
        frame_times_uS=0:S(1)-1;
        frame_times_uS=frame_times_uS*(1e6/367);
        
    end
    
    
    nrecs = [length(frame_times_uS) size(T,1)];
    
    
    
    %frame_times_uS=frame_times_uS(1:S(1));
    
    if length(frame_times_uS)  > size(T,1)
        disp('Intan events > data file. Assuming the video recording terminated prematurely')
    end
    
    if length(frame_times_uS)  < size(T,1)
        disp('Intan events < data file. Assuming intan crashed prematurely or the video recording lasted longer than the intan recording')
    end
    

    frame_times_uS=frame_times_uS(1:S(1));
    
    
    min_recs = min(nrecs);
    T.Time_uSec = ones(size(T,1),1)*-1;
    T.Time_uSec = double(T.Time_uSec);
    
    T.Time_uSec(1:min_recs) = frame_times_uS(1:min_recs);
    % isa(T.x,'single')
    % isa(T.Time_uSec,'single')
    % isa(T.Time_uSec,'double')
    NOTES = 'Created using INTAN_Sync_DeepLabCut_To_Intan.m';
    %%% Saves local cop0y
    save(outfile,'T','NOTES');
    writetable(T,outfile2)
    %%% Saves box copy
    save(fullfile(FullBox,'Time_Stamped_Coordinates'), 'T', 'NOTES');
    M = double(table2array(T));
    [T,T2] = DeepLabCut_Filter(M,deeplab_file,video{v},outfile2,frame_times_uS);
    save(fullfile(FullBox,'Filtered_Time_Stamped_Coordinates'), 'T2', 'NOTES')
    T3=T2;
    T3.Nose_y=880.-T3.Nose_y;
    T3.Left_y=880.-T3.Left_y;
    T3.Right_y=880.-T3.Right_y;
    save(fullfile(FullBox,'Filtered_Time_Stamped_Coordinates_Corrected_Ori'), 'T3', 'NOTES')
    %fprintf("Now calculating velocities and position vectors\n")
    %M = double(table2array(T2));
    %PlotVelocity(M,PXmap,FullBox);
    
    % if nargout == 0
    %     coords_to_plot = [];
    %     coords_to_plot{1,1} = 'L0_x';
    %     coords_to_plot{1,2} = 'L0_y';
    %     coords_to_plot{2,1} = 'L5_x';
    %     coords_to_plot{2,2} = 'L5_y';
    %     coords_to_plot{3,1} = 'R0_x';
    %     coords_to_plot{3,2} = 'R0_y';
    %     coords_to_plot{4,1} = 'R5_x';
    %     coords_to_plot{4,2} = 'R5_y';
    %     coords_to_plot{5,1} = 'Nose_x';
    %     coords_to_plot{5,2} = 'Nose_y';
    %
    %     for iC = 1:length(coords_to_plot)
    %         figure
    %         plot(T.(coords_to_plot{iC,1}),T.(coords_to_plot{iC,2}),'.','Markersize',1)
    %         xlabel(coords_to_plot{iC,1})
    %         ylabel(coords_to_plot{iC,2})
    %         axis tight
    %
    %     end
    %
    %     % Now plot against time... and include likelihood.
    %     for iC = 1:length(coords_to_plot)
    %         figure
    %         plot(T.Time_uSec/60e6,T.(coords_to_plot{iC,1}))
    %         hold on
    %         plot(T.Time_uSec/60e6,T.(coords_to_plot{iC,2}))
    %         newvbl = [(coords_to_plot{iC,2}(1:end-1)) 'likelihood'];
    %         yyaxis right
    %
    %         plot(T.Time_uSec/60e6,T.(newvbl),'c')
    %
    %         title([coords_to_plot{iC,1} coords_to_plot{iC,2}])
    %         axis tight
    %         xlabel('min')
    %     end
    
    
    
    




end
end
