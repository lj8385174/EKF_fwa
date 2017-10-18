% load('EKFTest_noMea.mat');
path(path,'./formerLib');
flights = [1];
leng =length(ts);
% leng =1000;
for i = flights
    % plot position result 
    figure(i);
    plot(ts(1:leng), Xest{i}(8:10,1:leng)' - Xs{i}(8:10,1:leng)');
    title('Pned');
    figure(i+2);
    plot(ts(1:leng), Xest{i}(5:7,1:leng)' - Xs{i}(5:7,1:leng)');
    title('Vned');
    figure(i+3);
    plot(ts(1:leng), Xest{i}(1:4,1:leng)' - Xs{i}(1:4,1:leng)');
    figure(i+4);
    plot(ts(1:leng), Xest{i}(15:16,1:leng)' - Xs{i}(15:16,1:leng)');
    title('Vwind');
    figure(i+5);
    plot(ts(1:leng), Xest{i}(17:19,1:leng)' - Xs{i}(17:19,1:leng)');
    title('Mage');
    figure(i+6);
    plot(ts(1:leng), Xest{i}(20:22,1:leng)' - Xs{i}(20:22,1:leng)');
    title('Magb');
    figure(i+7);
    plot(ts(1:leng), Xest{i}(1:4,1:leng)' - Xs{i}(1:4,1:leng)');
    title('Q');
    % legend 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22
    err = Xest{i}(8:10,:)' - Xs{i}(8:10,:)';
    disp(std(err));
    figure(i+1);
    plot(ts,traceSeries(Pest{i}(15:16,15:16,:)));
    figure(i+8);
    errs  = Xest{i}(15:16,:)' - Xs{i}(15:16,:)';
    plot(ts,sum(errs.^2,2));
    title('MSE');
end