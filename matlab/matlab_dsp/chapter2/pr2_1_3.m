%
% pr2_1_3 
clear all; clc; close all;

N=33;                           % ����N��
x=zeros(1,N);                   % ���ɾ��β���
x(7:27)=1;        
X=fft(x);                       % FFT
Y=zeros(1,17);                  % ��ʼ��Y
Y(1:6)=X(1:6);                  % �趨ֻȡ1-6������
Y1=fliplr(Y(2:end));            % ������Ӧ�ԳƵ�����
Y=[Y conj(Y1)];                 % ���ɹ���Գ�
y=ifft(Y);                      % FFT��任
n=1:N;
% ��ͼ
subplot 211; plot(n,real(y),'k');
xlabel('����'); ylabel('��ֵ'); 
title('x(n)ʵ��')
subplot 212; plot(n,imag(y),'k');
xlabel('����'); ylabel('��ֵ'); 
title('x(n)�鲿')
set(gcf,'color','w');