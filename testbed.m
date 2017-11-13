sigmai = 0.001; %desvio padrao geral dos sensores
alfa = 1; 
t = 1; %inicializaçao
t_end = 100;
n_sens = 4;

nFrames = t_end;
vidObj = VideoWriter('iseeu.avi');
vidObj.Quality = 100;
vidObj.FrameRate = 2;
open(vidObj);

l_quad = 10;
x = [1;4];
S(:,1) = [8;4];
S(:,2) = [9;3];
S(:,3) = [8;6];
S(:,4) = [9;7];

figure
scatter(S(1,1),S(2,1),'MarkerEdgeColor','r','MarkerFaceColor','r')
hold on
scatter(S(1,2),S(2,2),'MarkerEdgeColor','b','MarkerFaceColor','b')
scatter(S(1,3),S(2,3),'MarkerEdgeColor','g','MarkerFaceColor','g')
scatter(S(1,4),S(2,4),'MarkerEdgeColor','y','MarkerFaceColor','y')
scatter(x(1),x(2),'k','x')
axis manual
axis([0 9 0 9])
xlabel('x-axis [m]')
ylabel('y-axis [m]')
hold off

ax = gca;
ax.Units = 'pixels';
pos = ax.Position;

marg = 30;
rect = [-marg, -marg, pos(3)+2*marg, pos(4)+2*marg];

F = getframe(gca,rect);

writeVideo(vidObj, F);
clf

Best_pos = S; %Define um vector que guarda as melhores posiçoes para cada sensor

while(t<=t_end)
    [ Best_pos, target_pos ] = ISEE_U(n_sens,Best_pos,x,sigmai*alfa,l_quad-1);
    
    scatter(Best_pos(1,1),Best_pos(2,1),'MarkerEdgeColor','r','MarkerFaceColor','r')
    hold on
    scatter(Best_pos(1,2),Best_pos(2,2),'MarkerEdgeColor','b','MarkerFaceColor','b')
    scatter(Best_pos(1,3),Best_pos(2,3),'MarkerEdgeColor','g','MarkerFaceColor','g')
    scatter(Best_pos(1,4),Best_pos(2,4),'MarkerEdgeColor','y','MarkerFaceColor','y')
    scatter(x(1),x(2),'k','x')
    axis manual
    axis([0 9 0 9])
    xlabel('x-axis [m]')
    ylabel('y-axis [m]')
    hold off
    F = getframe(gca,rect);
    
    writeVideo(vidObj, F);
    
    clf
    
    t = t+1;
end

close(gcf);
close(vidObj);
close all

figure
scatter(Best_pos(1,1),Best_pos(2,1),'MarkerEdgeColor','r','MarkerFaceColor','r')
hold on
scatter(Best_pos(1,2),Best_pos(2,2),'MarkerEdgeColor','b','MarkerFaceColor','b')
scatter(Best_pos(1,3),Best_pos(2,3),'MarkerEdgeColor','g','MarkerFaceColor','g')
scatter(Best_pos(1,4),Best_pos(2,4),'MarkerEdgeColor','y','MarkerFaceColor','y')
scatter(x(1),x(2),'k','x')
scatter(target_pos(1),target_pos(2),'r','x')
axis manual
axis([0 9 0 9])
xlabel('x-axis [m]')
ylabel('y-axis [m]')
hold off
