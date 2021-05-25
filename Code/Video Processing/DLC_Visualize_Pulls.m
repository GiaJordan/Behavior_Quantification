function [] = DLC_Visualize_Plots(GF)

P.rat=315;
P.session=39;
P.start=30;
P.displayPlot=false;
P.plotAll=true;


j=0;
j=uint64(j);
analysis_directory='C:\Temp\TempAnaResults';
question='Q2_Can_We_Identify_Loops';
targetdir=fullfile(analysis_directory,question);

vid_path=fullfile('G:\DATA\LID_Ketamine_SingleUnit_R56',num2str(P.rat),num2str(P.session),[num2str(P.session) '.mp4'])
out_path=fullfile('G:\DATA\LID_Ketamine_SingleUnit_R56',num2str(P.rat),num2str(P.session),'Pull_Videos');
if ~exist(out_path)
    mkdir(out_path)
end

addpath(targetdir)
addpath(vid_path)

inputname=dir(fullfile(targetdir,'Dset*.mat'));
%imgs=dir(fullfile(vid_path,'file*.png'));
coords=load('Filtered_Time_Stamped_Coordinates.mat');
coords=table2array(coords.T2);
load(['Dset_rat_' num2str(P.rat) '_' num2str(P.session) '.mat'])
video=VideoReader(vid_path);


Left=table2array(Left);
Right=table2array(Right);

Frames=[];

for i =P.start:length(Left)
    %
    % Pull.Left   =   NaN([800,600,3,296,Left(i,2)-Left(i,1)])
    % Pull.Left   =   uint8(Pull.Left);
    %
    Pull.Left(:,:,:,:)=read(video, [Left(i,1) Left(i,3)]);
    
    
    
    %%
    % trying to fit all the plot and save commands in here for left paw
    k=Left(i,1);
    S=size(Pull.Left);
    
    
%     period=[Left(i,1):Left(i,3)];
%     
%     Frames=gobjects(S(4),1);
%     Frames(:)=figure('visible','off');
%     image(flipud(Pull.Left(:,:,:,:)));
%     truesize;
%     axis xy; 
%     hold on;
%     scatter(coords(period,2),coords(period,3),100,'b');
%     hold on;
%     scatter(coords(period,4),coords(period,5),100,'r');
%     hold on;
%     scatter(coords(period,6),coords(period,7),100,'y');
%     hold off
    
    
    
    
    for j=1:S(4)
        %figure
        clf
        
        if P.displayPlot
            show = 'on';
        else 
            show = 'off';
        end
        
        figure('visible', show)
        imagesc(flipud(Pull.Left(:,:,:,j)));
        truesize
        
        axis xy
        hold on
        
        if ~isnan(coords(k,2))
            scatter(coords(k,2),coords(k,3),100,'b')
            hold on
        end
        if ~isnan(coords(k,4))
            scatter(coords(k,4),coords(k,5),100,'r')
            hold on
        end
        if ~isnan(coords(k,6))
            scatter(coords(k,6),coords(k,7),100,'y')
        end
        hold off
        Frames(i,j).data=getframe(gcf);
        
        close
        k=k+1;
    end
    %% Save video
    writer=VideoWriter(fullfile(out_path,[num2str(i) '_Pull_Left']), 'MPEG-4')
    %writer.FrameRate=15;
    open(writer)
    for iF=1:j
        
        f=Frames(i,iF);
        writeVideo(writer,f.data');
        
    end
    close(writer)
    clear Pull
end

for i=P.start:length(Right)
    % Pull.Right  =   [800,600,3,256,Right(j,2)-Right(j,1)]
    % Pull.Right  =   uint8(Pull.Right);
    
    Pull.Right(:,:,:,:)=read(video, [Right(i,1) Right(i,3)]);
    
    %%
    % trying to fit all the plot and save commands in here for Right paw
    k=Right(i,1);
    S=size(Pull.Right);
    for j=1:S(4)
        figure
        
        imagesc(flipud(Pull.Right(:,:,:,j)));
        truesize
        
        axis xy
        hold on
        
        if ~isnan(coords(k,2))
            scatter(coords(k,2),coords(k,3),100,'b')
            hold on
        end
        if ~isnan(coords(k,4))
            scatter(coords(k,4),coords(k,5),100,'r')
            hold on
        end
        if ~isnan(coords(k,6))
            scatter(coords(k,6),coords(k,7),100,'y')
        end
        hold off
        Frames(i,j).data=getframe(gcf);
        
        close
        k=k+1;
    end
    
    %% Save video
    writer=VideoWriter(fullfile(out_path,[num2str(i) '_Pull_Right']), 'MPEG-4')
    writer.FrameP.rate=15;
    open(writer)
    for iF=1:j
        
        f=Frames(i,iF);
        writeVideo(writer,f.data');
        
    end
    close(writer)
    
    clear Pull
    
end
                       



end