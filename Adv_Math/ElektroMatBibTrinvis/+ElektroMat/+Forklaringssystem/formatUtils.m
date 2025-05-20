% +ElektroMat/+Forklaringssystem/formatUtils.m
classdef formatUtils
    methods(Static)
        function formateret_tekst = konverterTilLatex(tekst)
            % KONVERTERTILLATEX Konverterer almindelig tekst til LaTeX-formateret tekst
            % for visning i MATLAB Live Script
            
            % Håndter tom input
            if isempty(tekst)
                formateret_tekst = '';
                return;
            end
            
            % Konverter til streng hvis symbolsk
            if isa(tekst, 'sym')
                tekst = char(tekst);
            end
            
            formateret_tekst = tekst;
            
            % ================ MATEMATISKE SYMBOLER OG OPERATORER ================
            formateret_tekst = strrep(formateret_tekst, 'sum_', '\sum_');
            formateret_tekst = strrep(formateret_tekst, 'int_', '\int_');
            formateret_tekst = strrep(formateret_tekst, 'omega_0', '\omega_0');
            formateret_tekst = strrep(formateret_tekst, 'pi', '\pi');
            formateret_tekst = strrep(formateret_tekst, '{-oo}', '{-\infty}');
            formateret_tekst = strrep(formateret_tekst, '{oo}', '{\infty}');
            formateret_tekst = strrep(formateret_tekst, 'infty', '\infty');
            formateret_tekst = strrep(formateret_tekst, 'infinity', '\infty');
            
            % ================ TRIGONOMETRISKE FUNKTIONER ================
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])sin\(', '$1\sin(');
            formateret_tekst = regexprep(formateret_tekst, '^sin\(', '\sin(');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])cos\(', '$1\cos(');
            formateret_tekst = regexprep(formateret_tekst, '^cos\(', '\cos(');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])tan\(', '$1\tan(');
            formateret_tekst = regexprep(formateret_tekst, '^tan\(', '\tan(');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])exp\(', '$1\exp(');
            formateret_tekst = regexprep(formateret_tekst, '^exp\(', '\exp(');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])log\(', '$1\log(');
            formateret_tekst = regexprep(formateret_tekst, '^log\(', '\log(');
            
            % ================ GRÆSKE BOGSTAVER ================
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])alpha([^a-zA-Z])', '$1\alpha$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])beta([^a-zA-Z])', '$1\beta$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])gamma([^a-zA-Z])', '$1\gamma$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])delta([^a-zA-Z])', '$1\delta$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])epsilon([^a-zA-Z])', '$1\epsilon$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])zeta([^a-zA-Z])', '$1\zeta$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])eta([^a-zA-Z])', '$1\eta$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])theta([^a-zA-Z])', '$1\theta$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])iota([^a-zA-Z])', '$1\iota$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])kappa([^a-zA-Z])', '$1\kappa$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])lambda([^a-zA-Z])', '$1\lambda$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])mu([^a-zA-Z])', '$1\mu$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])nu([^a-zA-Z])', '$1\nu$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])xi([^a-zA-Z])', '$1\xi$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])omicron([^a-zA-Z])', '$1\omicron$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])tau([^a-zA-Z])', '$1\tau$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])upsilon([^a-zA-Z])', '$1\upsilon$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])phi([^a-zA-Z])', '$1\phi$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])chi([^a-zA-Z])', '$1\chi$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])psi([^a-zA-Z])', '$1\psi$2');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])omega([^a-zA-Z])', '$1\omega$2');
            
            % Start og slut af streng håndtering
            formateret_tekst = regexprep(formateret_tekst, '^pi([^a-zA-Z])', '\pi$1');
            formateret_tekst = regexprep(formateret_tekst, '^pi$', '\pi');
            formateret_tekst = regexprep(formateret_tekst, '([^a-zA-Z])pi$', '$1\pi');
            
            % ================ KOMPLEKSE TAL ================
            formateret_tekst = regexprep(formateret_tekst, '([0-9])i([^a-zA-Z0-9])', '$1\mathrm{i}$2');
            formateret_tekst = regexprep(formateret_tekst, '([0-9])i$', '$1\mathrm{i}');
            
            % ================ PIECEWISE FUNKTION ================
            % Særlig håndtering af "piecewise" ord for at undgå fejl
            formateret_tekst = strrep(formateret_tekst, 'p\mathrm{i}ecew\mathrm{i}se', 'piecewise');
            formateret_tekst = strrep(formateret_tekst, '\pi ecewise', 'piecewise');
            
            % ================ TEKSTFORMATERING ================
            % Mellemrum og operatorer i LaTeX
            formateret_tekst = strrep(formateret_tekst, ' - ', ' \, - \, ');
            formateret_tekst = strrep(formateret_tekst, ' + ', ' \, + \, ');
            formateret_tekst = strrep(formateret_tekst, ' * ', ' \cdot ');
            
            % ================ EFTERBEHANDLING ================
            % Håndter typiske LaTeX-kommandoer direkte
            formateret_tekst = strrep(formateret_tekst, '\\sum', '\sum');
            formateret_tekst = strrep(formateret_tekst, '\\int', '\int');
            formateret_tekst = strrep(formateret_tekst, '\\cdot', '\cdot');
            formateret_tekst = strrep(formateret_tekst, '\\text', '\text');
        end
        
        function visFormula(formula_text)
            % VISFORMULA Viser en formel formateret som LaTeX i MATLAB Live Script
            
            % Konverter formlen til LaTeX
            formula_text = formatUtils.konverterTilLatex(formula_text);
            
            % Brug displayFormula til at vise i Live Script
            try
                displayFormula(formula_text);
            catch e
                % Hvis displayFormula ikke findes, brug disp
                disp(['LaTeX: ' formula_text]);
            end
        end
        
        function str = formatNumber(num)
            % FORMATNUMBER Formaterer et tal til et pænt LaTeX-kompatibelt format
            %
            % Syntax:
            %   str = formatUtils.formatNumber(num)
            %
            % Input:
            %   num - Tal, der skal formateres
            %
            % Output:
            %   str - Formateret talstreng klar til LaTeX
            
            % Kontrollér om tallet er komplekst
            if ~isreal(num)
                re = real(num);
                im = imag(num);
                
                % Formatér reel og imaginær del separat
                re_str = formatUtils.formatNumber(re);
                im_str = formatUtils.formatNumber(abs(im));
                
                % Sammensæt streng med korrekt fortegn
                if im > 0
                    str = [re_str ' + ' im_str 'i'];
                else
                    str = [re_str ' - ' im_str 'i'];
                end
                return;
            end
            
            % For meget små tal, bare vis 0
            if abs(num) < 1e-10
                str = '0';
                return;
            end
            
            % Håndter forskellige talstørrelser 
            if abs(num) >= 1000 || abs(num) < 0.01
                % Brug videnskabelig notation for meget store eller små tal
                str = sprintf('%.4e', num);
            else
                % Brug fast notation med passende antal decimaler
                if abs(num - round(num)) < 1e-10
                    % Heltal
                    str = sprintf('%d', round(num));
                else
                    % Decimaltal med 4 decimaler
                    str = sprintf('%.4f', num);
                    % Fjern efterstillede nuller
                    str = regexprep(str, '0+$', '');
                    % Fjern punktum hvis der ikke er decimaler tilbage
                    str = regexprep(str, '\.$', '');
                end
            end
        end
    end
end