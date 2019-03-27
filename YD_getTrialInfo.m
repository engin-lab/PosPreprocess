% This function generates numbers of trials and arm number associated with each trail
% Author: Zhaonan Li
% Input: file name of posdata
% Output: a matrix of size (n, 2). n is the length of posdata
%         column one represents the track number 1-4 or -1.
%         column two represents the trail number n, n >= 1.
%         The result will be stored at trial_info, make sure you have this
%         folder in your current directory.

% read the position matrix %
mat_filename_dir = uigetdir(pwd, 'Select a folder');
file = dir(fullfile(mat_filename_dir, '*Track.mat'));
file_num = numel(file);

for i = 1:file_num
    current_filename = file(i).name;
    file_dir = strcat('/Volumes/YukiBackup/eeyd_a5GABA_Project/VideosAnalyzed/posDATA/data/projectedposdata/',current_filename);
    load(file_dir); 
    
    % coordinate of center %
    cx = 1116;
    cy = 1136;
    % radius of the circle %
    r = 800;

    ave_pos = [sum(pos(:,[1 3]), 2) / 2, sum(pos(:,[2 4]), 2) / 2];

    % result %
    trials = zeros(length(ave_pos), 2);

    aux = zeros(length(ave_pos), 1);
    for i = 1:length(ave_pos)
        aux(i) = getTrackNumber(ave_pos(i,1), ave_pos(i,2), cx, cy, r);
    end

    p1 = 1;
    t_idx = 1;
    while p1 < length(ave_pos)
        start = p1;
        while p1 < length(ave_pos) && aux(p1) ~= -1
            p1 = p1 + 1;
        end
        while p1 < length(ave_pos) && aux(p1) == -1
            p1 = p1 + 1;
        end
        if aux(p1) == 0
            for j = start:p1
                trials(j,1) = -1;
                trials(j,2) = -1;
            end
        else
            trajectory = aux(p1);
            while p1 < length(ave_pos) && aux(p1) ~= 0
                p1 = p1 + 1;
            end
            for j = start:p1
                trials(j,1) = trajectory;
                trials(j,2) = t_idx;
            end
            t_idx = t_idx + 1;
        end
    end

filename_prefix = char(strrep(current_filename,'.mat','_Trials.mat'));
save(char(strcat("trial_info/",filename_prefix)),'trials');
end


