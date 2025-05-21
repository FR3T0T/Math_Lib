% ElektroMatBibTrinvis.m - MATLAB Matematisk Bibliotek med Trinvise Forklaringer
% Dette bibliotek er en udvidelse af ElektroMatBib og tilføjer detaljerede
% trinvise forklaringer til matematiske operationer.
%
% Udvikler: Frederik Tots
% Version: 3.0
% Dato: 21/5/2025
% Opdateret med Symbolic Math Toolbox understøttelse

classdef ElektroMatBibTrinvis
    methods(Static)
        %% FORKLARINGSSYSTEM %%
        function forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring(titel)
            forklaringsOutput = ElektroMat.Forklaringssystem.startForklaring(titel);
        end
        
        function forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel)
            if nargin < 5
                forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst);
            else
                forklaringsOutput = ElektroMat.Forklaringssystem.tilfoejTrin(forklaringsOutput, trinNummer, trinTitel, trinTekst, formel);
            end
        end
        
        function forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, resultat)
            forklaringsOutput = ElektroMat.Forklaringssystem.afslutForklaring(forklaringsOutput, resultat);
        end
        
        %% SYMBOLSK FORMATERING %%
        function formatteret = formatMatematisk(expr)
            formatteret = ElektroMat.Symbolsk.formatMatematisk(expr);
        end
        
        function visMatematisk(expr, titel)
            if nargin < 2
                ElektroMat.Symbolsk.visMatematisk(expr);
            else
                ElektroMat.Symbolsk.visMatematisk(expr, titel);
            end
        end
        
        function sym_expr = tekstTilSymbolsk(tekst)
            sym_expr = ElektroMat.Symbolsk.tekstTilSymbolsk(tekst);
        end
        
        function latex_str = symbTilLatex(expr)
            latex_str = ElektroMat.Symbolsk.symbTilLatex(expr);
        end
        
        function forbedretExpr = forbedreSymbolskVisning(expr)
            forbedretExpr = ElektroMat.Symbolsk.forbedreSymbolskVisning(expr);
        end
        
        %% LAPLACE TRANSFORMATIONER MED TRINVISE FORKLARINGER %%
        function [F, forklaringsOutput] = laplaceMedForklaring(f, t, s)
            [F, forklaringsOutput] = ElektroMat.Laplace.laplaceMedForklaring(f, t, s);
        end
        
        function [f, forklaringsOutput] = inversLaplaceMedForklaring(F, s, t)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.inversLaplaceMedForklaring(F, s, t);
        end
        
        %% NYE LAPLACE FUNKTIONER (UDVIDELSE) %%
        function [y, forklaringsOutput] = beregnUdgangssignalMedForklaring(H_s, X_s, s, t)
            [y, forklaringsOutput] = ElektroMat.LTI_Systemer.beregnUdgangssignalMedForklaring(H_s, X_s, s, t);
        end
        
        function [G, forklaringsOutput] = diffLaplaceMedForklaring(F_s, s, n)
            [G, forklaringsOutput] = ElektroMat.Laplace.diffLaplaceMedForklaring(F_s, s, n);
        end
        
        %% FOURIER TRANSFORMATIONER MED TRINVISE FORKLARINGER (NYE) %%
        function [F, forklaringsOutput] = fourierMedForklaring(f, t, omega)
            [F, forklaringsOutput] = ElektroMat.Fourier.fourierMedForklaring(f, t, omega);
        end
        
        function [F_d, forklaringsOutput] = fourierAfledtMedForklaring(f, t, omega, n)
            [F_d, forklaringsOutput] = ElektroMat.Fourier.fourierAfledtMedForklaring(f, t, omega, n);
        end
        
        function [F_t, forklaringsOutput] = fourierTidMultiplikationMedForklaring(f, t, omega, n, kompleks)
            if nargin < 5
                [F_t, forklaringsOutput] = ElektroMat.Fourier.fourierTidMultiplikationMedForklaring(f, t, omega, n);
            else
                [F_t, forklaringsOutput] = ElektroMat.Fourier.fourierTidMultiplikationMedForklaring(f, t, omega, n, kompleks);
            end
        end
        
        function [F_scaled, forklaringsOutput] = fourierSkaleringMedForklaring(f, t, omega, a, b)
            [F_scaled, forklaringsOutput] = ElektroMat.Fourier.fourierSkaleringMedForklaring(f, t, omega, a, b);
        end
        
        function [F_int, forklaringsOutput] = fourierIntegralMedForklaring(f, t, omega)
            [F_int, forklaringsOutput] = ElektroMat.Fourier.fourierIntegralMedForklaring(f, t, omega);
        end
        
        function [F_inv, forklaringsOutput] = fourierAfFourierMedForklaring(f, t, omega)
            [F_inv, forklaringsOutput] = ElektroMat.Fourier.fourierAfFourierMedForklaring(f, t, omega);
        end
        
        function [series_trig, forklaringsOutput] = fourierRaekkeOmskrivningMedForklaring(cn, t, T, N)
            [series_trig, forklaringsOutput] = ElektroMat.Fourier.fourierRaekkeOmskrivningMedForklaring(cn, t, T, N);
        end
        
        %% FUNKTIONSANALYSEFUNKTIONER %%
        function [ftype, params] = analyserFunktion(f, t)
            [ftype, params] = ElektroMat.Funktionsanalyse.analyserFunktion(f, t);
        end
        
        function [Ftype, params] = analyserLaplaceFunktion(F, s)
            [Ftype, params] = ElektroMat.Funktionsanalyse.analyserLaplaceFunktion(F, s);
        end
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR LAPLACE TRANSFORMATIONER %%
        function [F, forklaringsOutput] = forklarKonstant(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarKonstant(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarPolynom(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarPolynom(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarExp(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExp(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarSin(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarSin(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarCos(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarCos(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarExpSin(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpSin(f, t, s, params, forklaringsOutput);
        end
        
        function [F, forklaringsOutput] = forklarExpCos(f, t, s, params, forklaringsOutput)
            [F, forklaringsOutput] = ElektroMat.Laplace.forklarExpCos(f, t, s, params, forklaringsOutput);
        end
        
        function forklaringsOutput = forklarGenerel(f, t, s, forklaringsOutput)
            forklaringsOutput = ElektroMat.Laplace.forklarGenerel(f, t, s, forklaringsOutput);
        end
        
        %% TRIN-FOR-TRIN FORKLARINGER FOR INVERS LAPLACE TRANSFORMATIONER %%
        function [f, forklaringsOutput] = forklarInversKonstant(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversKonstant(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversSimplePol(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversSimplePol(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversDoublePol(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversDoublePol(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversKvadratisk(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversKvadratisk(F, s, t, params, forklaringsOutput);
        end
        
        function [f, forklaringsOutput] = forklarInversPartielBrok(F, s, t, params, forklaringsOutput)
            [f, forklaringsOutput] = ElektroMat.InversLaplace.forklarInversPartielBrok(F, s, t, params, forklaringsOutput);
        end
        
        function forklaringsOutput = forklarInversGenerel(F, s, t, forklaringsOutput)
            forklaringsOutput = ElektroMat.InversLaplace.forklarInversGenerel(F, s, t, forklaringsOutput);
        end
        
        %% LTI SYSTEM FUNKTIONER MED TRINVISE FORKLARINGER %%
        function [num, den, forklaringsOutput] = diffLigningTilOverfoeringsfunktionMedForklaring(b, a)
            [num, den, forklaringsOutput] = ElektroMat.LTI_Systemer.diffLigningTilOverfoeringsfunktionMedForklaring(b, a);
        end
        
        function forklaringsOutput = analyserDifferentialligningMedForklaring(a)
            forklaringsOutput = ElektroMat.LTI_Systemer.analyserDifferentialligningMedForklaring(a);
        end
        
        function [t, y, forklaringsOutput] = beregnStepresponsMedForklaring(num, den, t_range)
            [t, y, forklaringsOutput] = ElektroMat.LTI_Systemer.beregnStepresponsMedForklaring(num, den, t_range);
        end
        
        function forklaringsOutput = visBodeDiagramMedForklaring(num, den, omega_range)
            forklaringsOutput = ElektroMat.LTI_Systemer.visBodeDiagramMedForklaring(num, den, omega_range);
        end
        
        %% KOMPLETTE ANALYSERAPPORTER MED TRINVISE FORKLARINGER %%
        function kompletSystemAanalyse(num, den, system_navn)
            if nargin < 3
                ElektroMat.KompletteAnalyser.kompletSystemAanalyse(num, den);
            else
                ElektroMat.KompletteAnalyser.kompletSystemAanalyse(num, den, system_navn);
            end
        end
        
        function RLCKredsloebsAnalyse(R, L, C)
            ElektroMat.KompletteAnalyser.RLCKredsloebsAnalyse(R, L, C);
        end
        
        function FourierAnalyse(f, t_range, f_navn)
            if nargin < 3
                ElektroMat.KompletteAnalyser.FourierAnalyse(f, t_range);
            else
                ElektroMat.KompletteAnalyser.FourierAnalyse(f, t_range, f_navn);
            end
        end
        
        %% FOLDNING OG FOLDNINGSSÆTNING FUNKTIONER %%
        function [h, forklaringsOutput] = foldningMedForklaring(f, g, t, t_range)
            [h, forklaringsOutput] = ElektroMat.Foldning.foldningMedForklaring(f, g, t, t_range);
        end
        
        function [H, forklaringsOutput] = foldningssaetningMedForklaring(F, G, s, t)
            [H, forklaringsOutput] = ElektroMat.Foldning.foldningssaetningMedForklaring(F, G, s, t);
        end
        
        %% SPECIELLE FUNKTIONER %%
        function [F, forklaringsOutput] = deltaFunktionMedForklaring(t0, t, s)
            [F, forklaringsOutput] = ElektroMat.SpecielleFunktioner.deltaFunktionMedForklaring(t0, t, s);
        end
        
        function [F, forklaringsOutput] = enhedsTrinMedForklaring(t0, t, s)
            [F, forklaringsOutput] = ElektroMat.SpecielleFunktioner.enhedsTrinMedForklaring(t0, t, s);
        end
        
        function [F, forklaringsOutput] = forsinkelsesRegelMedForklaring(f_expr, t0, t, s)
            [F, forklaringsOutput] = ElektroMat.SpecielleFunktioner.forsinkelsesRegelMedForklaring(f_expr, t0, t, s);
        end
        
        function [f_t, forklaringsOutput] = stykkevisFunktionMedForklaring(func_liste, graenser, t)
            [f_t, forklaringsOutput] = ElektroMat.SpecielleFunktioner.stykkevisFunktionMedForklaring(func_liste, graenser, t);
        end
        
        %% FOURIERRÆKKE FUNKTIONER %%
        function [cn, forklaringsOutput] = fourierKoefficienterMedForklaring(f, t, T)
            [cn, forklaringsOutput] = ElektroMat.Fourier.fourierKoefficienterMedForklaring(f, t, T);
        end
        
        function [f_approx, forklaringsOutput] = fourierRaekkeMedForklaring(cn, t, T, N)
            [f_approx, forklaringsOutput] = ElektroMat.Fourier.fourierRaekkeMedForklaring(cn, t, T, N);
        end
        
        function [P, forklaringsOutput] = parsevalTeoremMedForklaring(cn, N)
            [P, forklaringsOutput] = ElektroMat.Fourier.parsevalTeoremMedForklaring(cn, N);
        end
        
        %% ENERGI- OG EFFEKTTÆTHEDSFUNKTIONER %%
        function [E, forklaringsOutput] = energiTaethedMedForklaring(F, omega)
            [E, forklaringsOutput] = ElektroMat.Energi_og_Effekt.energiTaethedMedForklaring(F, omega);
        end
        
        function [P, forklaringsOutput] = effektTaethedMedForklaring(F, omega)
            [P, forklaringsOutput] = ElektroMat.Energi_og_Effekt.effektTaethedMedForklaring(F, omega);
        end
    end
end