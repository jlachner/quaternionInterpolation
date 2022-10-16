%Four points = [P0,P1,P2,...,P4] = [[x0;y0;z0],[x1;y1;z1],...,[x4;y4;z4]]
%CC = [q1,q2,q3,...,qN,q2] mit N=no_of_segments-1

function [CC2] = Slerp(q1,q2,u)   %no_of_segments
%  no_of_intermediate_points = no_of_segments-1;
%  no_of_all_points = no_of_intermediate_points+2;
%  CC1 = zeros(4,no_of_all_points);
%  CC2 = CC1;
theta = acos(q1'*q2);
%for index=1:no_of_all_points
%u = 1/(no_of_all_points-1)*index + 1/(1-no_of_all_points);

%     %Method 1: no work!
%     for kk=1:4
%         q1invq2=Quat_mult(Quat_inv(q1),q2);
%         CC1(kk,index) = q1(kk)*exp(u*log(q1invq2(kk)));
%         %CC1(:,index) = Quat_mult(q1,(Quat_mult(Quat_inv(q1),q2)).^u);
%     end

%Method 2: work!
%CC2(:,index) = sin((1-u)*theta)/sin(theta)*q1+sin(u*theta)/sin(theta)*q2;
if theta <= eps
    CC2 = q1;
else
    CC2 = sin((1-u)*theta)/sin(theta)*q1+sin(u*theta)/sin(theta)*q2;
end
%end