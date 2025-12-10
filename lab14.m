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

A = [ 2, 1; -1, 1 ];
[U,S,V] = svd(A);
U'*U
V'*V

VX=V'*X;
subplot(2,2,2)
hold on;
plot(VX(1,:),VX(2,:),'b');
quiver(0,0,V(1,1),V(1,2),0,'r');
quiver(0,0,V(2,1),V(2,2),0,'g');
axis equal
title('Multiplied by matrix V^T')
hold off;


SVX = S*VX;
subplot(2,2,3);
hold on;
plot(SVX(1,:),SVX(2,:),'b');
quiver(0,0,S(1,1)*V(1,1),S(2,2)*V(1,2),0,'r');
quiver(0,0,S(1,1)*V(2,1),S(2,2)*V(2,2),0,'g');
axis equal
title('Multiplied by matrix \Sigma V^T')
hold off;

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


%% Modified SVD
U1(:,1)=U(:,1);
U1(:,2)=-U(:,2);
V1(:,1)=V(:,1);
V1(:,2)=-V(:,2);

U1*S*V1'-A

%% Check
A*V-U*S


%% Image compression

% Creates a two-dimensional array with the dimensions equal to the dimensions of 
% the image 
clear;
ImJPG=imread('einstein.jpg');
figure;
imshow(ImJPG);

[m,n]=size(ImJPG);

% Compute an SVD

[UIm,SIm,VIm]=svd(double(ImJPG));

% plot the singular values
figure;
plot(1:min(m,n),diag(SIm));


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


[UIm,SIm,VIm]=svd(ImJPG_Noisy);

figure;
plot(1:min(m,n),diag(SIm),'ko');

for k=10:20:50
    ImJPG_comp=uint8(UIm(:,1:k)*SIm(1:k,1:k)*(VIm(:,1:k))');
    figure;
    imshow(ImJPG_comp)
    % compression percentage
    pct = 1 - (numel(UIm(:,1:k))+numel(VIm(:,1:k)*SIm(1:k,1:k)))/numel(ImJPG);
    fprintf('Compression percentage for %2.0f singular values: %8.3f\n',k, pct);
end;
