%%  Creation of Vertices, Faces, FaceVertexCData matrices
%
%   The possible objects are:
%   - 'Cone'
%   - 'Sphere'
%   - 'Cylinder'
%   - 'CoordinateSys'
%   - 'Arrow' (along z-axis)
%   - 'Arrow_w_Sphere'
%   - 'Elliptic_cone' (Requires the size of the X axis and Y axis of
%   the elliptic base: func_create_VFC_data('Elliptic_cone',12,x,y))
%   - 'Pyramide_updown' (Requires the size of the X axis and Y axis of
%   the rectangular base: func_create_VFC_data('Pyramide_updown',[],x,y))
%
%   Objects can be scaled afterwards by adapting the vertices-matrix
%
%   Standard color is grey [0.5,0.5,0.5] (except CoordinateSys)
%
%   Parameter:
%   - Object: Input string
%   - Partition: default is 36; Smaller val than 12 will be corrected to 12
%
% patch('Faces', F,...
%             'Vertices' ,V,...
%             'FaceVertexCData', C,...
%             'FaceC', 'flat',...
%             'EdgeColor','none');

function [V,F,C] = func_create_VFC_data(Object,Partition, varargin)

if ~(1 == exist('Object','var'))
    disp('kein geometrisches Object gewählt');
    return;
end

if ~(1 == exist('Partition','var'))
    Partition = 36;
elseif Partition < 12
    Partition = 12;
else
    Partition = ceil(Partition);
end


func = str2func(Object);
[V,F,C] = func(Partition,varargin{:});

end

function [vert, fac, CData] = Box(Partition)
xLen = 0.3;
yLen = 1;
zLen = 0.15;
vert = [0 0 0; xLen 0 0; xLen yLen 0; 0 yLen 0; 0 0 zLen; xLen 0 zLen; xLen yLen zLen; 0 yLen zLen];
fac = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
CData = 0.5*ones(size(vert));

end

function [vertices,faces,CData] = Cone(Partition)

vertices = zeros(2+Partition,3);
faces = zeros(2*Partition,3);

vertices(1+Partition,:) = [0,0,0];
vertices(2+Partition,:) = [0,0,1];
for i = 1:Partition
    phi = 2*pi/Partition*i;
    vertices(i,:) = [cos(phi),sin(phi),0];
end

for i = 1:(Partition-1)
    faces(i,:) = [i,i+1,1+Partition];
    faces(i+Partition,:) = [i,2+Partition,i+1];
end
faces(Partition,:) = [Partition,1,Partition+1];
faces(Partition*2,:) = [Partition,Partition+2,1];

CData = 0.5*ones(size(faces));

end

function [vertices, faces, CData] = Cylinder(Partition)

vertices = zeros(2+2*Partition,3);
vertices(1,:) = [0,0,0];
vertices(2+Partition,:) = [0,0,1];

for i = 1:Partition
    phi = 2*pi/Partition*i;
    vertices(i+1,:) = [cos(phi),sin(phi),0];
    vertices(i+2+Partition,:) = [cos(phi),sin(phi),1];
end

faces = zeros(4*Partition,3);
faces(Partition,:) = [1,Partition+1,2];
faces(Partition*2,:) = [1,2,Partition+1]+1+Partition;
faces(Partition*3,:) = [2,1+Partition,2+2*Partition];
faces(Partition*4,:) = [3+Partition,2,2+2*Partition];

for i = 1:Partition-1
    faces(i,:) = [1,i+1,i+2];
    faces(i+Partition,:) = [1,i+2,i+1]+1+Partition;
    faces(i+2*Partition,:) = [i+2,i+1,i+2+Partition];
    faces(i+3*Partition,:) = [i+2+Partition,i+3+Partition,i+2];
    
end

CData = 0.5*ones(size(faces));

end

function [V,F,C] = CoordinateSys(Partition)

[VKu,FKu,CKu] = Sphere(Partition);      % Sphere with radius 1

VKu = VKu*diag([0.9,0.9,0.9]);          % Change sphere size

[VZ,FZ,CZ] = Cylinder(Partition);       % Master-cylinder (radius = 1, height = 1)

% Colors
CZ1 = 2*CZ*diag([0,0.4470,0.7410]);        
CZ2 = 2*CZ*diag([0.9290,0.6940,0.1250]);        
CZ3 = 2*CZ*diag([0.6350,0.0780,0.1840]);      

VZ1 = VZ*diag([0.4,0.4,8]);     % Dimensions for cylinder 1 (z-axis)
VZ2 = VZ1*[1,0,0;0,0,1;0,1,0];  % Cylinder 2 through turning cylinder 1 (y-axis)
VZ3 = VZ1*[0,0,1;0,1,0;1,0,0];  % Cylinder 3 through turning cylinder 1 (x-axis)

[VKe,FKe,CKe] = Cone(Partition);                    % Master-cone 

