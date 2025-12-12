%% Lab 14: Singular Value Decomposition and Image Compression

%% Task 1: 
%% 2x2 matrix

clear;
t=linspace(0,2*pi,100);
X=[cos(t);sin(t)];
subplot(2,2,1);
hold on;
plot(X(1,:),X(2,:),'b');
quiver(0,0,1,0,0,'r');
quiver(0,0,0,1,0,'g');
axis equal
title('Unit circle')
hold off;

%% Task 2: 
A = [ 2, 1; -1, 1 ];
[U,S,V] = svd(A);
U'*U
V'*V

%% Task 3: 
VX=V'*X;
subplot(2,2,2)
hold on;
plot(VX(1,:),VX(2,:),'b');
quiver(0,0,V(1,1),V(1,2),0,'r');
quiver(0,0,V(2,1),V(2,2),0,'g');
axis equal
title('Multiplied by matrix V^T')
hold off;

%% Task 4:
SVX = S*VX;
subplot(2,2,3);
hold on;
plot(SVX(1,:),SVX(2,:),'b');
quiver(0,0,S(1,1)*V(1,1),S(2,2)*V(1,2),0,'r');
quiver(0,0,S(1,1)*V(2,1),S(2,2)*V(2,2),0,'g');
axis equal
title('Multiplied by matrix \Sigma V^T')
hold off;

%% Task 5:
AX = U*SVX;
subplot(2,2,4)
hold on;
plot(AX(1,:),AX(2,:),'b');
quiver(0,0,U(1,1)*S(1,1)*V(1,1)+U(1,2)*S(2,2)*V(1,2),U(2,1)*S(1,1)*V(1,1)+...
    U(2,2)*S(2,2)*V(1,2),0,'r');
quiver(0,0,U(1,1)*S(1,1)*V(2,1)+U(1,2)*S(2,2)*V(2,2),U(2,1)*S(1,1)*V(2,1)+...
    U(2,2)*S(2,2)*V(2,2),0,'g');
axis equal
title('Multiplied by matrix U\Sigma V^T=A')
hold off;

%% Task 6:
%% Modified SVD
U1(:,1)=U(:,1);
U1(:,2)=-U(:,2);
V1(:,1)=V(:,1);
V1(:,2)=-V(:,2);

disp("If the determinant is equal to -1 it causes a reflection.")

disp("We see that that is the case for U and V.")
det_U = det(U)
det_V = det(V)

disp("With U1 and V2 we see that the det is 1, meaning it doesn't " + ...
    "cause a reflection.")
det_U1 = det(U1)
det_V1 = det(V1)

disp("We can see that U1 and V1 can still be used to construct A by "+ ...
    "subtracting A from U1\SigmaV^T and getting an answer close to 0")
U1*S*V1'-A

AX1 = U1*S*V1'*X;

figure;
subplot(2,2,1);
hold on;
plot(X(1,:),X(2,:),'b');
quiver(0,0,1,0,0,'r');
quiver(0,0,0,1,0,'g');
axis equal
title('Unit circle')
hold off;

VX1=V1'*X;
subplot(2,2,2)
hold on;
plot(VX1(1,:),VX1(2,:),'b');
quiver(0,0,V1(1,1),V1(1,2),0,'r');
quiver(0,0,V1(2,1),V1(2,2),0,'g');
axis equal
title('Multiplied by matrix V1^T')
hold off;

UX1=U1'*X;
subplot(2,2,3)
hold on;
plot(UX1(1,:),UX1(2,:),'b');
quiver(0,0,U1(1,1),U1(1,2),0,'r');
quiver(0,0,U1(2,1),U1(2,2),0,'g');
axis equal
title('Multiplied by matrix U1^T')
hold off;

subplot(2,2,4)
hold on;
plot(AX1(1,:),AX1(2,:),'b');
quiver(0,0,U1(1,1)*S(1,1)*V1(1,1)+U1(1,2)*S(2,2)*V1(1,2),U1(2,1)*S(1,1)*...
    V1(1,1)+U1(2,2)*S(2,2)*V1(1,2),0,'r');
quiver(0,0,U1(1,1)*S(1,1)*V1(2,1)+U1(1,2)*S(2,2)*V1(2,2),U1(2,1)*S(1,1)*...
    V1(2,1)+U1(2,2)*S(2,2)*V1(2,2),0,'g');
axis equal
title('Multiplied by matrix U1\Sigma V1^T=A')
hold off;

%% Task 7:
%% Check
A*V-U*S

%% Task 8:
%% Image compression

% Creates a two-dimensional array with the dimensions equal to the dimensions of 
% the image 
clear;
ImJPG=imread('einstein.jpg');
figure;
imshow(ImJPG);

[m,n]=size(ImJPG);

%% Task 9: 
% Compute an SVD
[UIm,SIm,VIm]=svd(double(ImJPG));

%% Task 10:
% plot the singular values
figure;
plot(1:min(m,n),diag(SIm));

%% Task 11:
%% Create approximations to the image

% With 50, 100, and 150 singular values
for k=50:50:150
    ImJPG_comp=uint8(UIm(:,1:k)*SIm(1:k,1:k)*(VIm(:,1:k))');
    figure;
    imshow(ImJPG_comp)
    % compression percentage
    pct = 1 - (numel(UIm(:,1:k))+numel(VIm(:,1:k)*SIm(1:k,1:k)))/numel(ImJPG);
    fprintf('Compression percentage for %2.0f singular values: %8.3f\n',k, pct);
end;


%% Task 12:
%% Noise filtering

clear;
ImJPG=imread('checkers.pgm')
[m,n]=size(ImJPG);

% Add some noise to the image
ImJPG_Noisy=double(ImJPG)+50*(rand(m,n)-0.5*ones(m,n));
figure;
imshow(ImJPG);

figure;
imshow(uint8(ImJPG_Noisy));

%% Task 13:
[UIm,SIm,VIm]=svd(ImJPG_Noisy);

figure;
plot(1:min(m,n),diag(SIm),'ko');

%% Task 14:
for k=10:20:50
    ImJPG_comp=uint8(UIm(:,1:k)*SIm(1:k,1:k)*(VIm(:,1:k))');
    figure;
    imshow(ImJPG_comp)
    % compression percentage
    pct = 1 - (numel(UIm(:,1:k))+numel(VIm(:,1:k)*SIm(1:k,1:k)))/numel(ImJPG);
    fprintf('Compression percentage for %2.0f singular values: %8.3f\n',k, pct);
end;
