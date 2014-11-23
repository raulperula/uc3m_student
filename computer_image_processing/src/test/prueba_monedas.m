% Neural Network Pattern Classification
% PAT -- 25 two point element vector
PAT = [.1 .8  .1 .9; .2 .9 .1 .8];
S = 6;
klr = 0.01;

% initializing the network
net = newc(minmax(PAT),S,klr,0);

%training the network
net = train(net,PAT);

% simulation
A = sim(net,PAT);

% class allocation
Ac = vec2ind(A);

% class analysis
ClassAnal = [1:S; ClassLength; ClassSTD; ClassTypical];
