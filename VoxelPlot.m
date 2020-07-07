% check input matrix is 3D and single or double precision
if numDim(mat) ~= 3 || ~isfloat(mat)
    error('Input must be a 3D matrix in single or double precision.');
end

% set literals
num_req_input_variables = 1;
transparency = 0.8;
axis_tight = false;
color_map = [1, 1, 0.4];    % yellow

% replace with user defined values if provided
if nargin < num_req_input_variables
    error('Incorrect number of inputs.');
elseif rem(nargin - num_req_input_variables, 2)
    error('Optional input parameters must be given as param, value pairs.');    
elseif ~isempty(varargin)
    for input_index = 1:2:length(varargin)
        switch varargin{input_index}
            case 'AxisTight'
                axis_tight = varargin{input_index + 1}; 
            case 'Color'
                color_map  = varargin{input_index + 1};                 
            case 'Transparency'
               transparency = varargin{input_index + 1};
            otherwise
                error('Unknown optional input.');
        end
    end
end

% scale to a max of 1
mat = mat ./ max(mat(:));

% create structure array containing coordinate and colour data for 3D image
[IMAGE_3D_DATA] = image3Ddata(mat);  

% threshold and select the voxels to display
voxel_num = (mat == 1);  
voxel_face_num = IMAGE_3D_DATA.voxel_patch_face_numbers(voxel_num, :);  
M_faces = IMAGE_3D_DATA.voxel_patch_faces(voxel_face_num, :);  
M_vertices = IMAGE_3D_DATA.corner_coordinates_columns_XYZ;  

% create a new figure with a white background
fig = figure;
set(fig, 'Color', [1, 1, 1]); 

% plot the voxels using patch
hp2 = patch('Faces', M_faces, 'Vertices', M_vertices, 'EdgeColor', ...
    'black', 'CData', IMAGE_3D_DATA.voxel_patch_CData(voxel_face_num,:), ...
    'FaceColor', 'flat');  

% set the tranparency
set(hp2, 'FaceAlpha', transparency);

% set the axes properties and colormap
view(45, 30); 
axis equal;
box on;
colormap(color_map); 
caxis([0, 1]); 
grid on;  

% add the axes labels
xlabel('y [voxels]');
ylabel('x [voxels]');
zlabel('z [voxels]');

% force the display to be the same size as mat
if ~axis_tight
    sz = size(mat);
    set(gca, 'XLim', [0.5, sz(2) + 0.5], ...
             'YLim', [0.5, sz(1) + 0.5], ...
             'ZLim', [0.5, sz(3) + 0.5]);
end