% SYDE 572 - Lab 1

% Setup
clc;
close all;
clear; 

addpath('NN-KNN');

LINE_WEIGHT = 1;
STEP = 0.25;

% 2. Generating Clusters

A = LabClass(200,[5 10],[8 0;0 4]);
B = LabClass(200,[10 15],[8 0;0 4]);
C = LabClass(100,[5 10],[8 4;4 40]);
D = LabClass(200,[15 10],[8 0;0 8]);
E = LabClass(150,[10 5],[10 -5;-5 20]);

figure(1)
hold on
plot(A.Cluster(:,1), A.Cluster(:,2), 'r.');
plot(A.Contour(:,1), A.Contour(:,2), 'r');
plot(B.Cluster(:,1), B.Cluster(:,2), 'b.');
plot(B.Contour(:,1), B.Contour(:,2), 'b');
axis equal
hold off

figure(2)
hold on
plot(C.Cluster(:,1), C.Cluster(:,2), 'r.');
plot(C.Contour(:,1), C.Contour(:,2), 'r');
plot(D.Cluster(:,1), D.Cluster(:,2), 'b.');
plot(D.Contour(:,1), D.Contour(:,2), 'b');
plot(E.Cluster(:,1), E.Cluster(:,2), 'g.');
plot(E.Contour(:,1), E.Contour(:,2), 'g');
axis equal
hold off

% 3. Classifiers

% --AB--
figure(3)
hold on
plot(A.Cluster(:,1), A.Cluster(:,2), 'r.')
plot(A.Contour(:,1), A.Contour(:,2), 'r');
plot(B.Cluster(:,1), B.Cluster(:,2), 'b.')
plot(B.Contour(:,1), B.Contour(:,2), 'b');
axis equal

% NN
[AB_x, AB_y, AB_NN] = create2DGrid(STEP, A.Cluster, B.Cluster);
for i = 1:size(AB_x, 2)
    for j = 1:size(AB_y, 2)
        AB_NN(j,i) = nn(AB_x(i), AB_y(j), A.Cluster, B.Cluster);
    end
end
contour(AB_x, AB_y, AB_NN, LINE_WEIGHT, 'k');

% 5NN
[AB_x, AB_y, AB_5NN] = create2DGrid(STEP, A.Cluster, B.Cluster);
for i = 1:size(AB_x, 2)
    for j = 1:size(AB_y, 2)
        AB_5NN(j,i) = knn(AB_x(i), AB_y(j), A.Cluster, B.Cluster);
    end
end
contour(AB_x, AB_y, AB_5NN, LINE_WEIGHT, 'm');

% --CDE--
figure(4)
hold on
plot(C.Cluster(:,1), C.Cluster(:,2), 'r.');
plot(C.Contour(:,1), C.Contour(:,2), 'r');
plot(D.Cluster(:,1), D.Cluster(:,2), 'b.');
plot(D.Contour(:,1), D.Contour(:,2), 'b');
plot(E.Cluster(:,1), E.Cluster(:,2), 'g.');
plot(E.Contour(:,1), E.Contour(:,2), 'g');
axis equal

% NN
[CDE_x, CDE_y, CDE_NN] = create2DGrid(STEP, C.Cluster, D.Cluster, E.Cluster);
for i = 1:size(CDE_x, 2)
    for j = 1:size(CDE_y, 2)
        CDE_NN(j,i) = nn(CDE_x(i), CDE_y(j), C.Cluster, D.Cluster, E.Cluster);
    end
end
contour(CDE_x, CDE_y, CDE_NN, LINE_WEIGHT, 'k');

% 5NN
[CDE_x, CDE_y, CDE_5NN] = create2DGrid(STEP, C.Cluster, D.Cluster, E.Cluster);
for i = 1:size(CDE_x, 2)
    for j = 1:size(CDE_y, 2)
        CDE_5NN(j,i) = knn(CDE_x(i), CDE_y(j), C.Cluster, D.Cluster, E.Cluster);
    end
end
contour(CDE_x, CDE_y, CDE_5NN, LINE_WEIGHT, 'm');


% 4. Error Analysis

% Generate Test Data - New Cluster
A_Test = LabClass(A.N,A.Mu,A.Sigma);
B_Test = LabClass(B.N,B.Mu,B.Sigma);
C_Test = LabClass(C.N,C.Mu,C.Sigma);
D_Test = LabClass(D.N,D.Mu,D.Sigma);
E_Test = LabClass(E.N,E.Mu,E.Sigma);

% Case Test Clusters
AB_Test = [[A_Test.Cluster, ones(A_Test.N, 1)*1];
                   [B_Test.Cluster, ones(B_Test.N, 1)*2]];
CDE_Test = [[C_Test.Cluster, ones(C_Test.N, 1)*1]; 
                    [D_Test.Cluster, ones(D_Test.N, 1)*2]; 
                    [E_Test.Cluster, ones(E_Test.N, 1)*3]];

% Clusters With Associations
test_AB_NN = griddata(AB_x(1,:), AB_y(1,:), AB_NN, AB_Test(:,1), AB_Test(:,2), 'nearest');
test_AB_5NN = griddata(AB_x(1,:), AB_y(1,:), AB_5NN, AB_Test(:,1), AB_Test(:,2), 'nearest');
test_CDE_NN = griddata(CDE_x(1,:), CDE_y(1,:), CDE_NN, CDE_Test(:,1), CDE_Test(:,2), 'nearest');
test_CDE_5NN = griddata(CDE_x(1,:), CDE_y(1,:), CDE_5NN, CDE_Test(:,1), CDE_Test(:,2), 'nearest');

% Error
err_AB_NN = perr(AB_Test(:,3), test_AB_NN);
err_AB_5NN = perr(AB_Test(:,3), test_AB_5NN);
err_CDE_NN = perr(CDE_Test(:,3), test_CDE_NN);
err_CDE_5NN = perr(CDE_Test(:,3), test_CDE_5NN);

% Confusion Matrices
conf_AB_NN = confusionmat(AB_Test(:,3), test_AB_NN);
conf_AB_5NN = confusionmat(AB_Test(:,3), test_AB_5NN);
conf_CDE_NN = confusionmat(CDE_Test(:,3), test_CDE_NN);
conf_CDE_5NN = confusionmat(CDE_Test(:,3), test_CDE_5NN);

figure(5)
confusionchart(conf_AB_NN)
figure(6)
confusionchart(conf_AB_5NN)
figure(7)
confusionchart(conf_CDE_NN)
figure(8)
confusionchart(conf_CDE_5NN)