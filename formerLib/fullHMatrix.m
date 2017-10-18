function  [H] = fullHMatrix (nodeMap)
% genrerate the measurement matrix of full -linked schedule
% @todo only support 2d case
nodeAmount  =  nodeMap.nodeAmount;
dim  = length(nodeMap.X)/nodeAmount;
if(dim~=2 && dim ~=3)
    error('dimonsion error');
end
measureSet =  genMeasureSet(nodeAmount,nchoosek(nodeAmount,2),1);

H=[];
for i = 1:size(measureSet,1)
%    if i == 12
%     disp (' ');
%    end
   node1      = measureSet(i,1);
   node2      = measureSet(i,2);

   position1Index  =  dim*(node1-1)+1:dim*node1;
   position1       = nodeMap.X(position1Index);

   position2Index  =  dim*(node2-1)+1:dim*node2;
   position2       = nodeMap.X(position2Index);


   Hs          = zeros(1,dim*nodeMap.nodeAmount);
   theta      = direction(position1,position2);
   if(dim == 2 )
        Hs([2*node1-1,2*node1,2*node2-1,2*node2])  = [cos(theta),sin(theta),-cos(theta),-sin(theta)];
   else
       phi        = theta(2);
       theta      = theta(1);
       Hs([position1Index,position2Index])  =  [cos(theta)*sin(phi),sin(theta)*sin(phi),cos(phi), -cos(theta)*sin(phi),-sin(theta)*sin(phi),-cos(phi)];
   end
   H          =[H;Hs];
end

