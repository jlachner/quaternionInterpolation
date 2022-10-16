function q = func_restrictQuatsOnHemisphere(q)

q(:,q(1,:)<0) = -q(:,q(1,:)<0);