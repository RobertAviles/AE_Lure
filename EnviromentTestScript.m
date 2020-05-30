
fishFinder = Transmitter(50,200,0,30,50000,0.01);
step = 0.001; %1./fishfinder.freq;,
xlimit = 710;
delx = 5;
dely = 0;
waitTime = 0.261;
A_Line = (2.5*step +waitTime)/delx;
pulses = [];
AE = echoLure(300,50,30,50000,0.01,pulses);
%add J pattern
AE.addPattern(5,9,A_Line);
AE.addPattern(15,6,A_Line);
AE.addPattern(15,3,A_Line);
AE.addPattern(15,0,A_Line);
AE.addPattern(25,9,A_Line);
AE.addPattern(10,0,A_Line);
AE.addPattern(5,0,A_Line);
AE.addPattern(5,3,A_Line);
AE.addPattern(15,9,A_Line);
AE.addPattern(10,9,A_Line);
AE.addPattern(20,9,A_Line);
%add H pattern
AE.addPattern(35,9,A_Line);
AE.addPattern(35,6,A_Line);
AE.addPattern(35,3,A_Line);
AE.addPattern(35,0,A_Line);
AE.addPattern(55,9,A_Line);
AE.addPattern(55,6,A_Line);
AE.addPattern(55,3,A_Line);
AE.addPattern(55,0,A_Line);
AE.addPattern(50,4,A_Line);
AE.addPattern(40,4,A_Line);
AE.addPattern(45,4,A_Line);
%add U pattern
AE.addPattern(65,9,A_Line);
AE.addPattern(65,6,A_Line);
AE.addPattern(65,3,A_Line);
AE.addPattern(65,0,A_Line);
AE.addPattern(80,9,A_Line);
AE.addPattern(80,6,A_Line);
AE.addPattern(80,3,A_Line);
AE.addPattern(80,0,A_Line);
AE.addPattern(75,0,A_Line);
AE.addPattern(70,0,A_Line);

wavAr = [];
%%adjustable parameters

intThresh = fishFinder.getSens();
fishAr = {Fish(100,20),Fish(690,59),Fish(120,40), Fish(650,160),Fish(360,100),Fish(355,89), Fish(368,100),Fish(470,80),Fish(470,100),Fish(500,180),Fish(550,75)};
%%end adjustable parameters
p = fishFinder.getPosition();
pstart=p;
while (p(1) <= xlimit)
    wavAr =[wavAr fishFinder.genSig()];
    timeInit = fishFinder.getTime();
    time = timeInit;
    while (time - timeInit < waitTime)
        fishFinder.timeInc(step);
        time = fishFinder.getTime();
        for It =1:length(wavAr) %propagate waves
            wavAr(It).propagate(step);
            wavAr(It).updateIntensity;
        end
        for i =1:length(fishAr) %see if wave hits fish
            for j =1:length(wavAr)
                if ((fishAr{i}.detected(wavAr(j).checkHit(step))) ) %&& (wavAr(j).getIntensity > intThresh))
                    props = wavAr(j).getProp();
                    if (props(4) <= 0)
                        refw = fishAr{i}.ReflectSignal(wavAr(j).getProp());
                        length(refw);
                        wavAr =[wavAr refw];
                    
                    %if waveAr(j) == decayed
                    %remove(waveAr(j)
                    
                    %end
                    %j = j+1; %%so that reflected wave cant 'hit' fish again;
                    end
                end
            end
        end
        newwavAr = wavAr;
        for (k = 1:length(wavAr)) %see if wave hits transmitter
            if fishFinder.detected(wavAr(k).checkHit(step))
                fishFinder.addRcvSig(timeInit);
                
                newwavAr = [wavAr(1:k-1) wavAr(k+1:length(wavAr))]; %remove wave
            end
            if (AE.detected(wavAr(k).checkHit(step)))
                AE.setTime(time);
            end
        end
        if (AE.checkpulse(time,step))
            newwavAr = [newwavAr AE.pulse()];
        end
        wavAr = newwavAr;
    end
    fishFinder.movePosition(delx,dely);
    p = fishFinder.getPosition();
end
Pos =fishFinder.getPosStamps();
num_found = size(Pos);
fishx = zeros(1,num_found(1));
fishy = fishx;
times = fishFinder.getTimeStamps();
for (i =1:num_found(1))
    fishx(i) = Pos(i);
    fishy(i) = Pos(i,2) - (0.5*times(i)*1531);
end
plot(fishx,fishy,'.b', 'MarkerSize',10);
hold on;


xlim([0 1000]);%-100+pstart(1) xlimit+100]);
ylim([0 pstart(2)])




