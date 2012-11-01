function createfigure(X1, YMatrix1)
%CREATEFIGURE(X1,YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 19-Oct-2012 12:52:11

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YScale','log','YMinorTick','on',...
    'FontSize',12);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to semilogy
semilogy1 = semilogy(X1,YMatrix1,'Parent',axes1,'LineWidth',2);
set(semilogy1(1),'DisplayName','Radial dipole');
set(semilogy1(2),'Color',[1 0 0],'DisplayName','Dipole oriented along z');
set(semilogy1(3),'Color',[0 1 0],...
    'DisplayName',['Dipole in a plane at 45�',sprintf('\n'),'with respect to the xy plane']);

% Create xlabel
xlabel('Radial distance','FontWeight','bold','FontSize',12);

% Create ylabel
ylabel('2-norm relative error','FontWeight','bold','FontSize',12);

% Create title
title({'Error on the electric potential at the surface of a homogeneous ball (r = 0.1, \sigma = 0.2) given by the semianalytic formula for the multilayer case.','Dipole position varing radially along the z direction.','r = [0.07, 0.1] and \sigma = [0.2, 0.2] are considered as input and the series is truncated at 30th term'},...
    'FontSize',12);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.142451192348008 0.818996415770609 0.1640625 0.0867383512544803],...
    'FontSize',11);

