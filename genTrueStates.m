function [Xs,measurements,truevalues] = genTrueStates(X0,ts,paras)
% generate true state 

% truevalues :
    % thetas
    % omegas
    % accs
    % gps
    % baro
    % mag
    % pit
%measurements:
    % omegas
    % accs
    % gps
    % baro
    % mag
    % pit
Xs = zeros(22,length(ts));
assert(ts(1)==0);
Xs(:,1) = X0;
measurements = struct();
truevalues = struct();
dT = ts(2)-ts(1);% must a linspace

% gen theta states 
trueDabs = genBias(ts,paras.SigmagyroBias);
omegas = 1*randn(3,length(ts))/180*pi;
filt   = [1,1,1,2,3,3,5,4,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];
filt   = filt/sum(filt);
for i =1:3 
    omegatemp = conv(omegas(i,:),filt);
    omegas(i,:) = omegatemp(1:size(omegas,2));
end
omegas = omegas(:,1:(length(ts)));
trueTheta  = dT*numint(omegas,2);
Qs = zeros(4,length(ts));
Qs(:,1) = X0(1:4);
for i = 2:length(ts)
    deltaTheta = omegas(:,i-1)*dT;
    if(norm(deltaTheta)>eps)
        deltaQ = [cos(norm(deltaTheta)/2);deltaTheta/norm(deltaTheta)*sin(norm(deltaTheta)/2)]';% should be i-1 or ?
    else 
        deltaQ = [1,0,0,0];
    end
    tempQ   =  quatmultiply(Qs(:,i-1)',deltaQ);
    Qs(:,i) = tempQ';
end
Xs(1:4,:) = Qs;
Xs(11:13,:) = trueDabs;
truevalues.omegas = omegas;
truevalues.thetas = trueTheta;
measurements.omegas = omegas+trueDabs(:,1:size(omegas,2)) + paras.Sigmagyro*randn(3,size(omegas,2));

% gen accelerate data
trueDvzs = genBias(ts,paras.SigmaaccBias);
% trueDvzs = trueDvzs(1,:);
trueDvzs(1:2,:) = trueDvzs(1:2,:)*0;
accs = 0.5*randn(3,length(ts));
filt   = [1,1,1,2,3,3,5,4,3,1,1,1,1];
filt   = filt/sum(filt);
for i =1:3 
    acctemp = conv(accs(i,:),filt);
    accs(i,:) = acctemp(1:size(accs,2));
end
accs = accs(:,1:(length(ts)));
truevalues.accs = accs;
measurements.accs = accs + trueDvzs(:,1:size(accs,2)) +  paras.Sigmaacc*randn(3,size(accs,2));
vels = zeros(3,length(ts));
vels(:,1) = X0(5:7);
for i = 1:size(accs,2)-1
    cbntemp =cbn(Qs(:,i));
    deltav = truevalues.accs(:,i) *dT;
    vels(:,i+1) =  vels(:,i)+ cbntemp* deltav;
end
poses = dT*numint(vels,2);
Xs(5:7,:) = vels;
Xs(8:10,:) = poses;
Xs(14,:) = trueDvzs(3,:);

% wind 
vwind = 0.9*randn(2,length(ts));
filt   = ones(1,500);
filt   = filt/sum(filt);
for i =1:2 
    vwindtemp = conv(vwind(i,:),filt);
    vwind(i,:) = vwindtemp(1:size(vwind,2));
end
% vwind = numint(vwind,2);
% plot(vwind');
Xs(15:16,:) =  vwind;

% mage and magb 
% mages = zeros(3,length(ts));
% magbs = zeros(3,length(ts));

magesNoise = paras.SigmamageBias*randn(3,length(ts));
mages =repmat( X0(17:19),1,length(ts))+numint(magesNoise,2);

magbsNoise = paras.SigmamagbBias*randn(3,length(ts));
magbs = repmat(X0(20:22),1,length(ts))+numint(magbsNoise,2);

Xs(17:19,:) = mages;
Xs(20:22,:) = magbs;

% other measurements

%% GPS
hgps0 = Hgps();
gpsmeasurements = zeros(5,length(ts));
for i =1 : length(ts)
    gpsmeasurements(:,i) = hgps0* Xs(:,i);
end
truevalues.gps = gpsmeasurements;

% can't gps provide Pd measurements?
wgps =  zeros(5,length(ts));
wgps(1:2,:) = paras.SigmaVne*randn(2,length(ts));
wgps(3,:) = paras.SigmaVd*randn(1,length(ts));
wgps(4:5,:) = paras.SigmaPne*randn(2,length(ts));
measurements.gps = gpsmeasurements +wgps;

%% barometer
hpre0 = Hpre();
barometerMeasurement = zeros(1,length(ts));
for i =1: length(ts)
    barometerMeasurement(i) = hpre0*Xs(:,i);
end
truevalues.baro = barometerMeasurement;
wpre =  paras.SigmaPd*randn(1,length(ts));
measurements.baro = barometerMeasurement +wpre;

%%Magnetometer
magMeasurements = zeros(3,length(ts));
for i = 1:length(ts)
    hmag0 = Hmag(Xs(:,i));
    magMeasurements(:,i) = hmag0*(Xs(:,i));
end
truevalues.mag = magMeasurements;
wmag = paras.Sigmamag*zeros(3,length(ts)); 
measurements.mag = magMeasurements+wmag;

%%pitot tube measurement
pitMeasurements = zeros(1,length(ts));
for i = 1: length(ts)
    htube0  = Htube(Xs(:,i));
    pitMeasurements(:,i) = htube0*Xs(:,i);
end
truevalues.pit = pitMeasurements;
wpit = paras.Sigmaeas*zeros(1,length(ts)); 
measurements.pit = pitMeasurements+wpit;