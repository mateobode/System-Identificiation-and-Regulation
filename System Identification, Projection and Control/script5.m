clc; clear all; close all;

%% PROIECTARE REGLARE

%
% Performantele impuse
% ~~~~~~~~~~~~~~~~~~~~

Te = 0.6 ; % perioada de esantionare aleasa
tt = 6 ; % timpul tranzitoriu sa fie max 6sec
xi = 0.7 ; % suprareglajul <=5% inseamna xi = 0.7

wn = 3.9/(xi*tt) ; % calculul pulsatiei naturale

%
% Calculul polinomului P
% ~~~~~~~~~~~~~~~~~~~~~~

s = tf('s') ;
H0 = wn^2/(s^2 + 2*xi*wn*s + wn^2) ;
Hz = c2d(H0, Te, 'ZOH') ; % discretizare
Hz = filt(Hz.Num, Hz.Den, Te) ; % aducerea la forma H(z^-1)=Q(z^-1)/P(z^-1)

%
% Calculul matricei Sylvester
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~

M = [1 0 0 0 0; -0.30786 1 0 0 0; -0.31945 -0.30786 1 0.12450 0;
    0 -0.31945 -0.30786 0.02809 0.12450;0 0 -0.31945 0 0.02809];

P = [1; - 1.248; 0.4584; 0; 0];

x = M\P; % solutia M*x = P

%% PROIECTARE URMARIRE

Te = 0.6 ; % perioada de esantionare aleasa
tt = 6 ; % timpul tranzitoriu sa fie max 6sec
xi = 0.9 ; % suprareglajul <=5% inseamna xi = 0.9

wn = 3.9/(xi*tt) ; % calculul pulsatiei naturale

%
% Calculul functiei de transfer a modelului de referinta
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

H0m = wn^2/(s^2 + 2*xi*wn*s + wn^2) ;
Hm = c2d(H0m, Te, 'ZOH') ; % discretizare
Hm = filt(Hm.Num, Hm.Den, Te) ; % Hm(z^-1)=Bm(z^-1)/Am(z^-1)

%
% Calculul polinomului T(z^-1)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

bm = [0.07250035391 0.05587605944];
b = bm(1) + bm(2);

% conditia pentru G
if b==0
    G = 1;
else
    G = 1/b;
end

P = filt([1 -1.248 0.4584], 1);
T = G * P;

%% REPROIECTARE REGULATOR

%
% Performantele impuse
% ~~~~~~~~~~~~~~~~~~~~

Te = 0.6 ; % perioada de esantionare aleasa
tt = 6 ; % timpul tranzitoriu sa fie max 6sec
xi = 0.7 ; % suprareglajul <=5% inseamna xi = 0.7

wn = 3.9/(xi*tt) ; % calculul pulsatiei naturale

%
% Calculul polinomului P
% ~~~~~~~~~~~~~~~~~~~~~~

s = tf('s') ;
H0 = wn^2/(s^2 + 2*xi*wn*s + wn^2) ;
Hz = c2d(H0, Te, 'ZOH') ; % discretizare
Hz = filt(Hz.Num, Hz.Den, Te) ; % aducerea la forma H(z^-1)=Q(z^-1)/P(z^-1)

A = filt([1 -0.30786 -0.31945], 1);
A_prim = A * filt([1 -1], 1);

%
% Calculul matricei Sylvester
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~

M_prim = [1 0 0 0 0 0; -1.308 1 0 0 0 0; -0.01159 -1.308 1 0.1245 0 0;
    0.3195 -0.01159 -1.308 0.02809 0.1245 0; 0 0.3195 -0.01159 0 0.02809 0.1245; 
    0 0 0.3195 0 0 0.02809];

P_prim = [1; - 1.248; 0.4584; 0; 0; 0];

x = M_prim\P_prim; % solutia M*x = P