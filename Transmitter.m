classdef Transmitter < handle 
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        position;
        timeStamp;
        positionStamp;
        time;
        angleDisp;
        freq;
        receiveIntensitySensitivity; 
    end
    
    methods
        function obj = Transmitter(posx,posy,t,ad,f,sens)
            obj.position = [posx posy];
            obj.timeStamp = [];
            obj.positionStamp = [];
            obj.time = t;
            obj.angleDisp = ad;
            obj.freq = f;
            obj.receiveIntensitySensitivity = sens;
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
        function obj = movePosition(obj,delX, delY)
            obj.position(1) = obj.position(1) + delX;
            obj.position(2) = obj.position(2) + delY;
        end
        function obj = addRcvSig(obj,ref)
            obj.timeStamp = [obj.timeStamp obj.time-ref];
            obj.positionStamp = [obj.positionStamp ;obj.position];
        end
        function wav = genSig(obj)
            wav = Wave(obj.position,1531,obj.angleDisp,0,[0 -1],30000);
        end
        function obj = timeInc(obj,step)
            obj.time = obj.time + step;
        end
        function p = getPosition(obj)
            p = obj.position;
        end
        function ts = getTimeStamps(obj)
            ts = obj.timeStamp;
        end
        function ps = getPosStamps(obj)
            ps = obj.positionStamp;
        end
        function t = getTime(obj)
            t = obj.time;
        end
        function sens = getSens(obj)
            sens = obj.receiveIntensitySensitivity;
        end
    end
    
end

