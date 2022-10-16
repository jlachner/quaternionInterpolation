% Inverse quaternion 

function q_inv = Quat_inv(q)

q_inv = NaN(size(q));

s = q(1);
v = q(2:4);
q_inv(1:4) = 1/(s^2 + v' * v)*[s; -v];

if size(q,1) > 4
    s_eps = q(5);
    v_eps = q(6:8);
    q_inv(5:8) = [s_eps; -v_eps];  % assuming that q was unit length
end
end