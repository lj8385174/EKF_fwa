function [result] = kalmanSimulation3d(nodeMap,schedule,stepCode,mode,velocity)
% 3d version of kalmansimulation
% simulate the kalman process under specific NodeMap and link schedule
% !This is not a general discrete-time kalman filter, it is just appliable
% to when transition matrix is I
% parameter:
% nodeMap: the nodeMap structure represents the nodes deployment
% schedule: the linkschedule data  ;
%           each row represents a link;
%           !Identity node index in one row means a null link
% stepCode: a result data component, @TODO deprecated
% mode : specify the amount of links established simutanously 
%        0(defualt): each time make one measurement 
%        another:   amount of the links 
% velocity: velocity is a vector to determine the increment of position in each time epoch
%  WARNING: it if after add the movement of velocity(1,:) when the measurement begins. So to ranging in the first place, one should make sure that velocity(1,:) =0 
%  @TODO  only utilize sigmaD(1)
if nargin ==3
    mode = 0;  % each time make one measurement
    velocity  = zeros(length(nodeMap.X),size(schedule,1));
elseif nargin ==4 
    if(mode == 0)
   	    velocity  = zeros(length(nodeMap.X),size(schedule,1));
    else
        steps = size(schedule,1);
        velocity = zeros(length(nodeMap.X),floor(steps/mode)+1);
    end
end

if mode ==0
    Positions =  nodeMap.X;
    steps = size(schedule,1);
    P     = zeros(3*nodeMap.nodeAmount,3*nodeMap.nodeAmount,steps+1);
    P(:,:,1)  = nodeMap.sigmaX;
    Cd       =  nodeMap.sigmaD(1)  ;
    Q        =  nodeMap.Q;
    
    for i = 1:steps
        Positions  = Positions + velocity(:,i);
        % constructing measurement matrix H
        node1      = schedule(i,1);
        node2      = schedule(i,2);
        if(node1~=node2)
            position1  = [Positions(3*node1-2),Positions(3*node1-1),Positions(3*node1)];
            position2  = [Positions(3*node2-2),Positions(3*node2-1),Positions(3*node2)];
            H          = zeros(1,3*nodeMap.nodeAmount);
            theta      = direction(position1,position2);
            phi        = theta(2);
            theta      = theta(1);
            H([3*node1-2,3*node1-1,3*node1,3*node2-2,3*node2-1,3*node2])  = [cos(theta)*sin(phi),sin(theta)*sin(phi),cos(phi), -cos(theta)*sin(phi),-sin(theta)*sin(phi),-cos(phi)];
            Pt          = P(:,:,i)+Q*eye(size(P(:,:,i)));
            K          = Pt *H'*(H*Pt*H'+Cd*eye(size(H,1)))^(-1);
            P(:,:,i+1) =(eye(size(K*H))-K*H)*Pt;
        else
            P(:,:,i+1) = P(:,:,i) + Q*eye(size( P(:,:,i) ));
        end
    end
    
    result        = struct('covariance',P,'schedule',schedule,'stepCode',stepCode,'avgTraceSeries',averageTraceSeries(traceSeries(P)));
else
    % if mode is not equal to 0, then mode is the amount of links for
    % each step
    Positions =  nodeMap.X;

    steps = size(schedule,1);
    
    Cd       =  nodeMap.sigmaD(1)  ;
    Q        =  nodeMap.Q;
    P     = zeros(3*nodeMap.nodeAmount,3*nodeMap.nodeAmount,ceil(steps/mode)+1);
    P(:,:,1)  = nodeMap.sigmaX;
    index =  1;
    indexV = 1; 
    for i = 1:mode:steps
        Positions  = Positions + velocity(:,indexV);
        indexV  = indexV+1;
        H = [];
        for j = i :min(steps,i+mode-1)
            node1      = schedule(j,1);
            node2      = schedule(j,2);
            if(node1~=node2)
                position1  = [Positions(3*node1-2),Positions(3*node1-1),Positions(3*node1)];
                position2  = [Positions(3*node2-2),Positions(3*node2-1),Positions(3*node2)];
                H_r        = zeros(1,3*nodeMap.nodeAmount);
                theta      = direction(position1,position2);
                phi        = theta(2);
                theta      = theta(1);
                H_r([3*node1-2,3*node1-1,3*node1,3*node2-2,3*node2-1,3*node2])  = [cos(theta)*sin(phi),sin(theta)*sin(phi),cos(phi), -cos(theta)*sin(phi),-sin(theta)*sin(phi),-cos(phi)];
                H          = [H;H_r];
            end
        end
        if(size(H)~=0)
            Pt          = P(:,:,index)+Q*eye(size(P(:,:,index)));
            K          = Pt *H'*(H*Pt*H'+Cd*eye(size(H,1)))^(-1);
            P(:,:,index+1)=(eye(size(K*H))-K*H)*Pt;
        else
            P(:,:,index+1) = P(:,:,index) + Q*eye(size( P(:,:,index) ));
        end
        index   = index  +1;
    end
    result        = struct('covariance',P,'schedule',schedule,'stepCode',stepCode,'avgTraceSeries',averageTraceSeries(traceSeries(P)));
end