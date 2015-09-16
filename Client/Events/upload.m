clear;

load Events.csv

for i= 76:100
    Event=Events(i,:);
    csvwrite(['F:\webserver\Upload\Events',num2str(i),'.csv'],Event);
    pause(2);
end

    
    