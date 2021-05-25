function [enAct] = Q8_How_Do_Ensembles_Behave(inputArg1,inputArg2)
%Q8_HOW_DO_ENSEMBLES_BEHAVE Summary of this function goes here
%   Detailed explanation goes here
% try stacking TSNE dims with peth_eeg_simple without crashing pc lol
%%
OUT = [];
GP = LK_Globals;
PLOT_IT = true;
Behavior_sFreq = 367;
neuron_quality_threshold = 2;

%for PETHs
PETH_win_ms = 10;
%binSize=50;
binSize=1000;
pethWinIdx=floor((PETH_win_ms*1000)/binSize);

show='off';
dimRedux='gpfa';
if strcmp(dimRedux,'gpfa')
    method='gpfa';
    xDim=8;
    kernSD=Inf;
    
    try
       
        rmdir G:\GitHub\LID_Ketamine_String_Pulling\Questions_Gia\Functions\gpfa_v0203\mat_results s
    catch
    end
end
fontSize=20;


PXmap   =  [386,386,387];
pxPerCm=median(PXmap)/10;

paws={'Right' 'Left'};
phases={'Reach' 'Withdraw'};
segmentNames={ 'Lift' 'Advance' 'Grasp' 'Push' 'Pull' 'Reach' 'Withdraw'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SES = LK_Session_Info();
OUT.SES = SES;
OUT.neuron_quality_threshold = neuron_quality_threshold;


[MT, string_pull_intervals_uSec,~,~,~,~,EVENTS] = LK_Combine_All_String_Pull_Motion_To_Table(Behavior_sFreq, false);
epoch_st_ed_uSec = [string_pull_intervals_uSec(1) - 2e6 string_pull_intervals_uSec(end) + 2e6 ]; % add a little padding.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load spikes and restrict to the times of interest.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[SP,TS_uS] = LK_Load_Spikes(neuron_quality_threshold,epoch_st_ed_uSec);
OUT.n_neurons = length(SP);

[NT,~,NT_t_uS] = Bin_and_smooth_ts_array(TS_uS,binSize);
%NT=gpuArray(NT);
%NT_t_uS=gpuArray(NT_t_uS);
%flat=[NT_t_uS',sum(NT,2)];

neurons={'1','2','3' ,'4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19'};

load('Filtered_Time_Stamped_Coordinates_Corrected_Ori');
load('good_string_pull_intervals_uSec.mat');

[PAW,~]=LK_process_paw_data(T3,good_string_pull_intervals_uSec);
segments=LK_Segment_Pulls_Further();
close


[NT_t_uS,idx]=Restrict(NT_t_uS,PAW.Time_uSec(1),PAW.Time_uSec(end));
NT=NT(idx,:);
clear idx

%
% tsn=tsne(NT);
% [coeff,score,latent,tsquared,expl]=pca(NT);
%[w,h]=nnmf(NT,2);

% roi=[segments.Right.Reach.Lift(150),segments.Right.Reach.End(150)];
% toi=PAW.Time_uSec(roi);
% [~,idx]=Restrict(NT_t_uS,toi(1),toi(2));
% [w,h]=nnmf(NT(idx,:),2);
%
%
% biplot(h','Scores',w,'VarLabels',neurons);






%%
% 
% %iterate through paws
% for i=1:2
%     %iterate through phases
%     for j=1:2
%         
%         
%         %iterate through segments until end of phase
%         for col=0:0%width(segments.(paws{i}).(phases{j}))-1
%             
%             tsn=[];
%             
%             for row=1:height(segments.(paws{i}).(phases{j}))
%                 
%                 
%                 %get current segment name
%                 if col==0
%                     currSegName=segments.(paws{i}).(phases{j}).Properties.VariableNames{1};
%                     switch currSegName
%                         
%                         case 'Lift'
%                             currSegName='Reach';
%                             
%                         case 'Pull'
%                             currSegName='Withdraw';
%                     end
%                 else
%                     currSegName=segments.(paws{i}).(phases{j}).Properties.VariableNames{col};
%                 end
%                 
%                 
%                 if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
%                     segIdx=[segments.(paws{i}).(phases{j}){row,1},segments.(paws{i}).(phases{j}){row,width(segments.(paws{i}).(phases{j}))}];
%                 else
%                     segIdx=segments.(paws{i}).(phases{j}){row,col:col+1};
%                 end
%                 
%                 %                 nanloc=isnan(segIdx);
%                 %                 segIdx=segIdx(sum(nanloc,2)==0,:);
%                 
%                 
%                 
%                 if sum(isnan(segIdx))>0
%                     disp('Skipping row')
%                     continue;
%                 end
%                 
%                 toi=[PAW.Time_uSec(segIdx(1)),PAW.Time_uSec(segIdx(2))];
%                 
%                 %for not gpfa
%                 %toi=[PAW.Time_uSec(segIdx(1))-(PETH_win_ms*1000),PAW.Time_uSec(segIdx(1))+(PETH_win_ms*1000)];
%                 
%                 [~,idx]=Restrict(NT_t_uS,toi(1),toi(2));
%                 %for not gpfa
%                 %[~,idx]=Restrict(NT_t_uS,toi(1)-(.005e6),toi(2));
%                 
%                 %                 if strcmp(show,'on')
%                 %                     figure('visible',show)
%                 %                     set(gcf,'Position',get(0,'Screensize'))
%                 %                 end
%                 
%                 switch dimRedux
%                     
%                     case 'gpfa'
%                         dat(row).trialId=row;
%                         dat(row).spikes=NT(idx,:)';
%                         if isempty(dat(row).spikes)
%                             dat(row)=[];
%                         end
%                         
%                     case 'nnmf'
%                         opts=statset('UseParallel',true);
%                         [w,h]=nnmf(NT(idx,:),2,'Options',opts);
%                         
%                         if strcmp(show,'on')
%                             %biplot(h','Scores',single(w),'VarLabels',neurons);
%                             biplot(h','VarLabels',neurons)
%                             
%                             title(sprintf("NNMF of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
%                             
%                             figure('visible',show)
%                             subplot(1,2,1);
%                             scatter(NT_t_uS(idx),w(:,1));
%                             title('Component 1','FontSize',fontSize+2)
%                             subplot(1,2,2);
%                             scatter(NT_t_uS(idx),w(:,2))
%                             set(gcf,'Position',get(0,'Screensize'))
%                             title('Component 2','FontSize',fontSize+2)
%                             
%                             
%                             %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,1)],toi(:,1),0,ceil(367/2),367,true);
%                             %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,2)],toi(:,1),0,ceil(367/2),367,true);
%                             
%                             
%                         end
%                         
%                     case 'pca'
%                         [coeff,score,latent,tsquared,expl]=pca(NT(idx,:));
%                         
%                         if strcmp(show,'on')
%                             biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',neurons);
%                             title(sprintf("PCA of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
%                         end
%                     case 'tsne'
%                         
%                         %tsn=tsne(NT(idx,:));
%                         %clear Y
%                         Y=tsne(NT(idx,:));
%                         
%                         start=find(idx==1,1);
%                         extra=(.005e6)/50;
%                         idx(start:start+extra-1)=false;
%                         Y=Y(extra+1:end,:);
%                         
%                         tsn=vertcat(tsn,[NT_t_uS(idx),Y]);
%                         %                         if strcmp(show,'on')
%                         %                             %gscatter(tsn(:,1),tsn(:,2))
%                         %                             %title(sprintf("TSNE of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
%                         %
%                         %                             subplot(1,2,1);
%                         %                             scatter(NT_t_uS(idx)/(1e6),tsn(:,1));
%                         %                             subplot(1,2,2);
%                         %                             scatter(NT_t_uS(idx)/(1e6),tsn(:,2));
%                         %
%                         %                         end
%                 end
%                 
%                 
%                 %             if strcmp(show,'on')
%                 %                 ax=gca;
%                 %                 ax.FontSize=fontSize;
%                 %             end
%                 
%                 
%             end
%             
%             
%             
%             
%             switch dimRedux
%                 
%                 case 'gpfa'
%                     
%                     inputname=dir(fullfile('mat_results','run*'));
%                     if isempty(inputname)
%                         runIdx=1;
%                     else
%                         runIdx=str2double(inputname(end).name(end-2:end))+1;
%                     end
%                     
%                     try
%                     enAct.(paws{i}).(currSegName).traj = neuralTraj(runIdx, dat, 'method', method, 'xDim', xDim);
%                     catch
%                         dat=[];
%                         continue
%                     end
%                     
% %                     [estParams, seqTrain] = postprocess(enAct.(paws{i}).(currSegName).traj);
% %                     
% %                     if strcmp(show,'on')
% %                         plot3D(seqTrain, 'xorth', 'dimsToPlot', 1:3, 'nPlotMax', 1000);
% %                         
% %                         set(gcf,'Position',get(0,'Screensize'))
% %                         if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
% %                             title(sprintf('Ensemble Behavior during %s Phase', phases{j}))
% %                         else
% %                             title(sprintf('Ensemble Behavior during %s Phase', segmentNames{((j-1)*3)+col}))
% %                         end
% %                         
% %                         plotEachDimVsTime(seqTrain, 'xorth', enAct.(paws{i}).(currSegName).traj.binWidth, 'nPlotMax', 1000);
% %                     end
%                     
%                 case 'nnmf'
%                     
%                     
%                     if strcmp(show,'on')
%                         %                         %biplot(h','Scores',single(w),'VarLabels',neurons);
%                         %                         biplot(h','VarLabels',neurons)
%                         %
%                         %                         title(sprintf("NNMF of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
%                         %
%                         %                         figure('visible',show)
%                         %                         subplot(1,2,1);
%                         %                         scatter(NT_t_uS(idx),w(:,1));
%                         %                         title('Component 1','FontSize',fontSize+2)
%                         %                         subplot(1,2,2);
%                         %                         scatter(NT_t_uS(idx),w(:,2))
%                         %                         set(gcf,'Position',get(0,'Screensize'))
%                         %                         title('Component 2','FontSize',fontSize+2)
%                         %
%                         %
%                         %                         %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,1)],toi(:,1),0,ceil(367/2),367,true);
%                         %                         %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,2)],toi(:,1),0,ceil(367/2),367,true);
%                         %
%                         
%                     end
%                     
%                 case 'pca'
%                     
%                     
%                     if strcmp(show,'on')
%                         %                         biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',neurons);
%                         %                         title(sprintf("PCA of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
%                     end
%                 case 'tsne'
%                     
%                     %tsn=tsne(NT(idx,:));
%                     
%                     if strcmp(show,'on')
%                         if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
%                             figure
%                             PETH_EEG_simple(tsn(:,1:2),PAW.Time_uSec(segments.(paws{i}).(phases{j}){:,1}),pethWinIdx,pethWinIdx,(1e6)/binSize);
%                             title(sprintf("First TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
%                             xlabel("Time (s)")
%                             figure
%                             PETH_EEG_simple([tsn(:,1),tsn(:,3)],PAW.Time_uSec(segments.(paws{i}).(phases{j}){:,1}),pethWinIdx,pethWinIdx,(1e6)/binSize);
%                             title(sprintf("Second TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
%                             xlabel("Time (s)")
%                             
%                         else
%                             figure
%                             PETH_EEG_simple(tsn(:,1:2),PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,1}),1}),pethWinIdx,pethWinIdx,(1e6)/binSize);
%                             title(sprintf("First TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
%                             xlabel("Time (s)")
%                             figure
%                             PETH_EEG_simple([tsn(:,1),tsn(:,3)],PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,col}),col}),pethWinIdx,pethWinIdx,(1e6)/binSize);
%                             title(sprintf("Second TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
%                             xlabel("Time (s)")
%                             
%                             
%                         end
%                         
%                     end
%             end
%             
%             
%             enAct.(paws{i}).(currSegName).tsne.dimRed=tsn;
%             
%             if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
%                 enAct.(paws{i}).(currSegName).tsne.toi=PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,1}),1});
%             else
%                 enAct.(paws{i}).(currSegName).tsne.toi=PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,col}),col});
%             end
%             
%             
%             
%             
%         end
%         clear dat
%     end
% end
% 
%%

