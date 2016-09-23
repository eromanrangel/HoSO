function o = example()
% Run this example on the accompaning file "tryOnMe.off" to compute a set
% of HoSO descriptors for a set of 3D vertices.
%
% The HoSO descriptor works as explained in our paper: Edgar Roman-Rangel,
% Diego Jimenez-Badillo, and Stephane Marchand-Maillet "Classification of 
% Archaeological Potsherds using Histograms of Spherical Orientations". 
% Submitted to JOCCH. 2016.
%
% Edgar Roman-Rangel. 2016.
%


%%
fileName = 'tryOnMe.off';
[vertices, ~] = readOffFile(fileName);
H = hoso3D(vertices);
dlmwrite([fileName(1 : end - 3), 'txt'], H);
o = 0;

end
