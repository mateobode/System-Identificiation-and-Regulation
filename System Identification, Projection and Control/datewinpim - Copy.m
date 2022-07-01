clc; clear all; close all;

%% generare fisier date pentru winpim .txt

load("B33_DateExper.mat");

u = IOData.u;
y = IOData.y;
Te = 0.6;

dim_date = length(y);

timp = 0:Te:(dim_date-1)*Te;

VectorDate = [timp' y u];

save('DateIOXXBY.txt' , '-ascii', 'VectorDate');