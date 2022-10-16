% Convert a screw to a dual quaternion

function qq = Screw2DQuat(s, s0, theta, t)

qq = NaN(8,1);

qq(1) = cos(theta/2);
qq(2:4) = s * sin(theta/2);
qq(5) = -t/2 * sin(theta/2);
qq(6:8) = t/2 * s * cos(theta/2) + cross(s0,s) * sin(theta/2);

