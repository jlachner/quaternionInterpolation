% s can be a scalar or a vector with values between 0 and 1

function [C,BezPoints] = func_CubBez4D(FourQuats,s)

no_points = length(s);
C = NaN(size(FourQuats,1),no_points);

b00 = FourQuats(:,1);  
b01 = FourQuats(:,2);
b02 = FourQuats(:,3);
b03 = FourQuats(:,4);


for index = 1:no_points
    b11 = Slerp(b00,b01,s(index));
    b12 = Slerp(b01,b02,s(index));
    b13 = Slerp(b02,b03,s(index));
    b22 = Slerp(b11,b12,s(index));
    b23 = Slerp(b12,b13,s(index));
    b33 = Slerp(b22,b23,s(index));
    C(:,index) = b33;
end

if length(s) == 1
    BezPoints = {   b00, NaN,  NaN,  NaN;
                    b01, b11, NaN,  NaN;
                    b02, b12, b22, NaN;
                    b03, b13, b23, b33};
end



