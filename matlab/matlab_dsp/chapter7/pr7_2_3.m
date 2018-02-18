%
% pr7_2_3  
clc; clear all; close all;

f0=49.13;                    % ����Ƶ��
fs=3200;                     % ����Ƶ��
N=2048;                      % ���ݳ���
n=0:N-1;                     % ��������
rad=pi/180;                  % �ǶȺͻ��ȵ�ת������
xb=[240,0.1,12,0.1,2.7,0.05,2.1,0,0.3,0,0.6]; % г����ֵ
Q=[0,10,20,30,40,50,60,0,80,0,100]*rad;       % г����ʼ��λ
s=zeros(1,N);                % ��ʼ��
M=11;                        % г������
for i=1:M                    % ����г���ź�
    s=s+xb(i)*cos(2*pi*f0*i*n./fs+Q(i));
end
% Blackman-Harris��
w=0.35875-0.48829*cos(2*pi*n/N)+0.14128*cos(4*pi*n/N)-0.01168*cos(6*pi*n/N);
x=s.*w;                      % �źų��Դ�����
v=fft(x,N);                  % FFT
u=abs(v);                    % ȡƵ�׵ķ�ֵ
k1=zeros(1,M);               % ��ʼ��
k2=zeros(1,M);
A=zeros(1,M);
ff=zeros(1,M);
Ph=zeros(1,M);
df=fs/N;                     % Ƶ�ʷְ���

for i=1:M                    % ��������͸���г���Ĳ���
    if i==1                  % ���������,��40-60Hz������Ѱ������ֵ
        n1=fix(40/df); n2=fix(60/df); % ���40Hz��60Hz��Ӧ��������
    else                     % ������г��,�Ӹ�г������ֵ-10��+10��������Ѱ�����ֵ
        n1=fix((i*ff(1)-20)/df);      % ��������Ӧ��������
        n2=fix((i*ff(1)+20)/df);
    end
    [um,ul]=max(u(n1:n2));   % ���������ҳ����ֵ
    k1(i)=ul+n1-1;           % �������ֵ��������
% �жϷ�ֵ�����ֵ��߻����ұ�,�����ֵ�����ֵ���,��k1(i)��������    
    if u(k1(i)-1)>u(k1(i)+1), k1(i)=k1(i)-1; end
    k2(i)=k1(i)+1;           % ���k2(i),ʹ��ֵ��Զ��k1(i)��k2(i)֮��
    y1=u(k1(i));             % ���y1��y2
    y2=u(k2(i));
    b=y2/y1;                 % ��ʽ(7-2-5)�����beta
% Blackman-Harris����beta��alpha�ı�ʾʽ
    a=-2.349139+6.314136*b-7.223542*b^2+6.708777*b^3-4.44887*b^4+...
        1.934912*b^5-0.491347*b^6+0.055074*b^7;   
% ��alpha����ֵ�������ֵ�������ź�gammaֵ
    if (a>=0) & (a<=0.5)     % ��k1�����ֵ����
        yk=y1;
        gama=a;
    elseif (a>0.5) & (a<=1)  % ��k2�����ֵ����
        yk=y2;
        gama=-(1-a);
    end
% ��ʽ(7-2-9)��Blackman-Harris���Ĵ�������ϵ�����г���ķ�ֵ
    A(i)=yk*(5.574913+2.111148*(gama)^2+0.43251*(gama)^4+0.067945*(gama)^6)/N; 
    ff(i)=(k1(i)-1+a)*fs/N;       % ���г����Ƶ�� 
    Ph(i)=phase(v(k1(i)))-pi*a;   % ���г���ĳ�ʼ��λ 
    Ph(i)=Ph(i)-(Ph(i)>pi)*2*pi+(Ph(i)<-pi)*2*pi; % ����λ��������
% ����ֵ��С��Ϊ0,����Ƶ����λ����
    if A(i)<0.0005, A(i)=0; ff(i)=i*ff(1); Ph(i)=0; end 
% ��ʾг������
    fprintf('%4d   %5.6f   %5.6f   %5.6f\n',i,A(i),ff(i),Ph(i)/rad);
end  
