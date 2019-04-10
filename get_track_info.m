% This function generates numbers of trials and arm number associated with each trail
% Author: Zhaonan Li
% Input: file name of posdata
% Output: a matrix of size (n, 2). n is the length of posdata
%         column one represents the track number 1-4 or -1.
%         column two represents the trail number n, n >= 1.
%         The result will be stored at trial_info, make sure you have this
%         folder in your current directory.

function f = get_track_info(visualize, save)
    posfile = uigetfile('projectedposdata', 'Select Pos File');
    posfile = char(strcat("projectedposdata/", posfile));
    assert(contains(posfile, 'Track'));

    load(posfile); 

    % n * 2 matrix, col1 is the average of x position, col2 is the average of y
    % position
    avg_pos = [sum(pos(:,[1 3]), 2) / 2, sum(pos(:,[2 4]), 2) / 2];

    % result, col1 is the track info, col2 is the number of trials%
    trials = zeros(length(avg_pos), 2);

    % auxiliary array used to store track number
    aux = zeros(length(avg_pos), 1);
    for i = 1:length(avg_pos)
        aux(i) = getTrackNumber(avg_pos(i,1), avg_pos(i,2));
    end

    pt = 1; % pointer points to the current position
    counter = 1; % counter for number of trials
    while pt < length(avg_pos)
        start = pt;
        isAborted = 0; % this value changes to 1 if the animal passes through the center point,
                       % i.e. tracknumber == -2 
        while pt < length(avg_pos) && aux(pt) ~= -1
            pt = pt + 1;
        end
        while pt < length(avg_pos) && (aux(pt) == -1 || aux(pt) == -2)
            if aux(pt) == -2
                isAborted = 1;
            end
            pt = pt + 1;
        end
        if aux(pt) == 0 && isAborted
            % aborted trial
            for j = start:pt
                trials(j,1) = -1;
                trials(j,2) = -1;
            end
        elseif aux(pt) == 0 && ~isAborted
            pt = pt + 1;
        else
            trajectory = aux(pt);
            while pt < length(avg_pos) && aux(pt) ~= 0
                pt = pt + 1;
            end
            for j = start:pt
                trials(j,1) = trajectory;
                trials(j,2) = counter;
            end
            counter = counter + 1;
        end
    end 
    
    % change zeros in the end of trial to negative ones
    index = 1;
    while index <= length(aux) && trials(index, 1) ~= 0
        index = index + 1;
    end
    if index < length(aux)
        trials(index:end, :) = -1;
    end
    
    if visualize
        % visualize the result     
        img = imread('Track.png');

        disp(size(avg_pos))

        imshow(img);
        hold on
        
        for i = 1:length(avg_pos)
            
            posx = avg_pos(i, 1);
            posy = avg_pos(i, 2);
            track_info = trials(i, 1);
            trial_number = trials(i, 2);
            if mod(trial_number, 2) == 0
                color = 'r+';
                if track_info == -1
                    color = 'g+';
                end
            else
                color = 'y+';
                if track_info == -1
                    color = 'b+';
                end
            end    
            plot(posx, posy, color);
            pause(0.001);
        end
    end
    if save
        filename_prefix = char(strrep(current_filename,'.mat','_Trials.mat'));
        save(char(strcat("trial_info/",filename_prefix)),'trials');
    end
    f = trials;
end


