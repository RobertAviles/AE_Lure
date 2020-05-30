classdef Wave < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        startPos;
        velocity;
        angleDisp;
        time;
        dir;
        intensity;
        initial_intensity;
    end
    
    methods
        function obj = Wave(sp,v,ad,t,d,i_0)
            obj.startPos = sp;
            obj.velocity = v;
            obj.angleDisp = ad;
            obj.time = t;
            obj.dir = d;
            obj.initial_intensity = i_0;
            obj.intensity = obj.initial_intensity;
        end
        function obj = propagate(obj,step)
            obj.time = obj.time + step;
            
        end
        function param = checkHit(obj,step)
            time1 = obj.time;
            time2 = obj.time + step;
            r1 =  obj.velocity * time1;
            r2 =  obj.velocity *time2;
            x0 = obj.startPos(1);
            y0 = obj.startPos(2);
            theta = obj.angleDisp;
            dirx = obj.dir(1);
            diry = obj.dir(2);
            param = [x0 y0 r1 r2 theta dirx diry];
        end
        function prop = getProp(obj)
            v = obj.velocity;
            ad = obj.angleDisp;
            dx = obj.dir(1);
            dy = obj.dir(2);
            intens = obj.intensity;
            prop = [v ad dx dy intens];
        end
        function updateIntensity(obj)
            obj.intensity = obj.initial_intensity./((1.351*obj.time)^2);
        end
        function intens = getIntensity(obj)
            intens = obj.intensity;
        end
        
    end
end
    
