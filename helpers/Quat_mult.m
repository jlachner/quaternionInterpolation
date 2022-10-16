% Quaternion product

function qq = Quat_mult(q1,q2)

qq = NaN(size(q1));

 s1 = q1(1); v1 = q1(2:4);
 s2 = q2(1); v2 = q2(2:4);
 qq(1:4) = [s1 * s2 - v1' * v2; s1 * v2 + s2 * v1 + cross(v1,v2)];
 
 if size(qq,1) > 4
     % this is a dual quat with qq(5:8) as dual part
     s1d = q1(5); v1d = q1(6:8);
     s2d = q2(5); v2d = q2(6:8);
     qq(5) = s1*s2d + s1d*s2 - dot(v1,v2d) - dot(v1d,v2);
     qq(6:8) = s1*v2d + s2*v1d + s1d*v2 + s2d*v1 + cross(v1,v2d) + cross(v1d,v2);
 end
end
