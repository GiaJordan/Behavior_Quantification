

paws={'Right' 'Left'};
phases={'Reach' 'Withdraw'};
segmentNames={ 'Lift' 'Advance' 'Grasp' 'Push' 'Pull' 'Reach' 'Withdraw'};

analysis_directory='C:\Temp\TempAnaResults';
question='Q8_How_Do_Ensembles_Behave';
targetdir=fullfile(analysis_directory,question);
addpath(targetdir)

inputname=dir(fullfile(targetdir,'Dset*.mat'));
inputstruct={};



for i=1:length(inputname)
    xlabels{i}=inputname(i).name;
    xlabels{i}=xlabels{i}(14:15);
    inputstruct{i}=load( inputname(i).name);
    
end


%%
for sess=1:length(xlabels)
    enAct=inputstruct{sess};
    cd (fullfile('C:\Users\Sam.Jordan\Box\Cowen Laboratory\Data\LID_Ketamine_Single_Unit_R56\Rat315',xlabels{sess}))
%     segments=LK_Segment_Pulls_Further();
%     
%     close
%     load Filtered_Time_Stamped_Coordinates_Corrected_Ori.mat
%%
    %iterate through paws
    for i=1:2
        %iterate through phases
        
%         TS.Reach=nan(size((segments.(paws{i}).Reach)));
%         TS.Withdraw=nan(size((segments.(paws{i}).Withdraw)));
%         for col=1:width(segments.(paws{i}).Reach)
%             TS.Reach(~isnan(segments.(paws{i}).Reach{:,col}),col)=T3.Time_uSec(segments.(paws{i}).Reach{~isnan(segments.(paws{i}).Reach{:,col}),col});
%         end
%         
%         for col=1:width(segments.(paws{i}).Withdraw)
%             TS.Withdraw(~isnan(segments.(paws{i}).Withdraw{:,col}),col)=T3.Time_uSec(segments.(paws{i}).Withdraw{~isnan(segments.(paws{i}).Withdraw{:,col}),col});
%         end
%         
        
        for j=2:2
            
            
            
            %iterate through segments until end of phase
            %for col=0:width(segments.(paws{i}).(phases{j}))-1
            
            
            
            
            
            
            %get current segment name
            
            
            if isfield(enAct.(paws{i}),(phases{j}))
                [estParams, seqTrain] = postprocess(enAct.(paws{i}).(phases{j}).traj);
                
                %if strcmp(show,'on')
                
                
                plotEachDimVsTime(seqTrain, 'xorth', enAct.(paws{i}).(phases{j}).traj.binWidth, 'nPlotMax', 1000);
                
                
                
                %plot3D(seqTrain, 'xorth', 'dimsToPlot', 1:3, 'nPlotMax', 1000);
                
                set(gcf,'Position',get(0,'Screensize'))
                %if strcmp(currSegName,'Reach') || strcmp(currSegName,'Withdraw')
                %title(sprintf('Ensemble Behavior during %s Paw %s Phase',paws{i}, phases{j}))
                %else
                %title(sprintf('Ensemble Behavior during %s Phase', segmentNames{((j-1)*3)+col}))
                %end
                
                
                %end
                
                if strcmp(phases{j},'Reach')
                    figure
                    for trial=1:length(seqTrain)
                        
                        tsMs=(TS.Reach(enAct.(paws{i}).Reach.traj.seqTrain(trial).trialId,:))/(1e3);
                        bins=histcounts(tsMs,tsMs(1):enAct.(paws{i}).Reach.traj.binWidth:tsMs(end));
                        plot(seqTrain(trial).xorth(1,:),seqTrain(trial).xorth(2,:),'k')
                        hold on
                        
                        %[L,A,G]=find(bins)
                        locs=find(bins)
                        L=locs(1)
                        %check for duplicates in bins because wide
                        if isnan(segments.(paws{i}).Reach.Advance(enAct.(paws{i}).Reach.traj.seqTrain(trial).trialId)) && length(locs)==2
                            G=locs(2)
                        elseif isnan(segments.(paws{i}).Reach.Grasp(enAct.(paws{i}).Reach.traj.seqTrain(trial).trialId))&& length(locs)==2
                            A=locs(2)
                        elseif length(locs)==1
                            pass
                        else
                            A=locs(2)
                            G=locs(3)
                        end
                        scatter(seqTrain(trial).xorth(1,L),seqTrain(trial).xorth(2,L),'r')
                        hold on
                        %                         scatter(seqTrain(trial).xorth(1,A),seqTrain(trial).xorth(2,A),'g')
                        %                         hold on
                        %                         scatter(seqTrain(trial).xorth(1,G),seqTrain(trial).xorth(2,G),'b')
                        %                         hold on
                        
                        
                        %                          locs=find(bins);
                        %                         L=locs(1);
                        %                         A=locs(2);
                        %                         G=locs(3);
                        %                         plot(seqTrain(trial).xorth(1,L:A),seqTrain(trial).xorth(2,L:A),'r')
                        %                         hold on
                        %                         plot(seqTrain(trial).xorth(1,A:G),seqTrain(trial).xorth(2,A:G),'g')
                        %                         hold on
                        %                         plot(seqTrain(trial).xorth(1,G:G),seqTrain(trial).xorth(2,G:G),'b')
                        %                         hold on
                        %
                        
                    end
                elseif strcmp(phases{j},'Withdraw')
                    figure
                    for trial=1:2:length(seqTrain)
                        

                        plot(seqTrain(trial).xorth(1,:),seqTrain(trial).xorth(2,:),'k')
                        %plot3(seqTrain(trial).xorth(1,:),seqTrain(trial).xorth(2,:),seqTrain(trial).xorth(3,:),'.k')
                        hold on
                        
                        
                    end
                    
                    
                    for trial=1:2:length(seqTrain)
                        


                        %[push,pull]=find(bins)
                        scatter(seqTrain(trial).xorth(1,end),seqTrain(trial).xorth(2,end),'r','filled')
                        %scatter3(seqTrain(trial).xorth(1,end),seqTrain(trial).xorth(2,end),seqTrain(trial).xorth(3,end),'r','filled')
                        hold on
%                         scatter(seqTrain(trial).xorth(1,end),seqTrain(trial).xorth(2,1),'g','filled')
%                         hold on
                    end
                    
                    
                end
                hold off
                title(sprintf('2D Ensemble Behavior Before %s Paw Pulls',paws{i}))
                set(gcf,'Position',get(0,'Screensize'))
                
            end
        end
    end
end