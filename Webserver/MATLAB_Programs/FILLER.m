%Function to fill space in between min and max planes
%Specific for 3D CDF surface plots and probably not helpful otherwise but a
%huge pain in the ass to edit
%AJR 09-05-2013

function [x_plane,y_plane,z_plane,x_line,y_line,z_line]=FILLER(xx,z_min,z_max)
num_trucks=length(z_min);
x_plane=xx*ones(3,10);
y_plane=[6 5 5 4 4 3 3 2 2 1;
        6 6 5 5 4 4 3 3 2 2 ;
        5 5 4 4 3 3 2 2 1 1];
z_plane_min=z_min(:,1);
z_plane_max=z_max(:,1);

for ab=1:10
    z_plane(1,ab)=z_plane_min(y_plane(1,ab));
    z_plane(2,ab)=z_plane_max(y_plane(2,ab));
    if mod(ab,2) == 0
        z_plane(3,ab)=z_plane_max(y_plane(3,ab));
    else
        z_plane(3,ab)=z_plane_min(y_plane(3,ab));
    end
end

%draw lines
x_line=xx*ones(13,1);
y_line=[6 5 4 3 2 1 1 2 3 4 5 6 6]';
z_line=[z_min(6); z_min(5); z_min(4); z_min(3); z_min(2);z_min(1);
        z_max(1);z_max(2);z_max(3);z_max(4);z_max(5);z_max(6);z_min(6)];
filling=fill3(x_plane,y_plane,z_plane,'g');
set(filling,'edgecolor','none')
plot3(x_line,y_line,z_line,'k')

%Top to bottom lines
xvec=[xx,xx];yvec=[1,1];zvec=[z_min(1),z_max(1)];
plot3(xvec,yvec,zvec,'k');
hold on
xvec=[xx,xx];yvec=[2,2];zvec=[z_min(2),z_max(2)];
plot3(xvec,yvec,zvec,'k');
xvec=[xx,xx];yvec=[3,3];zvec=[z_min(3),z_max(3)];
plot3(xvec,yvec,zvec,'k');
xvec=[xx,xx];yvec=[4,4];zvec=[z_min(4),z_max(4)];
plot3(xvec,yvec,zvec,'k');
xvec=[xx,xx];yvec=[5,5];zvec=[z_min(5),z_max(5)];
plot3(xvec,yvec,zvec,'k');
xvec=[xx,xx];yvec=[6,6];zvec=[z_min(6),z_max(6)];
plot3(xvec,yvec,zvec,'k');
end
