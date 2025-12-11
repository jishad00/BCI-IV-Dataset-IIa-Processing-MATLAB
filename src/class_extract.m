function CLS = class_extract(subjectIndex, dataFolder, opts)
arguments
    subjectIndex (1,1) {mustBeNumeric}
    dataFolder (1,:) char
    opts.fs (1,1) double = 250 %Sampling frequency
    opts.fmin (1,1) double = 8  %Lower passband frequency
    opts.fmax (1,1) double = 30 %Upper passband frequency
    opts.ap (1,1) double = 0.1 %Maximum Passband ripple
    opts.aa (1,1) double = 60 %Minimum stopband attenuation
    opts.fa1 (1,1) double = 7;  %Lower stopband frequency
    opts.fa2 (1,1) double = 31; %Upper stopband frequency
    opts.epoch_delay_sec (1,1) double = 3
    opts.epoch_duration_sec (1,1) double = 3
    opts.channels (1,1) double = 22
    opts.saveTo (1,:) char = ''
end

% class_extract
% ---------------
% Load subject training and evaluation MAT files (A0xT.mat, A0xE.mat),
% apply bandpass filtering, and extract 3-second motor imagery epochs
% for each of the 4 classes.
%
% Usage example:
%   opts = struct('fs',250,'fmin',8,'fmax',30,'epoch_delay_sec',3,'epoch_duration_sec',3,'channels',22);
%   CLS = class_extract(1, fullfile(pwd,'data','BCICIV_2a_mat'), opts);
%
% Output:
%   CLS.data contains class-specific epochs.

% Build filenames
subE = fullfile(dataFolder, sprintf('A0%dE.mat', subjectIndex));
subT = fullfile(dataFolder, sprintf('A0%dT.mat', subjectIndex));

% Load and basic checks
if ~exist(subE,'file') || ~exist(subT,'file')
    error('Could not find subject files: %s or %s', subE, subT);
end
AE = load(subE);
AT = load(subT);

%Design filter
Ap = opts.ap; %Maximum Passband ripple
Aa = opts.aa;  %Minimum stopband attenuation
fp1 = opts.fmin;  %Lower passband frequency
fp2 = opts.fmax; %Upper passband frequency
fa1 = opts.fa1;  %Lower stopband frequency
fa2 = opts.fa2; %Upper stopband frequency
fs = opts.fs; %Sampling frequency

d = designfilt('bandpassfir','PassbandFrequency1',fp1, ...
    'PassbandFrequency2',fp2, 'StopbandFrequency1',fa1, ...
    'StopbandFrequency2',fa2, 'SampleRate',fs, ...
    'PassbandRipple',Ap,'StopbandAttenuation1',Aa, 'StopbandAttenuation2',Aa,...
    'DesignMethod','kaiserwin');

% filterd data
ch = opts.channels;
trT = length(AT.data);
trE = length(AE.data);
% Filtered signal for AT
for r = trT-5:trT
    for i = 1:ch
        FAT.data{1, r-(trT-6)}.X(:,i) = filtfilt(d, AT.data{1, r}.X(:,i));
    end
    FAT.data{1,r-(trT-6)}.trial = AT.data{1, r}.trial;
    FAT.data{1,r-(trT-6)}.y = AT.data{1, r}.y;
    FAT.data{1,r-(trT-6)}.fs = AT.data{1, r}.fs;
    FAT.data{1,r-(trT-6)}.classes = AT.data{1, r}.classes;
    FAT.data{1,r-(trT-6)}.artifacts = AT.data{1, r}.artifacts;
    FAT.data{1,r-(trT-6)}.gender = AT.data{1, r}.gender;
    FAT.data{1,r-(trT-6)}.age = AT.data{1, r}.age;
end

% Filtered signal for AE
for r = trE-5:trE
    for i = 1:ch
        FAE.data{1, r-(trE-6)}.X(:,i) = filtfilt(d, AE.data{1, r}.X(:,i));
    end
    FAE.data{1,r-(trE-6)}.trial = AE.data{1, r}.trial;
    FAE.data{1,r-(trE-6)}.y = AE.data{1, r}.y;
    FAE.data{1,r-(trE-6)}.fs = AE.data{1, r}.fs;
    FAE.data{1,r-(trE-6)}.classes = AE.data{1, r}.classes;
    FAE.data{1,r-(trE-6)}.artifacts = AE.data{1, r}.artifacts;
    FAE.data{1,r-(trE-6)}.gender = AE.data{1, r}.gender;
    FAE.data{1,r-(trE-6)}.age = AE.data{1, r}.age;
end
%% Subject data combined to single file
FA = FAT;
for i = 1:6
    FA.data{1, 6+i} = FAE.data{1, i};
end
%% Class extraction from Subject EEG data
run = 12;
trl = 48;
sampfreq = opts.fs;
delay = 3*sampfreq; % delay includes the time for beep, fixation cross and cue; refer timing scheme
duration = 3*sampfreq; % 3 second task specific EEG
% extracting class data
n = 1;
m = 1;
j = 1;
k = 1;
for r = 1:run
    for i = 1:trl
        x1 = FA.data{1, r}.y(i,1); %class
        x2 = FA.data{1, r}.trial(i,1); %trial sample start point
        if x1 == 1
            CLS.data{n,x1} = FA.data{1, r}.X(x2+delay:x2+delay+duration-1,:);
            n = n+1;
        end
        if x1 == 2
            CLS.data{m,x1} = FA.data{1, r}.X(x2+delay:x2+delay+duration-1,:);
            m = m+1;
        end
        if x1 == 3
            CLS.data{j,x1} = FA.data{1, r}.X(x2+delay:x2+delay+duration-1,:);
            j = j+1;
        end
        if x1 == 4
            CLS.data{k,x1} = FA.data{1, r}.X(x2+delay:x2+delay+duration-1,:);
            k = k+1;
        end

    end
end

