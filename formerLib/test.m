%

close all 
Na       =   4  ; % 节点数目

Dim      =   2   ; % 坐标维数

CoIndex  =   5 ;  % 节点坐标倍乘因子，表示节点的分布范围

Granu  =   50 ; % 粒度，表示在多大的水平上去计算拓扑性能改善因子 

Q      =   diag(ones(Na*Dim,1)); %状态转移方差，误差来源

nodeMap  =  genMap(Na,Dim);
% nodeMap.X = [0;0;1;0;1;1;0;1];
nodeMap.X =  nodeMap.X* CoIndex;

H      =   fullHMatrix(nodeMap);
H1     =   getFullRankRowMatrix(H);

resQ   =   getResidualMatrix(Q,H1); 