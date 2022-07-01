clc; close all; clear all;

%% Filtrare semnale achizitionate in urma experimentului de ident

Te = 0.6; %perioada de esantionare pe care o folosim in continuare
L = 1023; %lungimea SPAB
load('B33_DateExper.mat');

y = IOData.y; %iesire
u = IOData.u; %intrare

%generarea filtrului
[b, a] = butter(1, 0.2); %butter filter ordin 1 cu frecv normalizata 0.2
%iesirea totala filtrata
T = getTrend(IOData, 0); %centralizare
data = detrend(IOData, T); 
f_data = filter(b,a,data.y); %filtrare


%afisare spectru iesirei totala dupa filtrare
plotFreq(y, 1/Te, 's');
plotFreq(f_data, 1/Te, 's');


%creare si filtrare vectorului datelor de identificare
e_Data = iddata(IOData(1:L));
T_eData = getTrend(e_Data,0);
eData_d = detrend(e_Data, T_eData);
f_eData = filter(b,a,eData_d.y);
eData = iddata(f_eData, eData_d.u, Te);

%afisare spectrul datelor de identificare inainte si dupa filtrare
plotFreq(eData_d.y, 1/Te, 's');
plotFreq(eData.y, 1/Te, 's');

%creare si filtrare vectorului datelor de validare
v_Data = iddata(IOData(L+1:end));
T_vData = getTrend(v_Data,0);
vData_d = detrend(v_Data, T_vData);
f_vData = filter(b,a,vData_d.y);
vData = iddata(f_vData, vData_d.u, Te);

%data = iddata(f_vData, vData_d.u, Te);
%afisare spectrul datelor de validare inainte si dupa filtrare
plotFreq(vData_d.y, 1/Te, 's');
plotFreq(vData.y, 1/Te, 's');

%% Seturile de date de identificare MATLAB - iddata pt ident si valid

save('XXBY_IdentData', 'eData');
save('XXBY_ValidationData', 'vData');

%% Estimarea complexitatii model ARX

%advice(eData);
d = delayest(eData);

M = struc(1:5, 1:5, d);
V = arxstruc(eData, vData, M);
order = selstruc(V,0);
    
display(' ');
display('Model ARX: ');

%construim modelul 
modelARX = arx(eData, order);

display('-----------------------');
display(modelARX);

display(strcat('Fit Percent: ', num2str(modelARX.Report.Fit.FitPercent)));
display(strcat('Loss: ', num2str(modelARX.Report.Fit.LossFcn)));
display(strcat('MSE: ', num2str(modelARX.Report.Fit.MSE)));
display(strcat('FPE: ', num2str(modelARX.Report.Fit.FPE)));
display(strcat('AIC: ', num2str(modelARX.Report.Fit.FPE)));
display(strcat('AICc: ', num2str(modelARX.Report.Fit.AICc)));
display(strcat('nAIC: ', num2str(modelARX.Report.Fit.nAIC)));
display(strcat('BIC: ', num2str(modelARX.Report.Fit.BIC)));

%resid and compare pt datele de validare
valid_arx = resid(modelARX, vData);

