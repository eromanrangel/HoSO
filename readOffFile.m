function [vertices, faces] = readOffFile(fileName)
%
% INPUT
%   fileName: name of the .off file to be loaded.
%
% OUTPUT
%   faces  : list of facesangle elements
%   vertex : node vertexinatates
%

%% Open file
fid = fopen(fileName, 'r');
if fid < 0
    error(['Cannot open ' fileName '.']);
end
frewind(fid);

%%
str = fgets(fid);   %-1 if eof
if ~strcmp(str(1 : 3), 'OFF')
    error('The file is not a valid OFF format.');
end

str = fgets(fid);
[a, str] = strtok(str); nvert = str2num(a);
[a, str] = strtok(str); nface = str2num(a);

%% Read vertices
[A, cnt] = fscanf(fid, '%f %f %f', 3 * nvert);
if cnt ~= 3 * nvert
    warning('Problem in reading vertices. Wrong size!');
end
vertices = reshape(A, 3, cnt / 3)';

%% Read faces
[A, cnt] = fscanf(fid, '%d %d %d %d\n', 4 * nface);
if cnt ~= 4 * nface
    warning('Problem in reading faces. Wrong size!');
end
A = reshape(A, 4, cnt / 4);
faces = A(2 : 4, :)' + 1;

%% Close file and return
fclose(fid);

end
