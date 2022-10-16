% Quaternion exponential

function qq_new = Quat_exp(qq)


qq_new = NaN(size(qq));

if size(qq,1) <= 4
    % this is an ordinary quat
    % since this function is inverse to Quat_log, it should q(1)==0
    if norm(qq(2:4)) < 1e-10
        qq_new = [1; 0; 0; 0];
    else
        
        u = qq(2:4)/norm(qq(2:4));
        
        theta_new = norm(qq(2:4));
        
        qq_new = [cos(theta_new); u*sin(theta_new)];
    end
    
else
    % this is a dual quat
    if norm(qq(2:4)) < 1e-10       
        % no rotation
        theta_new = 0;
        if norm(qq(6:8)) < 1e-10   
            % no translation either
            qq_new(:) = [1; 0; 0; 0; 0; 0; 0; 0];
        else
            % something translates
            s0 = [0; 0; 0];
            s =  qq(6:8)/norm(qq(6:8));
            t = 2 * norm(qq(6:8));
            qq_new = Screw2DQuat(s,s0,theta_new,t);
        end
    else
        % something seems to be rotating
        s = qq(2:4) / norm(qq(2:4));
        theta_new = 2 * norm(qq(2:4));
        
        s0 = cross(s, qq(6:8)) / (theta_new / 2);
        t = 2 * dot(s, qq(6:8));
        
        qq_new = Screw2DQuat(s, s0, theta_new, t);
    end
    
    
end