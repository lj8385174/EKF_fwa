function [h]= showNodeMap(nodeMap,dim)
% Show the geometric map of nodes in the nodeMap
% dim is the dimonsion of nodes.
% h: the figure handle

if nargin == 1
	dim = 2;
end

if (dim~=2 && dim ~=3)
	error('I can only draw 2D or 3D figure');
end
h=figure();
if(dim == 2)
    X  =  nodeMap.X(1:2:end);
    Y  =  nodeMap.X(2:2:end);

    plot(X,Y,'ks','MarkerSize',10,'MarkerFaceColor',[0 0 0]);

    xinThisDimMax = max(X);
    xinThisDimMin = min(X);
    rangeXMin =  xinThisDimMin -0.5*(xinThisDimMax-xinThisDimMin);
    rangeXMax =  xinThisDimMax +0.5*(xinThisDimMax-xinThisDimMin);

    xinThisDimMax = max(Y);
    xinThisDimMin = min(Y);
    rangeYMin =  xinThisDimMin -0.5*(xinThisDimMax-xinThisDimMin);
    rangeYMax =  xinThisDimMax +0.5*(xinThisDimMax-xinThisDimMin);

    axis([rangeXMin,rangeXMax,rangeYMin,rangeYMax]);

    grid on;
    legend nodes
    %set(gca,'Xtick',['','',''],'Ytick',[]);
    set(gca,'TickLength',[ 0 0 ]);
    set(gca,'XTickLabel','','YTickLabel','');
    axis equal
else 
	X  =  nodeMap.X(1:3:end);
    Y  =  nodeMap.X(2:3:end);
    Z  =  nodeMap.X(3:3:end);
    plot3(X,Y,Z,'dr');
end