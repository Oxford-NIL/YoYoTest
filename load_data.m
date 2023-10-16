% Code by Runbei Cheng, Oct 2023
% for the Oxford NIL YoYo Intermittent Recovery Test (Level 1) workload study.
% Matlab version: R2019b
% Email: runbei.cheng@eng.ox.ac.uk

clear
clc
close
warning('off','all')
%% Load metadata files
%Run this before using one of the data loading examples below

Rounds = ["FirstRound", "SecondRound"];
Metadata = struct();
for i = 1:length(Rounds)
    Round = Rounds(i);
    file_dir = strcat("./",Round,"/Metadata_",num2str(i),".csv");
    df = readtable(file_dir);
    Metadata.(Round) = df;
end
disp('Info included in the metadata file:')
disp(Metadata.('FirstRound').Properties.VariableNames)
disp('-------------------------------------------------')
disp('Metadata for subset 1')
display(Metadata.('FirstRound'))
disp('-------------------------------------------------')
disp('Metadata for subset 2')
display(Metadata.('SecondRound'))

%% Example: load subset 1 COSMED data
COSMED_1 = Load_Data(Metadata, "FirstRound", "COSMED", 0, 0, 0, 0);

Subjects_temp = convertCharsToStrings(fieldnames(COSMED_1));
Sample_Subject_idx = 1; % change this value to change sample data to display

disp('---------------------')
disp(strcat(num2str(length(Subjects_temp)), ' subjects loaded'))
disp('---------------------')
COSMED_column_names = COSMED_1.(Subjects_temp(Sample_Subject_idx)).Properties.VariableNames;
disp(strcat('list of COSMED variables ', num2str(length(COSMED_column_names)), ' in total):'))
disp(COSMED_column_names)
disp('---------------------')
disp("Here's a sample")
disp(Subjects_temp(Sample_Subject_idx))
disp(COSMED_1.(Subjects_temp(Sample_Subject_idx))(1:10,:))

%% Example: load subset 1 audio data
Audio_1 = Load_Data(Metadata, "FirstRound", "Audio", 0, 0, 0, 0);
Fs = 8000; % the sampling freaquency of all the audio in this dataset is 8kHz

Subjects_temp = convertCharsToStrings(fieldnames(Audio_1));
Sample_Subject_idx = 8; % change this value to change sample data to display

Audio_Sample = Audio_1.(Subjects_temp(Sample_Subject_idx));
T_Sample = linspace(0,length(Audio_Sample)/Fs,length(Audio_Sample));

disp('---------------------')
disp(strcat(num2str(length(Subjects_temp)), ' subjects loaded'))
disp('---------------------')
disp("Here's a sample")
plot(T_Sample(floor(325*length(Audio_Sample)/1000):floor(335*length(Audio_Sample)/1000))...
         ,Audio_Sample(floor(325*length(Audio_Sample)/1000):floor(335*length(Audio_Sample)/1000)))
xlabel('Time (s)')
ylabel('Power (AU)')
title(Subjects_temp(Sample_Subject_idx))

%% Example: load subset 1 RPE data ONLY for subjects with heart rate data
RPE_1_hr = Load_Data(Metadata, "FirstRound", "RPE", 1, 0, 0, 0);

Subjects_temp = convertCharsToStrings(fieldnames(RPE_1_hr));
Sample_Subject_idx = 1; % change this value to change sample data to display

disp('---------------------')
disp(strcat(num2str(length(Subjects_temp)), ' subjects loaded'))
disp('---------------------')
disp('list of RPE sheet variables:')
RPE_column_names = RPE_1_hr.(Subjects_temp(1)).Properties.VariableNames;
disp(RPE_column_names)
disp('---------------------')
disp("Here's a sample")
disp(Subjects_temp(Sample_Subject_idx))
disp(RPE_1_hr.(Subjects_temp(Sample_Subject_idx)))

%% Example: load subset 1 COSMED heart rate data 
COSMED_1_hr = Load_Data(Metadata, "FirstRound", "COSMED", 1, 0, 1, 0);
Subjects_temp = convertCharsToStrings(fieldnames(RPE_1_hr));
hr_1 = struct();
for i = 1:length(Subjects_temp)
    Subject = Subjects_temp(i);
    Time = COSMED_1_hr.(Subject).('t');
    hr = COSMED_1_hr.(Subject).('HR');
    hr_1.(Subject) = table(Time,hr);
end
disp('---------------------')
disp(strcat(num2str(length(Subjects_temp)), ' subjects loaded'))
disp('---------------------')
disp("Here's a sample")
disp(hr_1.(Subjects_temp(1))(1:10,:))

Sample_Subject_idx = 1;
% plot heart rate with RPE 
figure()
xlabel('Time (s)')
yyaxis left
plot(hr_1.(Subjects_temp(Sample_Subject_idx)).Time, hr_1.(Subjects_temp(Sample_Subject_idx)).hr)
ylabel('Heart Rate (bpm)')
yyaxis right
plot(RPE_1_hr.(Subjects_temp(Sample_Subject_idx)).Time, RPE_1_hr.(Subjects_temp(Sample_Subject_idx)).RPE)
ylabel('RPE')

%% Example: load subset 1 COSMED heart rate data with heart rate data artifact removal
% As can be seen in the last example, the heart rate data captured by Polar H10 can sometimes have '0 value' noise due to motion artifacts 
% Let's try removing that via extrapolation, to do so, simply set hr_artifact_removal = 1

