%% Project Assignment #2 for ENGR 25, Fall 2021

% The following script enables the user to play a game of tic tac toe 
% against the computer with their life at stake. 

clear; clc; close all;

map = [1,3; 1,2; 1,1; 2,3; 2,2; 2,1; 3,3; 3,2; 3,1];
map = array2table(map,'VariableNames',{'X','Y'});

minSlots = 0;
maxSlots = 3;
legal = 0;
legal2 = 0;
counter = 1;

while(1)

xh1 = [0,3];xh2 = [0,3];
xv1 = [1,1];xv2 = [2,2];
yh1 = [1,1];yh2 = [2,2];
yv1 = [0,3];yv2 = [0,3];
clf
plot(xh1,yh1,'w',xh2,yh2,'w',xv1,yv1,'w',xv2,yv2,'w'),...
axis on, axis square
set(gcf, 'Name','Darren = Tic tac toe')
set(gca,'xtick',[],'ytick',[],'Color','#292828')

ax = gca;
ax.Toolbar.Visible = 'off';
disableDefaultInteractivity(ax)

if counter > 1
scoreboard(counter, history, mode)
end

state = zeros(3,3);
title({'Tic Tac Toe','Select your difficulty level!'})
xlabel({'Choose how skilled your opponent','will be in the Command Window!'})

%% USER INPUT - EASY VS. HARD / 1st or 2nd turn%%
while legal == 0
    mode = input('Select computer difficulty level: \nEasy = "1" and Hard = "2" \n\n');
    if mode == 1
        legal = 1;
        fprintf('You are playing: EASY MODE. \nYou better not lose!\n\n')
    elseif mode == 2
        legal = 1;
        fprintf('You are playing: HARD MODE. \nGood luck trying to beat it! (you won''t)\n\n')
    else
    legal = 0;
    end
end

title({'Tic Tac Toe','Select who goes first!'})
xlabel({'Choose if you want to go first','in the Command Window!'})

while legal2 == 0
    firstTurn = input('Do you want to go first or second? \nFirst = "1" and Second =  "2"\n\n');
    if firstTurn == 1
        legal2 = 1;
        fprintf('You will go first! \n\n')
        play_INITIALIZER = 0;
        playTo_INITIAL = 9;
        
    elseif firstTurn == 2
        legal2 = 1;
        fprintf('You will go second! \n\n')
        play_INITIALIZER = 1;
        playTo_INITIAL = 10;
    else
        legal2 = 0;
    end
end

play = play_INITIALIZER;
playTo = playTo_INITIAL;


fprintf('\nGame: %d\n',counter)
title({'Tic Tac Toe','GAME START!'})


while play < playTo
    
    %% USER TURN %%
    if mod(play,2) == 0
        xlabel({'YOUR TURN','Make your selection'})
        [x,y] = ginput(1);
        
        %% REDO SELECTION IF OUTSIDE BOUNDARY  %%
        while (x < 0 || x > 3) || (y < 0 || y > 3)
            xlabel({'Make sure to','select inside the tiles!'})
            [x,y] = ginput(1);     
        end  

        %% DETERMINE IF SELECTION IS VALID  %%
        elem_loc = find(map.X == (1+floor(x)) & map.Y == (1+floor(y)));        

        while (state(elem_loc) ~= 0)
            xlabel({'This position is already taken!','Choose another tile'})
            [x,y] = ginput(1);

            while (x < 0 || x > 3) || (y < 0 || y > 3)
                xlabel({'Make sure to','select inside the tiles!'})
                [x,y] = ginput(1);     
            end  

            elem_loc = find(map.X == (1+floor(x)) & map.Y == (1+floor(y)));       
        end

        
        %% INPUT 'X' AND RECORD STATE
        text(0.5+floor(x),0.6+floor(y),'x','horizontalalignment','center', ...
        'fontsize',80,'color','#4DBEEE')
        
        state(elem_loc) = 1;

    %% COMPUTER'S TURN %%%
    else
        xlabel({'COMPUTER TURN',''})
        pause(.5)
        
        %% HARD MODE - MINIMAX ALGO %%
        if mode == 2
                   
            emptyspaces = length(state(state==0));

            bestscore = inf;
            idx = 0;
        
            for i = 1:9
                if state(i) == 0
        
                    state(i) = -1;
        
                    [score,depth] = minimax(state, emptyspaces-1, false);
        
                    state(i) = 0;
        
                    if (score < bestscore) || (score == bestscore) && (rand <= 0.3)
                        idx = i;
                        bestscore = score;
                    end
                end
            
         
            end
            compChoice = map(idx,:);
            x = compChoice.X -.1;
            y = compChoice.Y -.1;
       
        %% EASY MODE - RNG PLAYER %%
        else
            compChoice = floor(minSlots + (maxSlots - minSlots) .* rand(1,2));
            x = compChoice(1);
            y = compChoice(2);
        
            elem_loc = find(map.X == (1+floor(x)) & map.Y == (1+floor(y)));        
            while (state(elem_loc) ~= 0)
                compChoice = floor(minSlots + (maxSlots - minSlots) .* rand(1,2));
                x = compChoice(1);
                y = compChoice(2);
                elem_loc = find(map.X == (1+floor(x)) & map.Y == (1+floor(y)));       
            end
        end
        
        

        %% INPUT '〇' AND RECORD STATE '
        text(0.5+floor(x),0.6+floor(y),'o','horizontalalignment','center', ...
        'fontsize',80,'color','#E35C59')
        if mode == 2
           state(idx) = -1; 
        else
            state(elem_loc) = -1;
        end
        
    end


    play = play+1;
    
    if firstTurn == 1
        if play == 1
         title({'Tic Tac Toe','... who will win?'})
        end

        fprintf('Turn: %d\n', play)
    else 
        if play == 2
         title({'Tic Tac Toe','... who will win?'})
        end

        fprintf('Turn: %d\n', play-1)
    end
        
    disp(state);
    
    %% EVALUATE POTENTIAL WINNING POSITION %%%%%%%%
    [winner, id, p1, p2] = eval_winner(state);
    if winner == true
    break
    end

