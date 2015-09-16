%Function to plot 3D surfaces for min, max and damage
%AJR 09-05-2013

function [] = SURF_PLOTTER(title1,rank_cdf,rank_cdf2,z_dam,z_max,z_min,textplot)
y_axis=[1 2 3 4 5 6];
%Damage plot
surf_dam=surf(rank_cdf2,y_axis,z_dam,'meshstyle','row');
set(surf_dam,'FaceColor','r','FaceAlpha',.7);

%Max plot
hold on
surf_max=surf(rank_cdf,y_axis,z_max,'meshstyle','row');
hold on
set(surf_max,'FaceColor','g','FaceAlpha',1);
lighting gouraud

%min plot
surf_min=surf(rank_cdf,y_axis,z_min,'meshstyle','row');
set(surf_min,'FaceColor','g','FaceAlpha',1);
lighting gouraud
view(83,14)

%Plot settings
set(gca,'YTick',[1:6]); 
x2=xlabel({'Probability of', 'Exceedance'}); 

set(x2,'Fontsize',9);

ylab=ylabel('Girder Number');
set(ylab,'Fontsize',9);
set(x2,'Rotation',-55);
ylim([0.8 6.2]);
zlabel('GDF');
titlez=title(title1);
set(titlez, 'Fontsize',9);
zlim([0 0.5])

if textplot==false
     text(5, -5, 'Number of Trucks = 500', 'FontSize',8);
     text(5, 7, 'Number of Curves = 1000', 'FontSize',8);
end
end
