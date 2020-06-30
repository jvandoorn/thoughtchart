%% Figure 2, part 2
% Matlab portion of the construction of figure 2 of the meditation paper
% Mon Jun 29 09:02:21 2020

clearvars; close all;
rng(42);

ipath = './Meditation/CleanData/FourTask/';
d(1).path = [ipath 'CTR17_dijkstra.mat']; d(1).name = 'CTR17';
d(2).path = [ipath 'HT8_dijkstra.mat']; d(2).name = 'HT8';
d(3).path = [ipath 'SNY8_dijkstra.mat']; d(3).name = 'SNY8';
d(4).path = [ipath 'VIP06_dijkstra.mat']; d(4).name = 'VIP6';

labels = ["", "BreathAwareness", "Meditation", "IMW1", "IMW2"];
ipath2 = '~/Research/meditation_paper/Fig2/WPLI/';
ipath3 = '~/Research/meditation_paper/Fig2/MatFigs/';
opath = '~/Research/meditation_paper/Fig2/Images/';

leng = length(d);

for a = leng:leng
    load([d(a).path]);
    
    nsect = [1; sect];
    
    markers = zeros(1,4);
    
    for b = 2:5
        region = nsect(b-1):nsect(b);
        
        miniTC = Manifold_Distance(region, region);
        
        all_distances = sum(miniTC, 2);
        
        [~,ind] = min(all_distances);
        
        markers(b-1) = ind+nsect(b-1)-1;
        
        load([ipath2 d(a).name '_' char(labels(b)) '.mat']);
        
        freq_avg = mean(Connect(:,:,:,ind), 3);
        
%         fig = figure;
%         
%         imagesc(freq_avg, [0 0.5]); colorbar;
%         
%         saveas(fig, [opath d(a).name '_' char(labels(b)) '.png'], 'png') 
        
    end
    
    clear Connect
    
    exp_sect = [];
    nnsect = [0; sect];
    for b = 2:length(nnsect)
        tmp = repmat(b-1,nnsect(b)-nnsect(b-1),1);
        exp_sect = [exp_sect; tmp];
    end
    
    % IsoMap
    isoCoords = iso2(Manifold_Distance);
    iso_ind = randperm(size(isoCoords,2));
    squares = isoCoords(:,markers);
    
    iso_sect = exp_sect(iso_ind);
    isoCoords = isoCoords(:,iso_ind);
    
    nodes =  length(isoCoords);
    taskfig_iso = figure; 
    
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
    
    scatter(squares(1,:),squares(2,:),'k','v', ...
        'MarkerFaceColor','k')
    
    legend([br md tk1 tk2], {'Breath Awareness (a)', 'Meditation (b)',...
        'IMW 1 (c)', 'IMW 2 (d)'}, ...
        'Location','best');
    xlabel('Primary Eigenvector'); ylabel('Secondary Eigenvector');
    saveas(taskfig_iso,[opath d(a).name '_4T_ISO.png'], 'png')
    
 end