CKe1 = 2*CKe*diag([0,0.4470,0.7410]);               % Color for arrow (z-axis)
CKe2 = 2*CKe*diag([0.9290,0.6940,0.1250]);          % Color for arrow (y-axis)
CKe3 = 2*CKe*diag([0.6350,0.0780,0.1840]);          % Color for arrow (x-axis)

VKe1 = VKe*diag([0.8,0.8,2])+ones(size(VKe))*diag([0,0,8]); % Arrow 1 orientation and adapt dimensions 
VKe2 = VKe1*[1,0,0;0,0,1;0,1,0];                            % Adapt arrow 2 by rotation of arrow 1 
VKe3 = VKe1*[0,0,1;0,1,0;1,0,0];                            % Adapt arrow 2 by rotation of arrow 1 

% Create patch
V = cat(1,VKu,VZ1,VZ2,VZ3,VKe1,VKe2,VKe3);
F = cat(1,FKu,FZ+size(VKu,1),FZ+size(VKu,1)+size(VZ1,1),FZ+size(VKu,1)+2*size(VZ1,1),...
    FKe+size(VKu,1)+3*size(VZ1,1),FKe+size(VKu,1)+3*size(VZ1,1)+size(VKe,1),...
    FKe+size(VKu,1)+3*size(VZ1,1)+2*size(VKe,1));
C = cat(1,CKu,CZ1,CZ2,CZ3,CKe1,CKe2,CKe3);

% Scale arrow lengths to 1 
V = V/max(max(V));

end


function [V,F,C] = Arrow(Partition)

[VZ,FZ,CZ] = Cylinder(Partition);  

CZ1 = 2*CZ*diag([0,0,1]);        
VZ1 = VZ*diag([0.4,0.4,7]);    

[VKe,FKe,CKe] = Cone(Partition);     
CKe1 = 2*CKe*diag([0,0,1]);      
VKe1 = VKe*diag([0.8,0.8,3])+ones(size(VKe))*diag([0,0,7]); 

% Create patch
V = cat(1,VZ1,VKe1);
F = cat(1,FZ,FKe+size(VZ1,1));
C = cat(1,CZ1,CKe1);

% Scale arrow lengths to 1 
V = V/max(max(V));

end


function [V,F,C] = Arrow_w_Sphere(Partition)

[VKu,FKu,CKu] = Sphere(Partition);     
VKu = VKu*diag([0.9,0.9,0.9]); 
CKu = repmat([1,0,0],size(CKu,1),1);

[VZ,FZ,CZ] = Cylinder(Partition);   

CZ1 = 2*CZ*diag([1,0,0]);        
VZ1 = VZ*diag([0.4,0.4,8]);    

[VKe,FKe,CKe] = Cone(Partition);    
CKe1 = 2*CKe*diag([1,0,0]);       
VKe1 = VKe*diag([0.8,0.8,2])+ones(size(VKe))*diag([0,0,8]); 

% Create patch
V = cat(1,VKu,VZ1,VKe1);
F = cat(1,FKu,FZ+size(VKu,1),FKe+size(VKu,1)+size(VZ1,1));
C = cat(1,CKu,CZ1,CKe1);


% Scale arrow lengths to 1 
V = V/max(max(V));

end


function [vertices,faces,CData] = Sphere(Partition)

vertices = zeros(2+Partition*(ceil(Partition/2)-1),3);
count = 1;
for j = 1:(ceil(Partition/2)-1)
    theta = pi/ceil(Partition/2)*j;
    for i = 1:Partition
        phi = 2*pi/Partition*i;
        vertices(count,:) = [sin(theta)*cos(phi),sin(theta)*sin(phi),cos(theta)];
        count = count + 1;
    end
end
vertices(count,:) = [0,0,1];
vertices(count+1,:) = [0,0,-1];

faces = zeros(Partition-1,3);

% Cover on top 
for i = 1:Partition-1
    faces(i,:) = [i,i+1,count];
end
faces = cat(1,faces,[i+1,1,count]);

% Body
for j = 1:(ceil(Partition/2)-2)
    for i = 1:Partition-1
        AddToindex(i,:) = [i+j*Partition,i+1+(j-1)*Partition,i+(j-1)*Partition];
    end
    faces = cat(1,faces,AddToindex);
    faces = cat(1,faces,[(j+1)*Partition,1+(j-1)*Partition,i+1+(j-1)*Partition]);
end
for j = 1:(ceil(Partition/2)-2)
    for i = 1:Partition-1
        AddToindex(i,:) = [i+j*Partition,i+j*Partition+1,i+1+(j-1)*Partition];
    end
    faces = cat(1,faces,AddToindex);
    faces = cat(1,faces,[(j+1)*Partition,1+j*Partition,1+(j-1)*Partition]);
end

% Cover on botton
for i = 1:Partition-1
    faces = cat(1,faces,[(j)*Partition+i+1,(j)*Partition+i,count+1]);
end
faces = cat(1,faces,[(j)*Partition+1,(j+1)*Partition,count+1]);


