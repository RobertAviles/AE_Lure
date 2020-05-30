classdef Fish < handle
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pos
    end
    
    methods
        function obj = Fish(posx,posy)
            obj.pos = [posx posy];
        end
        function bol = detected(obj,param)
            robj = sqrt((param(1)-obj.pos(1))^2 + (param(2)-obj.pos(2))^2);
            if (robj<param(3) || robj>param(4))
                bol = 0;
            else
                %yref = param(4)*param(7)+ param(2);
                %xref = param(4)*param(6) +param(1);
                ang = atand(abs(param(1)- obj.pos(1)) /(abs(param(2) - obj.pos(2))));
                if (ang <(param(5)/2))
                    bol = 1;
                else 
                    bol = 0;
                end
            end
        end
        function wav = ReflectSignal(obj,wavprop)
            %if (wavprop(4)<=0)
            wav = Wave(obj.pos,wavprop(1),wavprop(2),0,[-wavprop(3) -wavprop(4)], wavprop(5));
            %else
                %wav ='';
            %end
        end
       
    end
end

