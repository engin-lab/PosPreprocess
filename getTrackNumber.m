% This a helper method that returns track number at given position
% author: Zhaonan Li
% input: position of the animal
% output: the track number n that the animal is currently located, 1<=n<=4
%         or 0, indicating the animal has returned home
%         or -1, indicating the animal has not reached one the arms

function f = getTrackNumber(x,y)
cx = 1116; % x-coordinate of center
cy = 1136; % y-coordinate of center
r = 800;   % radius of the circle at (cx, cy), used to decide if the animal 
           % returns to one of the arms.
           
if y >= 1776
    f = 0; 
    return;
end
if y <= cy
    dis = sqrt((x-cx)^2 + (y-cy)^2);
    if dis > r
        h = x - cx;
        ang = radtodeg(acos(h/dis));
        if (x >= cx)
            if (ang <= 45) 
                f = 1;
                return;
            else
                f = 2;
                return;
            end
        else
            if (ang <= 135)
                f = 3;
                return;
            else
                f = 4;
                return;
            end
        end
    else
        f = -1;
        return;
    end
end
f = -1;
end
