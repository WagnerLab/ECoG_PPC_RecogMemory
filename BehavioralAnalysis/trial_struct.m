clear all;

subjnum = '19';
expt = 'SS3';


if strcmp(subjnum,'16b') && strcmp(expt,'SS2')
    date = '19-Oct-2011';
    blocklist = {'SRb-26', 'SRb-28', 'SRb-30', 'SRb-32'};
elseif strcmp(subjnum,'17b') && strcmp(expt,'SS2')
    date = '20-Oct-2011';
    blocklist = { 'RHb0211-09', 'RHb0211-11'};
elseif strcmp(subjnum,'18') && strcmp(expt,'SS2')
    date = '20-Oct-2011';
    blocklist = {'MD0311-15', 'MD0311-17'};
elseif strcmp(subjnum,'19') && strcmp(expt,'SS3')
    date = '19-Oct-2011';
    blocklist = {'RB-0911-66'};
else
    display('incorrect subject or experiment!')
    return
end

mainpath = ['/biac4/wagner/biac3/wagner7/ecog/subj' subjnum '/ecog/' expt '/'];
condnames = {...
    'all','HChits','LChits','HCcr','HCcr',...
    'hits','cr','misses','fa','old','new'};

if strcmp(expt,'SS3') ||strcmp(expt,'SS2')
    codes.all = [0:6];
    codes.HChits =[1];
    codes.LChits =[5];
    codes.HCcr =[2];
    codes.HCcr =[6];
    codes.hits = [1 5];
    codes.cr = [2 6];
    codes.misses = 3;
    codes.fa = 4;
    codes.old = [1 3 5];
    codes.new = [2 4 6];
    
elseif strcmp(expt,'PC1')
    
    
end