CData = 0.5*ones(size(faces));
end

function [vertices,faces,CData] = Cube(Partition)
    Partition = 3;
    vertices = zeros((Partition+1)^3 , 3);
    faces = ones(6 * 2 * Partition^2,3);
    counter = 0;
    for a = 0:1/Partition:1
        for b = 0:1/Partition:1
            for c = 0:1/Partition:1
                counter = counter +1;
                vertices(counter,:) = [a-0.5, b-0.5, c];
            end
        end
    end
    
    %faces
    t = Partition;
    for c = 0:t-1
        b = c * (t+1);
        for a = 1:t
            faces((2*t * c) + a,:) =        [b+a      ,b+a+1    ,b+t+a+1  ];
            faces((2*t * c) + t + a,:) =    [b+a+1    ,b+t+a+1  ,b+t+a+2  ];
            temp = (t+1)^2 * t;
            faces(t^2 * 2 + (2*t * c) + a,:) = [temp + b+a      ,temp + b+a+1    ,temp + b+t+a+1  ];
            faces(t^2 * 2 + (2*t * c) + t + a,:) = [temp + b+a+1    ,temp + b+t+a+1  ,temp + b+t+a+2  ];
        end
    end
   
    for b = 1:t
        for a = 1:t
            faces(4 * t^2 + a + (b-1)*2*t, :) = [ 1 + (a-1)*(t+1) + (b-1) * (t+1)^2 , 1 + a * (t+1) + (b-1) * (t+1)^2 , 1 + b*(t+1)^2 + (a-1) * (t+1)];
            faces(4 * t^2 + a + t + (b-1)*2*t, :) = [1 + a*(t+1) + (b-1)*(t+1)^2  , 1 + b*(t+1)^2 + (a-1) * (t+1), 1 + a*(t+1) + b*(t+1)^2];
            temp = t;
            faces(4 * t^2 + a + (b-1)*2*t + 2 * t^2, :) = [temp + 1 + (a-1)*(t+1) + (b-1) * (t+1)^2 , temp + 1 + a * (t+1) + (b-1) * (t+1)^2 , temp + 1 + b*(t+1)^2 + (a-1) * (t+1)];
            faces(4 * t^2 + a + t + (b-1)*2*t + 2 * t^2, :) = [temp + 1 + a*(t+1) + (b-1)*(t+1)^2  , temp + 1 + b*(t+1)^2 + (a-1) * (t+1), temp + 1 + a*(t+1) + b*(t+1)^2];
        end
    end
    
    for b = 1:t
        for a = 1:t
            faces(8 * t^2 + a + (b-1)*2*t, :) = [1 + (a-1) + (b-1)*(t+1)^2, 1 + a + (b-1)*(t+1)^2, 1 + (a-1) + b*(t+1)^2];
            faces(8 * t^2 + a + t + (b-1)*2*t, :) = [1 + a + (b-1)*(t+1)^2, 1 + (a-1) + b*(t+1)^2, 1 + a + b*(t+1)^2];
            temp = (t+1) * t;
            faces(8 * t^2 + a + (b-1)*2*t + 2 * t^2, :) = [temp + 1 + (a-1) + (b-1)*(t+1)^2, temp + 1 + a + (b-1)*(t+1)^2, temp + 1 + (a-1) + b*(t+1)^2];
            faces(8 * t^2 + a + t + (b-1)*2*t + 2 * t^2, :) = [temp + 1 + a + (b-1)*(t+1)^2, temp + 1 + (a-1) + b*(t+1)^2, temp + 1 + a + b*(t+1)^2];
        end
    end
    
    CData = 0.5*ones(size(faces));
end

function [vertices,faces,CData] = Elliptic_cone(Partition,varargin)
a = 1/2*varargin{1};
b = 1/2*varargin{2};

vertices = zeros(2+Partition,3);
faces = zeros(2*Partition,3);

vertices(1+Partition,:) = [0,0,1];
vertices(2+Partition,:) = [0,0,0];
for i = 1:Partition
    phi = 2*pi/Partition*i;
    vertices(i,:) = [a*cos(phi),b*sin(phi),1];
end

for i = 1:(Partition-1)
    faces(i,:) = [i,i+1,1+Partition];
    faces(i+Partition,:) = [i,2+Partition,i+1];
end
faces(Partition,:) = [Partition,1,Partition+1];
faces(Partition*2,:) = [Partition,Partition+2,1];

CData = 0.5*ones(size(faces));
end

function [vertices,faces,CData] = Pyramide_updown(~,varargin)
a = 1/2*varargin{1};
b = 1/2*varargin{2};

vertices(1,:) = [a b 1];
vertices(2,:) = [a -b 1];
vertices(3,:) = [-a -b 1];
vertices(4,:) = [-a b 1];
vertices(5,:) = [0 0 0];

i = 1:4;
faces = [i', mod(i',4)+1, 5*ones(4,1);...
    1 2 3; 1 3 4];
CData = 0.5*ones(size(faces));
end