% This a helper method that returns track number at given position
% author: Zhaonan Li
% input: position of the animal
% output: the track number n that the animal is currently located, 1<=n<=4
%         or 0, indicating the animal has returned home
%         [updated] or -1, indicating the animal has not reached one of the arms,
%         between home and center point
%         [updated] or -2, indicating the animal has not reached one of the
%         arms, bewteen center point and reward area

function f = getTrackNumber(x,y)
cx = 1116; % x-coordinate of center
cy = 1136; % y-coordinate of center
% we updated the value of r. passing through the door is considered as
% reaching the reward well.
r = 416;   % radius of the circle at (cx, cy), used to decide if the animal 
           % returns to one of the arms.
           
if y >= 1706 % home
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
        f = -2;
        return;
    end
end
f = -1;
end
