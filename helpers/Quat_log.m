%Logarithm of a quaternion

function logq = Quat_log(q)

if size(q,1) <= 4
    % this is an ordinary quat
    w = q(1); u_times_sintheta = q(2:4);
    
       
    % According to Eberly: "Quaternion Algebra and Calculus"
    % Instead of dividing u_times_sintheta by sin(theta), rather normalize it
    u = u_times_sintheta/norm(u_times_sintheta);
    theta = acos(w);
    logq = [0; u*theta];
    
    % OBS! In this definition, the factor 1/2 IS NOT included
    
else
    % this is a dual quat
    
    % OBS! In this definition, the factor 1/2 IS included
    % Right now, I don't think this makes a difference as long as the inverse factor
    % is included in DQuat2Screw, too (believe it or not: it is).
    
    [s,s0,theta,t] = DQuat2Screw(q);
    logq = [0; s*theta/2; 0; 1/2*(s*t+cross(s0,s)*theta)];
end


