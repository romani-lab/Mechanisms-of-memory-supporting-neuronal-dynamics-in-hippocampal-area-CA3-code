clear

p = []; % parameters
p.J = 15; %scaling factor for synaptic weights
p.Ts = 1; %individual lap tims
p.nlaps = 10; %number of laps
p.T = p.Ts*p.nlaps; %total tim
p.dt = 0.01; %sampling rate for ode solver
ntr = 16; %number of neurons

%location of the neurons on a ring
th = linspace(0,2*pi,ntr+1); th(end:end) = [];
idx = 1:ntr;
p.k = 4; %Von Mises concetration parameter for plateaus
v = 2*pi/p.Ts; %simulated animal velocity

%profile of plateau potential
vm = @(x) exp(p.k*cos(x)) / (2*pi*besseli(0,p.k));

% time of max activation for pre and post neurons
tpre = th/v;
tpost = th/v;

% initialize syanptic matrix
wend = zeros(ntr,ntr);

for k = 1:ntr %iterate over postsynaptic neurons
    disp(k/ntr)
    for i = 1:ntr %presynaptic
        %temporal profiles of the neurons
        p.A = @(t) vm(v*(t-tpre(i))) .* (t<p.T);
        p.P = @(t) vm(v*(t-tpost(k))) .* (t<p.T);

        %additional profile needed for synaptic rule
        p.B = @(t) p.A(t)*p.P(t);
        p.options = odeset('MaxStep',0.1,'RelTol',1e-4,'AbsTol', 1e-8);
        
        %initial condition for the states
        p.incond = [0.25,0,0,0]; 
        %run synaptic dynamics for p.T
        [t0,y0] = ode45(@diff_inputs_v2, 0:p.dt:p.T, p.incond, p.options, p); 
        
        %let the states converge in the absence of plateaus
        [t1,y1] = ode45(@diff_inputs_v2, p.T:p.dt:p.T+5, y0(end,:), p.options, p); 
        
        t = [t0; t1(2:end)];
        y = [y0; y1(2:end,:)];
        
        wend(k,i) = y(end,1);
    end
end

% plot synaptic matrix
figure(1)
clf
imagesc(wend)
colorbar
axis square


% network dynamics

%shift and rescale weights
p.W = (wend - mean(wend(:)))/ntr*p.J; 
p.tau = 0.01; %integration time constant (s)
p.I = 2; %external bias
p.fext = 0.25; %amplitude of tuned input
p.v = 1/20; %animal velocity
p.dt = 0.05; %sampling rate for ode solver
p.trans = 2; %transient period removed for visualization
p.T1 = 7.5; %time of first running period
p.T2 = p.T1+3.5; %no input from T1 to T2
p.T3 = 15;


%external input
p.Iext = @(tt) cos(th'-2*pi*tt*p.v)*p.fext;

%neuron input-output function
p.i2r = @(x) my_poslin(x);

%initial conditions for the dynamcis
p.incond = zeros(1,16);

%simulated animal position
%plus arbitrary postion added for fine tuning the figure
pos = @(tt) 2*pi*tt*p.v+pi/11; 

%external input 
ext = @(tt) cos(th'-pos(tt))*p.fext;
p.options = [];

%run dynamics with statioanry external input for 2s
p.Iext = @(tt) ext(0);
[tt,yy] = ode45(@diff_ring, 0:p.dt:2 , p.incond, p.options, p); 

%first running period
p.Iext = @(tt) ext(tt);
[t0,y0] = ode45(@diff_ring, 0:p.dt:(p.T1-p.dt), yy(end,:), p.options, p); 

%removal of external input
p.Iext = @(tt) 0;
[t1,y1] = ode45(@diff_ring,...
    (p.T1):p.dt:(p.T2-p.dt),y0(end,:), p.options, p); 

%second running period
p.Iext = @(tt) ext(tt-p.T2+p.T1);
[t2,y2] = ode45(@diff_ring, ...
    (p.T2):p.dt:(p.T3),y1(end,:), p.options, p); 

y = [y0;y1;y2];
t = [t0; t1; t2];

%plot results
ind = t>p.trans & t<p.T3;

figure(2)
clf
imagesc(t(ind)-p.trans,1:ntr,my_poslin(y(ind,:)'))
colormap(flipud(gray))
colorbar
xlabel('Time (s)')
ylabel('Neuron')
hold on
neu = @(tt) mod(ntr*pos(tt)/(2*pi),ntr) + 1;
line([0,p.T1]-p.trans,[1, neu(p.T1)],'LineWidth',2,'Color',[.75 0 0])
line([p.T2,p.T3]-p.trans,[neu(p.T1),neu(p.T1+(p.T3-p.T2))],'LineWidth',2,'Color',[.75 0 0])
set(gcf,'color','w')
set(gca,'FontSize',18)

%auxiliary functions

%synaptic dynamics
function dydt = diff_inputs_v2(t,y,p) 
w = y(1);
a = y(2);
b = y(3);
g = y(4);
dwdt = p.B(t) - p.B(t)*w - p.P(t)*a - p.A(t)*b + p.B(t)*g;
dadt = p.B(t) + p.A(t)*w - p.B(t)*w - a - p.B(t)*a - p.A(t)*b + p.B(t)*g;
dbdt = p.B(t) + p.P(t)*w - p.B(t)*w - p.P(t)*a - b - p.B(t)*b + p.B(t)*g;
dgdt = p.B(t)*(1-a-b) - g + p.B(t)*g;
dydt = [dwdt ;dadt ;dbdt ;dgdt ];
end

%network dynamics
function dvdt = diff_ring(t,v,p) 
m = p.i2r(v);
dvdt = (-v + p.W * m + p.I + p.Iext(t) )/p.tau;
end

% neuron input-output function
function r = my_poslin(c)
r = c;
r(c<0) = 0;
end




