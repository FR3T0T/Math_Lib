
        
        function [ftype, params] = analyserFunktion(f, t)
            % ANALYSERFUNKTION Analyserer en funktion og identificerer dens type
            %
            % Syntax:
            %   [ftype, params] = ElektroMatBibTrinvis.analyserFunktion(f, t)
            %
            % Input:
            %   f - funktion af t (symbolsk)
            %   t - tidsvariabel (symbolsk)
            % 
            % Output:
            %   ftype - funktionstype ('konstant', 'polynom', 'exp', etc.)
            %   params - parametre for funktionen
            
            % Initialiser
            ftype = 'generel';
            params = struct();
            
            % Tjek for konstant
            if ~has(f, t)
                ftype = 'konstant';
                params.value = f;
                return;
            end