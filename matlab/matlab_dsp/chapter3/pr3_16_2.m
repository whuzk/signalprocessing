%
% pr3_16_2 
clc; clear all; close all;

[x,Fs]=wavread('m_noise.wav');% �������ݺͲ���Ƶ��
Pref=2e-5;                    % �ο���ѹ
N = 3; 					      % �˲������� 
% 1/3��Ƶ���˲�������Ƶ��
ff = [ 20, 25 31.5 40, 50 63 80, 100 125 160,...                              
    200 250 315, 400 500 630, 800 1000 1250, 1600 2000 2500, ...   
	3150 4000 5000, 6300 8000 10000, 12500 16000]; 
nc=length(ff);                % 1/3�˲�������
P = zeros(1,nc);              % ��ʼ��
m = length(x);                % x�ĳ���
oc6=2^(1/6);                  % ��Ƶ�̵ı���

for i=nc : -1 :20             % �ڵ�20~30��1/3��Ƶ���˲�������Ҫ������
   [B,A] = oct3filt(ff(i),Fs,N);% �����ͨ�˲�����ϵ��
   y = filter(B,A,x);         % �˲�
   P(i) = sum(y.^2)/m;        % ��������źŵľ���ֵ
end
% 1250Hz��20Hz��1/3��Ƶ���˲�������Ҫ������,��ÿһ����Ƶ�����������Ƶ��  
[Bu,Au]=oct3filt(ff(22),Fs,N);% 2500Hzʱ1/3��Ƶ���˲���ϵ�� 
[Bc,Ac]=oct3filt(ff(21),Fs,N);% 2000Hzʱ1/3��Ƶ���˲���ϵ�� 
[Bl,Al]=oct3filt(ff(20),Fs,N);% 1600Hzʱ1/3��Ƶ���˲���ϵ�� 

for j = 5:-1:0                % ���1250Hz��25Hz��1/3��Ƶ���˲������˲�
   x = decimate(x,2);         % ����Ƶ�ʼ���
   m = length(x);             % ���ݳ���
   y = filter(Bu,Au,x);       % ��һ��Ƶ�е�1�˲��������˲�
   P(j*3+4) = sum(y.^2)/m;    % �����˲�����ľ���ֵ
   y = filter(Bc,Ac,x);       % ��һ��Ƶ�е�2�˲��������˲� 
   P(j*3+3) = sum(y.^2)/m;    % �����˲�����ľ���ֵ    
   y = filter(Bl,Al,x);       % ��һ��Ƶ�е�3�˲��������˲� 
   P(j*3+2) = sum(y.^2)/m;    % �����˲�����ľ���ֵ 
end
x = decimate(x,2);            % ����Ƶ�ʼ��� 
m = length(x);                % ���ݳ���
y = filter(Bu,Au,x);          % ��20Hz�˲��������˲�
P(1) = sum(y.^2)/m;           % �����˲�����ľ���ֵ 
% �����Ƶ������ѹ��������ѹ��
Psum=0;
for i=1 : nc
    Pow(i) = 10*log10(P(i)/Pref^2);% �����Ƶ������ѹ��
    Psum=Psum+P(i);           % �������
end
Lps=10*log10(Psum/Pref^2);    % ��������ѹ��
fprintf('LPS=%5.6fdB\n',Lps);

% ��ͼ
bar(Pow);
set(gca,'XTick',[2:3:30]); grid		 
set(gca,'XTickLabels',ff(2:3:length(ff)));  
xlabel('����Ƶ��/Hz'); ylabel('��ѹ��/dB');
title('����֮һ��Ƶ���˲��������ѹ��')
set(gcf,'color','w'); 




