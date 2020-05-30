classdef echoLure < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    properties
         position
         starttime
         angleDisp
         freq
         receiveIntensitySensitivity
         pulsetiming
         triggered
     end
    
    methods
        function obj = echoLure(posx,posy,ad,f,sens,pulsetim)
            obj.position = [posx posy];
            obj.starttime = 1000000;
            obj.angleDisp = ad;
            obj.freq = f;
            obj.receiveIntensitySensitivity = sens;
            obj.pulsetiming =pulsetim;
            obj.triggered = 0;
        end
        function obj = setTime(obj,t)
            if obj.triggered ==0
                obj.starttime = t;
            end
            obj.triggered =1;
        end
                function bol = detected(obj,param)
            robj = sqrt((param(1)-obj.position(1))^2 + (param(2)-obj.position(2))^2);
            if (robj<param(3) || robj>param(4))
                bol = 0;
            else
                %yref = param(4)*param(7)+ param(2);
                %xref = param(4)*param(6) +param(1);
                ang = atand(abs(param(1)- obj.position(1)) /(abs(param(2) - obj.position(2))));
                if (ang <(param(5)/2))
                    bol = 1;
                else 
                    bol = 0;
                end
            end
        end
        
        function wav = pulse(obj)
            wav = Wave(obj.position,1531,obj.angleDisp,0,[0 1],30000);
        end
        function obj = addPattern(obj,xshift,yshift,waittime)
            y = 200-obj.position(2);
            d = sqrt(y^2+xshift^2);%distance btwn AE and recieve point of US
            h= y-yshift; %h is determined from desired offset
            t_delay = 2*h/1531;
            t_travel = d/1531;
            t_aLine_delay = xshift*waittime;
            t_total= t_delay -t_travel + t_aLine_delay;
            obj.pulsetiming = [obj.pulsetiming t_total]
        end
        function bol = checkpulse(obj,time,step)
            for i=1:length(obj.pulsetiming)
                desiredTime = obj.pulsetiming(i);
                elapsedTime = time -obj.starttime;
                if (desiredTime > elapsedTime - step  && desiredTime <elapsedTime+step)
                    bol = 1;
                    break;
                else 
                    bol =0;
                end
            end
        end
    end
       
end
