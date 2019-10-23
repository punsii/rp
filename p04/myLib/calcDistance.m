function [distance] = calcDistance(p1, p2)
%CALCDISTANCE Calculate distance between two points
%   Distance in lat/lot (which is stupid)
%   TODO: Convert p1/p2 from LAT/LON to meters

%V3
lat1 = p1(1);
lat2 = p2(1);
lon1 = p1(2);
lon2 = p2(2);
dH = (lat1 - lat2) * 111320; % meter
dW = (lon1 - lon2) * 40075000 * cos((lat1 + lat2)/2) / 360; %approximation

distance = sqrt(dH^2 + dW^2);

%V2
%     R = 6378.137; % Radius of earth in KM
%     dLat = p2(1) * pi / 180 - p1(1) * pi / 180;
%     dLon = p2(2) * pi / 180 - p2(2) * pi / 180;
%     a = sin(dLat/2) * sin(dLat/2) + ...
%     cos(p1(1) * pi / 180) * cos(p2(1) * pi / 180) * ...
%     sin(dLon/2) * sin(dLon/2);
%     c = 2 * atan2(sqrt(a), sqrt(1-a));
%     d = R * c;
%     distance = d * 1000; % meters
    
% V1
%     xdist = p2(1) - p1(1);
%     ydist = p2(2) - p1(2);
%     distance = sqrt(xdist^2 + ydist^2)
end