channels = [1:64];
for ch = channels
    channel = num2str(ch);
    
    data = [];
    data.subject = subjnum;
    data.channel = channel;
    data.trialdur = [-0.2 1];
    data.trials = [];
    data.time = [];
    data.Npoints = [];
    data.badtrials = [];
    data.session = [];
    data.freqs = [];
    data.mean_power = [];
    data.spectralpower = [];
    data.deltafreqs = [];
    data.thetafreqs = [];
    data.betafreqs = [];
    data.gammafreqs = [];
    
    try
        %channel = '15';
        display(sprintf('processing channel #%s',channel))
        
        for b=1:length(blocklist)
            % load file info
            
            data.parfile{b} = [mainpath 'RawData/' blocklist{b} '/parSubj' subjnum expt '.' date '.mat'];
            %load('/biac4/wagner/biac3/wagner7/ecog/subj16b/ecog/SS2/RawData/SRb-26/parSubj16bSS2.19-Oct-2011.mat')
            load(data.parfile{b})
            
            % load data
            zerosstr = num2str(zeros(1,2-numel(channel)));
            data.rawdatafile{b} = [mainpath 'CARData/' blocklist{b} '/CARiEEG' blocklist{b} '_' zerosstr channel '.mat'];
            load(data.rawdatafile{b})
            %load('/biac4/wagner/biac3/wagner7/ecog/subj16b/ecog/SS2/CARData/SRb-26/CARiEEGSRb-26_37.mat')
            
            zerosstr = num2str(zeros(1,3-numel(channel))')';
            data.amplitudefile{b} =[mainpath 'SpecData/' blocklist{b} '/amplitude_' blocklist{b} '_' zerosstr  channel '.mat'];
            % load power amplitude data
            load(data.amplitudefile{b})
            
            data.eventsfile{b} = [mainpath 'BehavData/pdioevents_' blocklist{b} '.mat'];
            load(data.eventsfile{b})
            % load events
            %load('/biac4/wagner/biac3/wagner7/ecog/subj16b/ecog/SS2/BehavData/pdioevents_SRb-26.mat')
            
            %%
            data.session = logical(vertcat(data.session,b*ones(numel(conds),1)));
            % trial labels
            
            if strcmp(expt,'SS3') ||strcmp(expt,'SS2')
                data.newtrials = logical(vertcat(data.newtrials,(conds == codes.new(1) |...
                    conds == codes.new(2) |conds == codes.new(3))));
                data.oldtrials = logical(vertcat(data.oldtrials,(conds == codes.old(1) |...
                    conds == codes.old(2) |conds == codes.old(3))));
                
                data.hittrials = logical(vertcat(data.hittrials,conds == codes.hits(1) |conds == codes.hits(2)));
                data.crtrials = logical(vertcat(data.crtrials,conds == codes.cr(1) |conds == codes.cr(2)));
                
                if strcmp(subjnum,'19')
                    data.HChittrials =  logical(vertcat(data.hittrials,conds == codes.HChits));
                    data.LChittrials =  logical(vertcat(data.hittrials,conds == codes.LChits));
                    data.HCcrtrials =  logical(vertcat(data.oldtrials,conds == codes.HCcr));
                    data.LCcrtrials =  logical(vertcat(data.oldtrials,conds == codes.LCcr));
                end
                
            elseif strcmp(expt,'PC1')
                
            end
            
            %% raw trials
            aft_win = data.trialdur(2);
            bef_win = -data.trialdur(1);
            bef_point= floor(bef_win * par.ieegrate);
            aft_point= ceil(aft_win * par.ieegrate);
            Npoints= bef_point + aft_point+1; %reading Npoints data point
            data.Npoints = Npoints;
            
            poststimbase = 0;
            
            win_base= floor(poststimbase * par.ieegrate);
            
            
            event_time =truestamps;
            
            % event points
            event_point= floor(event_time * par.ieegrate);
            id= (event_point - bef_point);
            % jd= (event_point + bef_point);
            jd= (event_point + aft_point); % changed from above. this is supposed to prevent event_points being beyond recording time. j.chen 07/23/10
            event_point(id<0)=[];
            event_point(jd>par.chanlength)=[];
            
            
            signal = wave;
            %trials= zeros(length(event_point),Npoints,'single');
            
            for eni=1:length(event_point);
                temp_trials(eni,:)= signal(event_point(eni)-bef_point:event_point(eni)+aft_point);
                %removing mean of the base line
                temp_trials(eni,:)= temp_trials(eni,:) - mean(signal(event_point(eni)-bef_point:event_point(eni)+ win_base));
            end
            data.trials = vertcat(data.trials,temp_trials);
            
            
            %% spectral power trials
            
            signal_power = amplitude.^2; % Signal Power
            smpling=par.ieegrate/par.compression;
            
            tStepN=size(amplitude,2);
            endT=tStepN/smpling;
            t=linspace(0,endT,tStepN);
            st=event_time;
            ed=st+aft_win;
            signal_powerEvent=[];
            for i=1:length(st);
                l=abs(t-st(i));
                stP(i)=find(l==min(l))+1;
                l=abs(t-ed(i));
                edP(i)=find(l==min(l))-1;
                signal_powerEvent=[signal_powerEvent signal_power(:,stP(i):edP(i))];
                % signal_powerEvent(:S:E,:=signal_powerEvent signal_power(stP(i),edP(i),:);
            end
            mean_power= mean(signal_powerEvent,2);
            data.mean_power(:,b) = mean_power;
            amplitude= signal_power./(mean_power*ones(1,size(signal_power,2))); % normalized by mean of power 4 each freq
            
            clear signal_powerEvent stP edP ed st tStepN endT t smpling
            
            event_point= floor(event_time * par.fs_comp);
            id= (event_point - bef_point);  % to make sure your events didn't start before recording
            jd= (event_point + aft_point);  % changed bef_point to aft_point amr (to make sure event didn't end after recording)
            event_point(id<0)=[];
            event_point(jd>size(amplitude,2))=[];
            data.tossedtrials = id<0|jd>size(amplitude,2);
            
            % Averaging ERSP segments
            erp_tmp= zeros(size(amplitude,1),Npoints,length(event_point),'single');
            % Pulling out each timepoint at which an event begins
            for eni=1:length(event_point);
                % Take window from before point to after point for each frequency
                % band for each event
                try
                    erp_tmp(:,:,eni)= amplitude(:,event_point(eni)-bef_point:event_point(eni)+aft_point);
                catch ME_ampl
                    data.badtrials = vertcat(data.badtrials,(b-1)*length(event_point)+eni);
                    continue
                end
            end
            
            data.spectralpower = cat(3,data.spectralpower,erp_tmp);
            
            
        end
        
        data.freqs = par.freq;
        data.deltafreqs = (data.freqs<4);
        data.thetafreqs = (data.freqs>4 & data.freqs<11);
        data.betafreqs = data.freqs>11 & data.freqs<30;
        data.gammafreqs = data.freqs>30;
        
        close all;
        f = figure;
        data.time = linspace(-bef_win,aft_win,Npoints);
        plot(data.time,mean(data.trials(logical(data.hittrials),:)),'r', 'linewidth',2)
        hold on; plot(data.time,mean(data.trials(logical(data.crtrials),:)),'b','linewidth',2)
        hold off
        axis tight
        hitstr = sprintf('hits n=%d',sum(data.hittrials));
        crstr = sprintf('cr n=%d',sum(data.crtrials));
        legend(hitstr,crstr)
        figname = sprintf('ERPch%shcr',channel);
        title(figname)
        
        savepath = [mainpath '/data_for_classification/' expt 'subj' subjnum 'ch' channel];
        print(f,'-dtiff',[savepath '_' figname])
        save(savepath,'data')
        
        clear data
    catch ME
        mesg = sprintf('Could not process channel #%s',channel);
        display(mesg)
        continue
    end
end
