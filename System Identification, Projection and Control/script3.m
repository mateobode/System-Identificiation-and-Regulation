clc
clear all 
close all

%%
u = IOData.u;
t = IOData.SamplingInstants;
y = IOData.y;

plot(y, 'LineWidth', 1);
hold on;
plot(u, 'LineWidth', 2);
legend('iesire','intrare');
xlabel('t');
ylabel('u[V] y[V]');

ylim([-0.5 7]);

%%

N = 10; 
p = 1;
Te = 0.6;
u0 = 6; %comanda nominala de 60% din [0V 10V]
delta_u = 1; %intervalul de liniarizare de 10% din [0V 10V]

L = 2.^N - 1 .* p; %calculam lungimea SPAB-ului

prbs = idinput(L, 'prbs', [0 1/p], [u0-delta_u u0+delta_u]); %generarea SPAB-ului

%plotFreq(prbs, 1/Te);
%plotFreq(prbs, 1/Te, 's', [0 630 u0-delta_u u0+delta_u], [-0.83 0.83 0 70]);
%plotFreq(prbs, 1/Te, 'p');

u_0 = [u0 u0 u0 u0 u0 u0 u0 u0 u0 u0]';
PRBS = cat(1,prbs(11:1023),prbs(1:10));

PRBS_2 = cat(1,PRBS(1:1023),PRBS(1:512));

u_spab = cat(1,u_0,PRBS_2); 
%plotFreq(PRBS, 1/Te);
%plotFreq(u_spab, 1/Te);

t_exp = ((L+512)*Te)+6;

plotFreq(iesire.signals.values(11:1545), 1/Te, 's');
plotFreq(iesire.signals.values(11:1545), 1/Te, 'p');

u = intrare.signals.values(11:1545);
y = iesire.signals.values(11:1545);

IOData = iddata(y,u,Te);
save('B33_DateExper.mat','IOData');
