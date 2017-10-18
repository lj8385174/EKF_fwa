function [X0,paras,dT] = genparas(pos)
% Parameters for modeling 
% sampling interval
if nargin == 0 
    pos = [0,0,0];
end

dT= 0.3;

Q0   = [1,0,0,0];     % initial Quaternions
Pos0 = pos; % initial position 
Vel0 = [0,0,0]; % initial velocition 
Dab0  = [0,0,0]; % initial Gyro delta angle bias vector
Dvzb0 = 0;      % initial Accelerometer bias(Z axis)
Vwind0 = [0,0]; % initial wind speed in plane
Mage0  = [0,0,0];%initial Earth magnetic field 
Magb0  = [0,0,0]; % initial Magnetometer bias errors

X0 = [Q0,Vel0,Pos0,Dab0,Dvzb0,Vwind0,Mage0,Magb0]';

paras = struct();
paras.SigmaVne= 0.3;  %Velocity measurement noise in north-east (horizontal) direction.
paras.SigmaVd= 0.3;  %Velocity noise in down (vertical) direction
paras.SigmaPne= 0.5;  % Position noise in north-east (horizontal) direction
paras.SigmaPd = 1.25; %Position noise in down (vertical) direction, barometer
% paras.SigmaPdgps = 0.9; %Position noise in down (vertical) direction, barometer
paras.Sigmamag= 0.05;  %Magnetometer measurement noise
paras.Sigmagyro =  0.015; % Gyro process noise on each direction, corresponding to the sigma of  wb
paras.Sigmaacc  = 0.125; % Accelerometer process noise on each direction, corresponding to the sigma of wa.
paras.SigmagyroBias = 1e-11; % Gyro bias estimate process noise
paras.SigmaaccBias = 1e-11; %Accelerometer bias estimate process noise
paras.SigmamageBias = 0.0003e-5;  % Magnetometer earth frame offsets process noise
paras.SigmamagbBias = 0.0003e-5;  % Magnetometer body frame offsets process noise
paras.Sigmaeas = 1.4;  %Airspeed measurement noise.
paras.Sigmauwb = 0.08; % uwb measurement noise;


paras.Sigmadvzb  =  1e-5; % offest of z-velocity 
paras.Sigmawind  =  0.0001; %  wind speed noise 

paras.P0  = diag([0.1,0.1,0.1,0.1,0.2,0.2,0.4,3,3,4,0,0,0,0,0.3,0.3,0.1,0.1,0.1,0.1,0.1,0.1]); % initial covariance 
paras.Q   = zeros(18);
paras.Q(1:3,1:3) = eye(3)*paras.Sigmagyro;
paras.Q(4:6,4:6) = eye(3)*paras.Sigmaacc;
paras.Q(7:9,7:9)    = eye(3)*paras.SigmagyroBias;
paras.Q(10,10)      = eye(1)*paras.Sigmadvzb;% ? to be considered
paras.Q(11:12,11:12)   = eye(2)*paras.Sigmawind;
paras.Q(13:15,13:15)   = eye(3)*paras.SigmamageBias;
paras.Q(16:18,16:18)   = eye(3)*paras.SigmamagbBias;

paras.R  = zeros(10);
paras.R(1:2,1:2) = eye(2)*paras.SigmaVne;
paras.R(3,3)     = paras.SigmaVd;
paras.R(4:5,4:5) = eye(2)*paras.SigmaPne;
paras.R(6,6)     = paras.SigmaPd;
paras.R(7:9,7:9) = eye(3)*paras.Sigmamag; 
paras.R(10,10)   = paras.Sigmaeas;