figure(1);
subplot(3, 1, 1);
plot(valid_arx.y);
title('Output Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 2);
plot(valid_arx.u);
title('Input Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 3);
compare(vData, modelARX);
grid on;

%% MODEL ARMAX

order = [0 0 0 1];
MaxFit = 0;

for na = 1:5
    for nb = 1:5
        for nc = 1:5
            modelARMAX = armax(eData, [na nb nc d]);
            if(modelARMAX.Report.Fit.FitPercent > MaxFit)
                MaxFit = modelARMAX.Report.Fit.FitPercent;
                order = [na nb nc 1];
            end
        end
    end
end

modelARMAX = armax(eData, [na nb nc d]);

display('-----------------------');
display(modelARMAX);

display(strcat('Fit Percent: ', num2str(modelARMAX.Report.Fit.FitPercent)));
display(strcat('Loss: ', num2str(modelARMAX.Report.Fit.LossFcn)));
display(strcat('MSE: ', num2str(modelARMAX.Report.Fit.MSE)));
display(strcat('FPE: ', num2str(modelARMAX.Report.Fit.FPE)));
display(strcat('AIC: ', num2str(modelARMAX.Report.Fit.FPE)));
display(strcat('AICc: ', num2str(modelARMAX.Report.Fit.AICc)));
display(strcat('nAIC: ', num2str(modelARMAX.Report.Fit.nAIC)));
display(strcat('BIC: ', num2str(modelARMAX.Report.Fit.BIC)));

%resid and compare pt datele de validare
valid_armax = resid(modelARMAX, vData);

figure(1);
subplot(3, 1, 1);
plot(valid_armax.y);
title('Output Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 2);
plot(valid_armax.u);
title('Input Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 3);
compare(vData, modelARMAX);
grid on;

%% MODEL BJ

order = [0 0 0 0 1];
MaxFit = 0;

for nb = 1:5
    for nc = 1:5
        for nd = 1:5
            for nf = 1:5
                modelBJ = bj(eData, [nb nc nd nf d]);
                if(modelBJ.Report.Fit.FitPercent > MaxFit)
                    MaxFit = modelBJ.Report.Fit.FitPercent;
                    order = [nb nc nd nf 1];
                end
            end
        end
    end
end

modelBJ = bj(eData, [nb nc nd nf d]);

display('-----------------------');
display(modelBJ);

display(strcat('Fit Percent: ', num2str(modelBJ.Report.Fit.FitPercent)));
display(strcat('Loss: ', num2str(modelBJ.Report.Fit.LossFcn)));
display(strcat('MSE: ', num2str(modelBJ.Report.Fit.MSE)));
display(strcat('FPE: ', num2str(modelBJ.Report.Fit.FPE)));
display(strcat('AIC: ', num2str(modelBJ.Report.Fit.FPE)));
display(strcat('AICc: ', num2str(modelBJ.Report.Fit.AICc)));
display(strcat('nAIC: ', num2str(modelBJ.Report.Fit.nAIC)));
display(strcat('BIC: ', num2str(modelBJ.Report.Fit.BIC)));

%resid and compare pt datele de validare
valid_bj = resid(modelBJ, vData);

figure(1);
subplot(3, 1, 1);
plot(valid_bj.y);
title('Output Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 2);
plot(valid_bj.u);
title('Input Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 3);
compare(vData, modelBJ);
grid on;

%% MODEL OE

order = [0 0 1];
MaxFit = 0;

for nb = 1:5
    for nf = 1:5
        modelOE = oe(eData, [nb nf d]);
        if(modelOE.Report.Fit.FitPercent > MaxFit)
            MaxFit = modelOE.Report.Fit.FitPercent;
            order = [nb nf 1];
        end
    end
end

modelOE = oe(eData, [nb nf d]);

display('-----------------------');
display(modelOE);

display(strcat('Fit Percent: ', num2str(modelOE.Report.Fit.FitPercent)));
display(strcat('Loss: ', num2str(modelOE.Report.Fit.LossFcn)));
display(strcat('MSE: ', num2str(modelOE.Report.Fit.MSE)));
display(strcat('FPE: ', num2str(modelOE.Report.Fit.FPE)));
display(strcat('AIC: ', num2str(modelOE.Report.Fit.FPE)));
display(strcat('AICc: ', num2str(modelOE.Report.Fit.AICc)));
display(strcat('nAIC: ', num2str(modelOE.Report.Fit.nAIC)));
display(strcat('BIC: ', num2str(modelOE.Report.Fit.BIC)));

%resid and compare pt datele de validare
valid_oe = resid(modelOE, vData);

figure(1);
subplot(3, 1, 1);
plot(valid_oe.y);
title('Output Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 2);
plot(valid_oe.u);
title('Input Data');
ylabel('Amplitude');
xlabel('Time (seconds)');
grid on;
subplot(3, 1, 3);
compare(vData, modelOE);
grid on;

%% Stabilitate ARX

figure;
pzmap(modelARX);
figure;
nyquist(modelARX);
figure;
step(modelARX, 50);
sys = d2c(modelARX);
figure;
step(sys, 50);

save('XXBY_ModelMatlab.mat', 'modelARX');