%% This is the script for creating time based connectomes for a given EEG recording

%  modify row 9 to change the file name;
%  row 10 for data format(use 'set' instead of 'fdt' for EEGlab data)
%  row 12 for length of epoch in second
%  row 20 for labeling numbers of epoch included

% Segment length (one dimension in connectome) = 5 sec
%  - Because of cfg.toi being 0:overlap:1, only uses the first second.
%  Should be cfg.toi = 0:overlap:epoch;
% Overlap = 0.5 sec
% Within each segment time point, divided into 20 0.25sec trials, stacked
% to create one 3D wpli connectome.
% Min number of trials (default: 20) = more is better

function time_based_wpli_medEEG (restingfilename)
ft_info off;

%% set the parameter
Input_name=restingfilename; % add file name here , the output name will be the same as the input file name
file_name=[Input_name,'.set']; % add the EEG file format here
Output_name = ['~/Research/meditation_paper/Fig2/WPLI/' Input_name '.mat']; % output name with the date removed
header=ft_read_header(file_name); %load the header file
epoch=1;% add epoch here in second; this is the window
maxfreq = 50;
subsegment = epoch/20;

freq=header.Fs;% add data frequency here
channel_size=header.nChans; % add channel numbers here
overlap=0.5; % Movement of sliding window (default = 0.5)

%% create the configuration matrix
Sfreq=freq*epoch;
num_epoch=floor((header.nSamples/header.Fs)/epoch)-1;% sliding window in step 0.5
Connect=zeros(channel_size,channel_size,maxfreq,num_epoch);
clear cfg

for section=1:num_epoch
    disp(['Epoch: ' num2str(section) ' of ' num2str(num_epoch)]);
    cfg=[];
    cfg.continuous = 'yes';
    cfg.dataset = file_name;
    cfg.trialdef.eventtype  = '?';
    cfg.trialdef.eventtype = 'eeg';
    cfg.trialdef.eventvalue='eeg';
    
    if section==1
        for i=1:epoch/subsegment
            cfg.trl(i,1)=1*Sfreq+(i-1)*subsegment*freq;
            cfg.trl(i,2)=cfg.trl(i,1)+1*freq; % window size 0.5 seconds
            cfg.trl(i,3)=0;
        end
    else
        for i=1:epoch/subsegment
            cfg.trl(i,1)=1+(section-1)*Sfreq+(i-1)*subsegment*freq-overlap;
            cfg.trl(i,2)=cfg.trl(i,1)+1*freq; % window size 0.5 seconds
            cfg.trl(i,3)=0;
        end
    end
    cfg = ft_definetrial(cfg);
    cfg.event=[];
    for i=1:epoch/subsegment
        cfg.event{1,i}.sample=1+(section-1)*Sfreq+(i-1)*subsegment*freq-overlap;
        cfg.event{1,i}.offset=0;
        cfg.event{1,i}.duration=subsegment*freq;
        cfg.event{1,i}.type='eeg';
        cfg.event{1,i}.value='eeg';
    end
    %cfg.channels = 1:64;
    % pack the data into the configuration structure
    data=ft_preprocessing(cfg);
    
    % export the power specturm from the freq_wpli here if needed
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.foi          = 1:1:maxfreq;
    cfg.output       = 'powandcsd';
    cfg.t_ftimwin    = ones(length(cfg.foi),1)*overlap;
    cfg.toi          = 0:overlap:epoch; %Time of interest, default: 0:overlap:epoch
    cfg.tapsmofrq    = 2;
    cfg.keeptrials   = 'yes';
    cfg.pad          = 'nextpow2';
    freq_wpli        = ft_freqanalysis(cfg, data);
    
    % connectivity analysis
    cfg.method      = 'wpli_debiased';
    cfg.complex     = 'abs';
    clear connect_wpli
    connect_wpli    = ft_connectivityanalysis(cfg,freq_wpli);
    dim=2;
    
    % pack the output array into a matrix
    connect_temp=zeros(channel_size,channel_size,cfg.foi(end));
    temp_count=0;
    for n=1:channel_size
        temp_list=[];
        temp_list(:,:)=connect_wpli.wpli_debiasedspctrm(temp_count+1:temp_count+channel_size-n,:,dim);
        connect_temp(n,n+1:channel_size,:)=temp_list;
        temp_count=temp_count+channel_size-n;
    end
    connect_temp2=permute(connect_temp,[2 1 3])+connect_temp;
    
    Connect(:,:,:,section)=connect_temp2(1:channel_size,1:channel_size,:);
end
save(Output_name,'Connect')
end