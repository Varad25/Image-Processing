close all;
clear all;

%% Loading data and plotting data
load('z.mat');
z = [zeros(50,1);z];
x = [zeros(130,1);zeros(50,1)+50;zeros(50,1)];

figure
plot(x)
title('True Data')

figure
plot(z)
title('Data with some random noise')

%% Stopping Criteria and intializing other parameters
tol = Inf;
I1 = z;
dt=0.01;
%T = 100:100:1000;
T= 500;

%% Algorithm
tic
for i = 1:1:size(T,2)
    I1=z;
    for  t=1:T(i)
        [Ix]=gradient(I1); 
        [Ixx]=gradient(Ix);
        c = (Ixx )./(1 + (2*(Ixx)).^2);
        [div1] = gradient(c);
        [div11] = gradient(div1);
        div = div11;
        I1 = I1 - dt.*(div);
    end
    Err(i) = norm(I1-x);
    if(norm(I1-x)<tol)
        tol = norm(I1-x);
        I = I1;
    end
end
toc

%% Displaying best Results

figure
plot(I)
title('Denoised Signal')

figure
plot(T,Err)
ylabel('Euclidean Distance between True Image and Denoised Image')
xlabel('Number of Iterations')
