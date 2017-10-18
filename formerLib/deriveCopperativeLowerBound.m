H = [];
schedule  = genMeasureSet(nodeAmount,nodeAmount*(nodeAmount-1)/2,1); 
for j =1:nodeAmount*(nodeAmount-1)/2
   node1      = schedule(j,1);
   node2      = schedule(j,2);
   if(node1~=node2)
         position1  = [nodeMap.X(2*node1-1),nodeMap.X(2*node1)];
         position2  = [nodeMap.X(2*node2-1),nodeMap.X(2*node2)];
         H_r          = zeros(1,2*nodeMap.nodeAmount);
         theta      = direction(position1,position2);
         H_r([2*node1-1,2*node1,2*node2-1,2*node2])  = [cos(theta),sin(theta),-cos(theta),-sin(theta)];
         H          = [H;H_r]; 
   end
end 

Q        =  nodeMap.Q;

P = result.covariance(:,:,3)-eye(size(result.covariance(:,:,end)))*nodeMap.Q;

% trace(P-P*H'*(eye(size(H*H'))*nodeMap.sigmaD(1)+H*P*H')^(-1)*H*P+eye(size(P))*nodeMap.Q)
trace(P)

P = result.covariance(:,:,2)-eye(size(result.covariance(:,:,end)))*nodeMap.Q;

trace(P-P*H'*(eye(size(H*H'))*nodeMap.sigmaD(1)+H*P*H')^(-1)*H*P+eye(size(P))*nodeMap.Q)
% trace(P)