COSMED_1_hr = Load_Data(Metadata, "FirstRound", "COSMED", 1, 0, 1, 1);
Subjects_temp = convertCharsToStrings(fieldnames(RPE_1_hr));
hr_1 = struct();
for i = 1:length(Subjects_temp)
    Subject = Subjects_temp(i);
    Time = COSMED_1_hr.(Subject).('t');
    hr = COSMED_1_hr.(Subject).('HR');
    hr_1.(Subject) = table(Time,hr);
end
disp('---------------------')
disp(strcat(num2str(length(Subjects_temp)), ' subjects loaded'))
disp('---------------------')
disp("Here's a sample")
disp(hr_1.(Subjects_temp(1))(1:10,:))

Sample_Subject_idx = 1; % change this value to change sample data to display

% plot heart rate with RPE
figure()
xlabel('Time (s)')
yyaxis left
plot(hr_1.(Subjects_temp(Sample_Subject_idx)).Time, hr_1.(Subjects_temp(Sample_Subject_idx)).hr)
ylabel('Heart Rate (bpm)')
yyaxis right
plot(RPE_1_hr.(Subjects_temp(Sample_Subject_idx)).Time, RPE_1_hr.(Subjects_temp(Sample_Subject_idx)).RPE)
ylabel('RPE')

%% function to load the three types of data files in this dataset
function data_out = Load_Data(metadata, subset, data_type, must_have_HR, must_have_audio, auto_crop_COSMED, hr_artifact_removal)
    % subset, set this value to load different subsets: "FirstRound" or "SecondRound"
    % data_type, set this value to load different types of data: "COSMED" or "RPE" or "Audio"
    % if must_have_HR = 1, only subjects with heart rate data will be loaded: 0 or 1
    % if must_have_audio = 1, only subjects with audio data will be loaded: 0 or 1
    % if auto_crop_COSMED = 1, only the COSMED data collected during the yoyo test is loaded with out any of the data before or after: 0 or 1
    Subjects = convertCharsToStrings(metadata.(subset).ID);
    Subject_load_idx = ones(size(Subjects));

    if data_type == "Audio"
        must_have_audio = 1;
    end

    if must_have_HR == 1
        Subject_load_idx = Subject_load_idx .* metadata.(subset).HeartRateIncluded_;
    end
    if must_have_audio == 1
        Subject_load_idx = Subject_load_idx .* metadata.(subset).AudioIncluded_;
    end
    
    Subjects_to_load = Subjects(logical(Subject_load_idx));
    data_out = struct();
    
    for i = 1:length(Subjects_to_load)
        Subject = Subjects_to_load(i);
        Subject_idx = Subjects == Subject;
        file_name = metadata.(subset).(strcat(data_type, "FileName"))(Subject_idx);
        disp(strcat('Loading ', file_name))
        file_dir = strcat("./",subset,"/",Subject,"/",file_name);
        if data_type == "Audio"
            [data,~] = audioread(file_dir);
        elseif data_type == "COSMED"
            % skip the second header row with detectImportOptions()
            opts = detectImportOptions(file_dir);
            opts.DataLines = 3;
            opts.VariableNamesLine = 1;
            if auto_crop_COSMED == 1
                YoYo_Start = metadata.(subset).("YoYoTestStartIndex")(Subject_idx);
                YoYo_End = metadata.(subset).("YoYoTestEndIndex")(Subject_idx);
                data = readtable(file_dir,opts);
                
                if hr_artifact_removal == 1
                    hr = data.HR;
                    Time = data.t;
                    hr = HR_zero_artifact_removal(hr,Time);
                    data.HR = hr;
                end
                
                data = data((YoYo_Start):(YoYo_End),:);
                Time = data.t;
                NewTime = Time - Time(1);
                data.t = NewTime;

            else
                data = readtable(file_dir,opts);
                if hr_artifact_removal == 1
                    hr = data.HR;
                    Time = data.t;
                    hr = HR_zero_artifact_removal(hr,Time);
                    data.HR = hr;
                end
            end
        elseif data_type == "RPE"
            data = readtable(file_dir);
        end
        data_out.(Subject) = data;
    end
end
% function to remove heart rate zero value motion artifact
function hr = HR_zero_artifact_removal(hr,t)
    Elements_idx = 1:length(hr);
    Zero_Elements = Elements_idx(hr==0);
    Non_Zero_Elements = Elements_idx(hr~=0);
    for i = 1:length(Zero_Elements)
        Zero_idx  = Zero_Elements(i);
        Below = Non_Zero_Elements(Non_Zero_Elements<Zero_idx);
        Below_idx = max(Below);

        Above = Non_Zero_Elements(Non_Zero_Elements>Zero_idx);
        Above_idx = min(Above);

        if isempty(Below_idx) && ~isempty(Above_idx)
            hr(Zero_idx) = hr(Above_idx);
        elseif isempty(Above_idx) && ~isempty(Below_idx)
            hr(Zero_idx) = hr(Below_idx);
        elseif ~isempty(Above_idx) && ~isempty(Below_idx)
            hr(Zero_idx) = round(hr(Below_idx) + (hr(Above_idx)-hr(Below_idx)) * (t(Zero_idx)-t(Below_idx)) / (t(Above_idx)-t(Below_idx)));
        end    
    end
end
