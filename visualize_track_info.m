% visualize the result    
function f = visualize_track_info(avg_pos, trials)
img = imread('Track.png');

number_of_trials = max(trials(:, 2));

% disp(number_of_trials);

start_and_end_pos = zeros(number_of_trials,2);
for t = 1:number_of_trials
    trial_indices = find(trials(:, 2) == t);
    start_index = trial_indices(1);
    end_index = trial_indices(end);
    start_and_end_pos(t, :) = [start_index, end_index];
end

% disp(start_and_end_pos);

index = 1;
for trial_num_pt = 1:number_of_trials
        
     start_index = start_and_end_pos(trial_num_pt, 1);
     end_index = start_and_end_pos(trial_num_pt, 2);
          
     % plot aborted trial, if there's an aborted trial between two trials
     if index < start_index
        imshow(img);
        hold on
        title(char(strcat("aborted")));
        for j = index:start_index
            plot(avg_pos(j, 1), avg_pos(j, 2), 'b+');
            pause(0.001);
        end
        hold off
     end
     % plot trial
     imshow(img);
     hold on
     title(char(strcat("trial: ", string(trial_num_pt), ", track: ", string(trials(start_index,1)))));
     for j = start_index:end_index
        plot(avg_pos(j, 1), avg_pos(j, 2), 'r+');
        pause(0.001);
     end
     index = end_index + 1;
     hold off
end

end