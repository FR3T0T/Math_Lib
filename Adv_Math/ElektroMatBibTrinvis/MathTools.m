% Create file: MathTools.m in your main directory
classdef MathTools
    methods(Static)
        function [F, forklaringsOutput] = enhedsTrin_med_forklaring(t0, t, s)
            % Call the actual function from the library
            try
                % Way 1: Try direct file execution
                forklaringsOutput = startForklaring('Enhedstrinfunktionen');
                
                % Add the other steps from your original function
                % ...
                
                % Calculate F
                if t0 > 0
                    F = exp(-s*t0)/s;
                elseif t0 == 0
                    F = 1/s;
                else
                    F = 1/s;
                end
                
                forklaringsOutput = afslutForklaring(forklaringsOutput, ...
                    ['L{u(t-' char(t0) ')} = ' char(F)]);
            catch ME
                warning('Failed to execute function: %s', ME.message);
                F = NaN;
                forklaringsOutput = struct();
            end
        end
        
        % Add other wrapper methods
        % ...
    end
end