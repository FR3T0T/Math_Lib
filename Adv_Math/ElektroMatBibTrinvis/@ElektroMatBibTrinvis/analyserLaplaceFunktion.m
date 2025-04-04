
        
        function [Ftype, params] = analyserLaplaceFunktion(F, s)
            % ANALYSERLAPLACEFUNCTION Analyserer en Laplace-funktion og identificerer dens type
            %
            % Syntax:
            %   [Ftype, params] = ElektroMatBibTrinvis.analyserLaplaceFunktion(F, s)
            %
            % Input:
            %   F - funktion af s (symbolsk)
            %   s - kompleks variabel (symbolsk)
            % 
            % Output:
            %   Ftype - funktionstype ('konstant', 'simpel_pol', 'dobbelt_pol', etc.)
            %   params - parametre for funktionen
            
            % Initialiser
            Ftype = 'generel';
            params = struct();
            
            % Tjek for konstant
            if ~has(F, s)
                Ftype = 'konstant';
                params.value = F;
                return;
            end