%% Figure 2, part 1
% Matlab portion of the construction of figure 2 of the meditation paper
% Wed Jun 24 19:03:16 2020

clearvars; close all;
rng(42);

ipath = './Meditation/CleanData/FourTask/';
d(1).path = [ipath 'CTR17_dijkstra.mat']; d(1).name = 'CTR17';
d(2).path = [ipath 'HT8_dijkstra.mat']; d(2).name = 'HT8';
d(3).path = [ipath 'SNY8_dijkstra.mat']; d(3).name = 'SNY8';
d(4).path = [ipath 'VIP06_dijkstra.mat']; d(4).name = 'VIP6';

leng = length(d);

for a = 1:leng
    load([d(a).path]);
    exp_sect = [];
    sect = [0; sect];
    for b = 2:length(sect)
        tmp = repmat(b-1,sect(b)-sect(b-1),1);
        exp_sect = [exp_sect; tmp];
    end
    
    %% IsoMap
    isoCoords = iso(Manifold_Distance);
    iso_ind = randperm(size(isoCoords,2));
    
    iso_sect = exp_sect(iso_ind);
    isoCoords = isoCoords(:,iso_ind);
    
    nodes =  length(isoCoords);
    taskfig_iso = figure(2*a-1); %odd figure number
    
    for i = 1:nodes
        if iso_sect(i) == 1    % Breathing trial (Light Blue)
            br = scatter(isoCoords(1,i), isoCoords(2,i), ...
                'MarkerEdgeColor',[146,197,222]/255, ...
                'MarkerFaceColor',[146,197,222]/255);
        elseif iso_sect(i) == 2    % Meditation trial (Deep Blue)
            md = scatter(isoCoords(1,i), isoCoords(2,i), ...
                'MarkerEdgeColor',[5,113,176]/255, ...
                'MarkerFaceColor',[5,113,176]/255);
        elseif iso_sect(i) == 3    % Active thinking1 trial (Light Red)
            tk1 = scatter(isoCoords(1,i), isoCoords(2,i), ...
                'MarkerEdgeColor',[244,165,130]/255, ...
                'MarkerFaceColor',[244,165,130]/255);
        elseif iso_sect(i) == 4    % Active thinking2 trial (Deep Red)
            tk2 = scatter(isoCoords(1,i), isoCoords(2,i), ...
                'MarkerEdgeColor',[202,0,32]/255, ...
                'MarkerFaceColor',[202,0,32]/255);
        end
        hold on;
    end
    
    title(['Four Tasks: subject ' d(a).name ' ISOMAP']);
    legend([br md tk1 tk2], {'Breathing', 'Meditation',...
        'Active Thinking1', 'Active Thinking2'}, ...
        'Location','best');
    xlabel('Primary Eigenvector'); ylabel('Secondary Eigenvector');
    saveas(taskfig_iso,['./Meditation/Analyses/Fig2/' d(a).name '_4T_ISO.fig'])
    
%     %% MST
%     [loc_node_sub, back_bones,MST_sub]= plot_minimum_spanning_tree(Manifold_Distance);
%     new_nodeL=loc_node_sub;
%     
%     nodes =  length(new_nodeL);
% 
%     taskfig = figure(2*a);
%     for i = 1:nodes-1
%         line(new_nodeL(1,MST_sub(i,1:2)),new_nodeL(2,MST_sub(i,1:2)), ...
%             'LineWidth',1, 'Color', '[0.6 0.6 0.6]');
%         hold on;
%     end
%     
%     new_nodeL=loc_node_sub(:,iso_ind);
%     
%     for i = 1:nodes
%         if iso_sect(i) == 1   % Breathing trial (Light Blue)
%             br = plot(new_nodeL(1,i),new_nodeL(2,i),'o','MarkerSize',4, ...
%                 'MarkerEdgeColor',[146,197,222]/255, ...
%                 'MarkerFaceColor',[146,197,222]/255);
%         elseif iso_sect(i) == 2   % Meditation trial (Deep Blue)
%             md = plot(new_nodeL(1,i),new_nodeL(2,i),'o','MarkerSize',4, ...
%                 'MarkerEdgeColor',[5,113,176]/255, ...
%                 'MarkerFaceColor',[5,113,176]/255);
%         elseif iso_sect(i) == 3     % Active thinking1 trial (Light Red)
%             tk1 = plot(new_nodeL(1,i),new_nodeL(2,i),'o','MarkerSize',4, ...
%                 'MarkerEdgeColor',[244,165,130]/255, ...
%                 'MarkerFaceColor',[244,165,130]/255);
%         elseif iso_sect(i) == 4    % Active thinking2 trial (Light Red)
%             tk2 = plot(new_nodeL(1,i),new_nodeL(2,i),'o','MarkerSize',4, ...
%                 'MarkerEdgeColor',[202,0,32]/255, ...
%                 'MarkerFaceColor',[202,0,32]/255);
%         end
%         hold on;
%     end
%     
%     title(['Four Tasks: subject ' d(a).name ' MST']);
%     legend([br md tk1 tk2], {'Breathing', 'Meditation',...
%         'Active Thinking1', 'Active Thinking2'}, ...
%         'Location','best');
%     
%     saveas(taskfig,['./Meditation/Analyses/Fig2/' d(a).name '_4T_MST.fig']);
end