%iterate through paws
for i=1:2
    %iterate through phases
    for j=2:2
        
        
        %iterate through segments until end of phase
        for col=0:0%width(segments.(paws{i}).(phases{j}))-1
            
            tsn=[];
            
            for row=1:height(segments.(paws{i}).(phases{j}))
                
                
                %get current segment name
                if col==0
                    currSegName=segments.(paws{i}).(phases{j}).Properties.VariableNames{1};
                    switch currSegName
                        
                        case 'Lift'
                            currSegName='Reach';
                            
                        case 'Pull'
                            currSegName='Withdraw';
                    end
                else
                    currSegName=segments.(paws{i}).(phases{j}).Properties.VariableNames{col};
                end
                
                
%                 if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
%                     segIdx=[segments.(paws{i}).(phases{j}){row,1},segments.(paws{i}).(phases{j}){row,width(segments.(paws{i}).(phases{j}))}];
%                 else
%                     segIdx=segments.(paws{i}).(phases{j}){row,col:col+1};
%                 end
                
                  segIdx=[(segments.(paws{i}).(phases{j}){row,1})-(367*1),segments.(paws{i}).(phases{j}){row,1}];



                %                 nanloc=isnan(segIdx);
                %                 segIdx=segIdx(sum(nanloc,2)==0,:);
                
                
                
                if sum(isnan(segIdx))>0
                    disp('Skipping row')
                    continue;
                end
                
                toi=[PAW.Time_uSec(segIdx(1)),PAW.Time_uSec(segIdx(2))];
                
                %for not gpfa
                %toi=[PAW.Time_uSec(segIdx(1))-(PETH_win_ms*1000),PAW.Time_uSec(segIdx(1))+(PETH_win_ms*1000)];
                
                [~,idx]=Restrict(NT_t_uS,toi(1),toi(2));
                %for not gpfa
                %[~,idx]=Restrict(NT_t_uS,toi(1)-(.005e6),toi(2));
                
                %                 if strcmp(show,'on')
                %                     figure('visible',show)
                %                     set(gcf,'Position',get(0,'Screensize'))
                %                 end
                
                switch dimRedux
                    
                    case 'gpfa'
                        dat(row).trialId=row;
                        dat(row).spikes=NT(idx,:)';
                        if isempty(dat(row).spikes)
                            dat(row)=[];
                        end
                        
                    case 'nnmf'
                        opts=statset('UseParallel',true);
                        [w,h]=nnmf(NT(idx,:),2,'Options',opts);
                        
                        if strcmp(show,'on')
                            %biplot(h','Scores',single(w),'VarLabels',neurons);
                            biplot(h','VarLabels',neurons)
                            
                            title(sprintf("NNMF of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
                            
                            figure('visible',show)
                            subplot(1,2,1);
                            scatter(NT_t_uS(idx),w(:,1));
                            title('Component 1','FontSize',fontSize+2)
                            subplot(1,2,2);
                            scatter(NT_t_uS(idx),w(:,2))
                            set(gcf,'Position',get(0,'Screensize'))
                            title('Component 2','FontSize',fontSize+2)
                            
                            
                            %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,1)],toi(:,1),0,ceil(367/2),367,true);
                            %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,2)],toi(:,1),0,ceil(367/2),367,true);
                            
                            
                        end
                        
                    case 'pca'
                        [coeff,score,latent,tsquared,expl]=pca(NT(idx,:));
                        
                        if strcmp(show,'on')
                            biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',neurons);
                            title(sprintf("PCA of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
                        end
                    case 'tsne'
                        
                        %tsn=tsne(NT(idx,:));
                        %clear Y
                        Y=tsne(NT(idx,:));
                        
                        start=find(idx==1,1);
                        extra=(.005e6)/50;
                        idx(start:start+extra-1)=false;
                        Y=Y(extra+1:end,:);
                        
                        tsn=vertcat(tsn,[NT_t_uS(idx),Y]);
                        %                         if strcmp(show,'on')
                        %                             %gscatter(tsn(:,1),tsn(:,2))
                        %                             %title(sprintf("TSNE of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
                        %
                        %                             subplot(1,2,1);
                        %                             scatter(NT_t_uS(idx)/(1e6),tsn(:,1));
                        %                             subplot(1,2,2);
                        %                             scatter(NT_t_uS(idx)/(1e6),tsn(:,2));
                        %
                        %                         end
                end
                
                
                %             if strcmp(show,'on')
                %                 ax=gca;
                %                 ax.FontSize=fontSize;
                %             end
                
                
            end
            
            
            
            
            switch dimRedux
                
                case 'gpfa'
                    
                    inputname=dir(fullfile('mat_results','run*'));
                    if isempty(inputname)
                        runIdx=1;
                    else
                        runIdx=str2double(inputname(end).name(end-2:end))+1;
                    end
                    
                    try
                    enAct.(paws{i}).(currSegName).traj = neuralTraj(runIdx, dat, 'method', method, 'xDim', xDim);
                    catch
                        dat=[];
                        continue
                    end
                    
                    [estParams, seqTrain] = postprocess(enAct.(paws{i}).(currSegName).traj);
                    
                    if strcmp(show,'on')
                        plot3D(seqTrain, 'xorth', 'dimsToPlot', 1:3, 'nPlotMax', 1000);
                        
                        set(gcf,'Position',get(0,'Screensize'))
                        if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
                            title(sprintf('Ensemble Behavior during %s Phase', phases{j}))
                        else
                            title(sprintf('Ensemble Behavior during %s Phase', segmentNames{((j-1)*3)+col}))
                        end
                        
                        plotEachDimVsTime(seqTrain, 'xorth', enAct.(paws{i}).(currSegName).traj.binWidth, 'nPlotMax', 1000);
                    end
                    
                case 'nnmf'
                    
                    
                    if strcmp(show,'on')
                        %                         %biplot(h','Scores',single(w),'VarLabels',neurons);
                        %                         biplot(h','VarLabels',neurons)
                        %
                        %                         title(sprintf("NNMF of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
                        %
                        %                         figure('visible',show)
                        %                         subplot(1,2,1);
                        %                         scatter(NT_t_uS(idx),w(:,1));
                        %                         title('Component 1','FontSize',fontSize+2)
                        %                         subplot(1,2,2);
                        %                         scatter(NT_t_uS(idx),w(:,2))
                        %                         set(gcf,'Position',get(0,'Screensize'))
                        %                         title('Component 2','FontSize',fontSize+2)
                        %
                        %
                        %                         %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,1)],toi(:,1),0,ceil(367/2),367,true);
                        %                         %[M,ix,x]=PETH_EEG_simple([NT_t_uS(idx)',w(:,2)],toi(:,1),0,ceil(367/2),367,true);
                        %
                        
                    end
                    
                case 'pca'
                    
                    
                    if strcmp(show,'on')
                        %                         biplot(coeff(:,1:2),'scores',score(:,1:2),'varlabels',neurons);
                        %                         title(sprintf("PCA of Ensemble Activity during %s Paw %s",paws{i},currSegName),'FontSize',fontSize+2)
                    end
                case 'tsne'
                    
                    %tsn=tsne(NT(idx,:));
                    
                    if strcmp(show,'on')
                        if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
                            figure
                            PETH_EEG_simple(tsn(:,1:2),PAW.Time_uSec(segments.(paws{i}).(phases{j}){:,1}),pethWinIdx,pethWinIdx,(1e6)/binSize);
                            title(sprintf("First TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
                            xlabel("Time (s)")
                            figure
                            PETH_EEG_simple([tsn(:,1),tsn(:,3)],PAW.Time_uSec(segments.(paws{i}).(phases{j}){:,1}),pethWinIdx,pethWinIdx,(1e6)/binSize);
                            title(sprintf("Second TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
                            xlabel("Time (s)")
                            
                        else
                            figure
                            PETH_EEG_simple(tsn(:,1:2),PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,1}),1}),pethWinIdx,pethWinIdx,(1e6)/binSize);
                            title(sprintf("First TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
                            xlabel("Time (s)")
                            figure
                            PETH_EEG_simple([tsn(:,1),tsn(:,3)],PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,col}),col}),pethWinIdx,pethWinIdx,(1e6)/binSize);
                            title(sprintf("Second TSNE componenet of Ensemble Activity At Onset of %s Paw %s",paws{i},currSegName))
                            xlabel("Time (s)")
                            
                            
                        end
                        
                    end
            end
            
            
            enAct.(paws{i}).(currSegName).tsne.dimRed=tsn;
            
            if strcmp(currSegName,'Reach') | strcmp(currSegName,'Withdraw')
                enAct.(paws{i}).(currSegName).tsne.toi=PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,1}),1});
            else
                enAct.(paws{i}).(currSegName).tsne.toi=PAW.Time_uSec(segments.(paws{i}).(phases{j}){~isnan(segments.(paws{i}).(phases{j}){:,col}),col});
            end
            
            
            
            
        end
        clear dat
    end
end





end

