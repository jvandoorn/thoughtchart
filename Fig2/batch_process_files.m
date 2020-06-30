% batch prcessing of meditation data;

% This section is to locate all the eeg files in the directory
directory = '~/Research/meditation_paper/Fig2/Preprocessed/';      % Full path of the directory to be searched in
files = dir([directory '*.set']);
numOfFiles = length(files);

% % Select files of interest
% count = 0;
% out = 0;
% for i=1:numOfFiles
%     if strcmp(task{1},files(i).name(end-5:end-4))
%         count=count+1; eegFile{count} = files(i).name;
%     elseif strcmp(task{2},files(i).name(end-5:end-4))
%         count=count+1; eegFile{count} = files(i).name;
%     elseif strcmp(task{3},files(i).name(end-5:end-4))
%         count=count+1; eegFile{count} = files(i).name;
%     elseif strcmp(task{4},files(i).name(end-5:end-4))
%         count=count+1; eegFile{count} = files(i).name;
%     else
%         out=out+1; excluded{out} = files(i).name;
%     end
% end

eegFile = {files.name};

% Estimate the Wpli for all EEGdata
for j=1:length(eegFile)
    if j == 5, continue; end
    disp(['Wpli for file ', int2str(j), ' of ', int2str(length(eegFile))]) % Updates are nice
    time_based_wpli_medEEG(eegFile{j}(1:end-4))
end

%% Looking at channel numbers for EEGdata
% for j = 1:length(EEG_file)
%    load([EEG_file{j} stringToBeFound]);
%    sizes (j,:) = size(Connect);
%    clear Connect;
% end
% histogram(sizes(:,1,1,1))
% xlabel('Channels'); ylabel('Subjects');
%
% A = find(sizes(:,1,1,1)>65);
% big_chan = EEG_file(A);
% categories = {'CTR', 'HT', 'SNY', 'VIP'};

%% save a list of channels here
% for j=1:file_count
%     file=[EEG_file{j} '.set'];
%     header=ft_read_header(file);
%     Label{j,1}=header.label(1:end-6);
%     Label{j,2}=EEG_file{j};
% end
% save('Channel_layout','Label')

