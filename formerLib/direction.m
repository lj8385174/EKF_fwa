function [ theta ] = direction( p1,p2 )
% direction of nodes p1 and p2. Support 2D and 3D, return the angle from p2 to p1
% In 2D case, theta will be a scaler indicates the angle from p2 to p1, which ranges from -pi~pi;
% In 3D case theta will be a vector, theta(1) is azimuthal angle (-pi~ pi)  and theta(2) is altitude angle(-pi/2~pi/2)
if(length(p1)==2)
    v  =  p1-p2;
    theta =  atan(v(2)/v(1));
    if(v(1)<0)
        if(v(2)<0)
            theta = theta- pi;
        else
            theta = theta+pi;
        end
    end
else
    p1  =  reshape(p1,1,[]);
    p2  =  reshape(p2,1,[]);
    origin  = zeros(1,2);
    v  = p1 - p2;
    vxy = v(1:2);
    theta  = direction(vxy,origin);
    r  =  sqrt(v(1)^2+v(2)^2);
    vrz =  [r,v(3)];
    phi = direction(vrz,origin);
    theta = [theta,pi/2-phi];% note the difinition of polar angle   
end

