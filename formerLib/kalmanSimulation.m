function [result] = kalmanSimulation(nodeMap,schedule,stepCode,mode,ignoreCo)
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
% ignoreCo: ignore Corelated elements in covariance matrix
%        false: default
%  @TODO  only utilize sigmaD(1)
if nargin <=4
    ignoreCo =  false;
end
if nargin <=3
    
    mode = 0;  % each time make one measurement
end
if mode ==0
    step = size(schedule,1);
    P     = zeros(2*nodeMap.nodeAmount,2*nodeMap.nodeAmount,step+1);
    P(:,:,1)  = nodeMap.sigmaX;
    Cd       =  nodeMap.sigmaD(1)  ;
    Q        =  nodeMap.Q;
    
    for i = 1:step
        % constructing measurement matrix H
        node1      = schedule(i,1);
        node2      = schedule(i,2);
        if(node1~=node2)
            position1  = [nodeMap.X(2*node1-1),nodeMap.X(2*node1)];
            position2  = [nodeMap.X(2*node2-1),nodeMap.X(2*node2)];
            H          = zeros(1,2*nodeMap.nodeAmount);
            theta      = direction(position1,position2);
            H([2*node1-1,2*node1,2*node2-1,2*node2])  = [cos(theta),sin(theta),-cos(theta),-sin(theta)];
            Pt          = P(:,:,i)+Q*eye(size(P(:,:,i)));
            K          = Pt *H'*(H*Pt*H'+Cd*eye(size(H,1)))^(-1);
            P(:,:,i+1) =(eye(size(K*H))-K*H)*Pt;
            if (ignoreCo)
                P(:,:,i+1) = diag(diag( P(:,:,i+1) ));
            end
        else
            P(:,:,i+1) = P(:,:,i) + Q*eye(size( P(:,:,i) ));
            if (ignoreCo)
                P(:,:,i+1) = diag(diag( P(:,:,i+1) ));
            end
        end
    end
    
    result        = struct('covariance',P,'schedule',schedule,'stepCode',stepCode,'avgTraceSeries',averageTraceSeries(traceSeries(P)));
else
    % if mode is not equal to 0, then mode is the amount of links for
    % each step
    
    step = size(schedule,1);
    
    Cd       =  nodeMap.sigmaD(1)  ;
    Q        =  nodeMap.Q;
    P     = zeros(2*nodeMap.nodeAmount,2*nodeMap.nodeAmount,ceil(step/mode)+1);
    P(:,:,1)  = nodeMap.sigmaX;
    index =  1;
    for i = 1:mode:step
        H = [];
        for j = i :min(step,i+mode-1)
            node1      = schedule(j,1);
            node2      = schedule(j,2);
            if(node1~=node2)
                position1  = [nodeMap.X(2*node1-1),nodeMap.X(2*node1)];
                position2  = [nodeMap.X(2*node2-1),nodeMap.X(2*node2)];
                H_r        = zeros(1,2*nodeMap.nodeAmount);
                theta      = direction(position1,position2);
                H_r([2*node1-1,2*node1,2*node2-1,2*node2])  = [cos(theta),sin(theta),-cos(theta),-sin(theta)];
                H          = [H;H_r];
            end
        end
        if(size(H)~=0)
            Pt          = P(:,:,index)+Q*eye(size(P(:,:,index)));
            K          = Pt *H'*(H*Pt*H'+Cd*eye(size(H,1)))^(-1);
            P(:,:,index+1)=(eye(size(K*H))-K*H)*Pt;
            if (ignoreCo)
                P(:,:,index+1) = diag(diag( P(:,:,index+1) ));
            end
        else
            P(:,:,index+1) = P(:,:,index) + Q*eye(size( P(:,:,index) ));
            if (ignoreCo)
                P(:,:,index+1) = diag(diag( P(:,:,index+1) ));
            end
        end
        index   = index  +1;
    end
    result        = struct('covariance',P,'schedule',schedule,'stepCode',stepCode,'avgTraceSeries',averageTraceSeries(traceSeries(P)));
end