end


%% WINNER MESSAGE AND PLOT LINE THRU 3 IN A ROW %%
if id == 1
    who = 'X matched 3 in a row ... YOU WIN!';
    line(p1,p2,'Color','#0072BD','LineWidth',2)
elseif id == -1
    who = '〇 matched 3 in a row ... COMPUTER WINS!';
    line(p1,p2,'Color','#A2142F','LineWidth',2)
else
    who = 'neither matched 3 in a row ... ITS A DRAW!';
end

title({'Tic Tac Toe','GAME END!'})
xlabel({'AND THE RESULT ...',who})
hold

text(-.9,.2,{'Enter [Y/N] in the','Command Window', 'to replay or quit'})

history(counter) = id; %#ok<*SAGROW>

if counter == 1
scoreboard(counter, history,mode)
end

m = input('\nDo you want to rematch? (Enter [Y/N]):  ','s');
rematchInput = 0;
    while rematchInput == 0
        if lower(m) == 'n'
            fprintf('\n\nThank you.\nRestart the program to try out the other settings!\nHave a nice day!\n')
            rematchInput = 1;
        elseif lower(m) == 'y'
            rematchInput = 1;
        else
            m = input('\nDo you want to rematch? (Enter [Y/N]): ','s');
        end
    end

    if lower(m) == 'n'
       break 
    end
    
counter = counter + 1;
end



%%
function scoreboard(counter, history, mode)
    if mode == 1
        txt = 'EASY Mode';
    elseif mode == 2
        txt = 'HARD Mode';
    end
        
stxt = {['Game #',num2str(counter)]
        [txt]
        ['']
        ['Win:   ',num2str(length(history(history==1)))]
        ['Lose:  ',num2str(length(history(history==-1)))]
        ['Draw:  ',num2str(length(history(history==0)))]};

text(-.9,2.65,stxt)
end

%%
function [winner, id, p1 ,p2] = eval_winner(state)
    
    winner = false;
    p1 = 0;
    p2 = 0;
    
    % eval each row
    for i = 1:3
        row = state(i,:);
        if abs(sum(row)) == 3
            winner = true;
            coord = row;
            p1 = [0.25,2.75];
            p2 = [abs(3.5-i),abs(3.5-i)];
        end
    end
    
    % eval each column
    for j = 1:3
        col = state(:,j);
        if abs(sum(col)) == 3
            winner = true;
            coord = col;
            p1 = [j-0.5,j-0.5];
            p2 = [0.25,2.75];
        end
    end
    
    % eval diagonals
   
    % TL to BR
    dia = diag(state);
    if abs(sum(dia)) == 3
        winner = true;
        coord = dia;
        p1 = [0.25,2.75];
        p2 = [2.75,0.25];
    end
    
    % TR to BL
    dia = diag(fliplr(state));
    if abs(sum(dia)) == 3
        winner = true;
        coord = dia;
        p1 = [0.25,2.75];
        p2 = [0.25,2.75];
    end

    if winner == true && coord(1) == -1
        id = -1;
    elseif winner == true && coord(1) ==1
        id = 1;
    else
        id = 0;
    end
end



%% 
function [bestscore, depthout] = minimax(state, depth, minimizingPlayer)
    
    [winner, id] = eval_winner(state);
    
 
    %checks winning condition (terminal condition to end search)
    if depth == 0 || winner == true
        if id == 0
            bestscore = 0;
        else
            bestscore = id*Inf;
        end

        depthout = depth;
        
    else
        
        if minimizingPlayer == true
     
            % assume maximizing player is only computer (test assign -1)
            bestscore = Inf;
            
            for i = 1:9
               if state(i) == 0
                   
                   state(i) = -1;
    
                   %recursive switch to simulate user player to maximize
                   [score, depthout] = minimax(state, depth-1, false);
                   
                   state(i) = 0;
                   bestscore = min(score, bestscore);
               end
            end
        
        else    
            
            bestscore = -Inf;
                
            for i = 1:9
                if state(i) == 0
    
                    state(i) =1;
                   
                    %recursive switch to simulate computer player to minimize
                   [score, depthout] = minimax(state, depth-1, true);
    
                   state(i) = 0;
                   bestscore = max(score, bestscore);
                end
            end
        end
    end
end

    
         
