% ElektroMathSolver - Forbedret version
% Et avanceret værktøj til elektromatematiske beregninger under eksamen
% Understøtter Laplace, Fourier, LTI-systemer, differentialligninger og mere

% Hovedfigur med tastaturgenveje
fig = figure('Name', 'ElektroMath Problem Solver', ...
            'NumberTitle', 'off', ...
            'MenuBar', 'none', ...
            'Position', [100, 100, 1000, 650], ...
            'KeyPressFcn', @handleKeyPress);

% Opret en filmenulinje
fileMenu = uimenu(fig, 'Label', 'Fil');
uimenu(fileMenu, 'Label', 'Gem resultat...', 'Callback', @saveResult);
uimenu(fileMenu, 'Label', 'Eksporter til LaTeX', 'Callback', @exportToLatex);
uimenu(fileMenu, 'Label', 'Afslut', 'Separator', 'on', 'Callback', 'close(gcbf)');

toolsMenu = uimenu(fig, 'Label', 'Værktøjer');
uimenu(toolsMenu, 'Label', 'Formelbibliotek', 'Callback', @openFormulaLibrary);
uimenu(toolsMenu, 'Label', 'Ryd historik', 'Callback', @clearHistory);

helpMenu = uimenu(fig, 'Label', 'Hjælp');
uimenu(helpMenu, 'Label', 'Tastaturgenveje', 'Callback', @showKeyboardShortcuts);
uimenu(helpMenu, 'Label', 'Om ElektroMathSolver', 'Callback', @showAbout);

% Opret tab-panel
mainPanel = uipanel('Parent', fig, 'Position', [0, 0.15, 0.7, 0.85]);
tabGroup = uitabgroup('Parent', mainPanel);

% Opret tabs for hver kategori
lapTab = uitab(tabGroup, 'Title', 'Laplace');
fourierTab = uitab(tabGroup, 'Title', 'Fourier');
ltiTab = uitab(tabGroup, 'Title', 'LTI Systemer');
diffEqTab = uitab(tabGroup, 'Title', 'Diff. Ligninger');
rlcTab = uitab(tabGroup, 'Title', 'RLC Kredsløb');
specFuncTab = uitab(tabGroup, 'Title', 'Spec. Funktioner');
formulaTab = uitab(tabGroup, 'Title', 'Formler');

% Opret historikpanel
historyPanel = uipanel('Parent', fig, 'Title', 'Beregningshistorik', ...
                     'Position', [0.7, 0.15, 0.3, 0.85]);

% Opret historikliste
historyList = uicontrol('Parent', historyPanel, 'Style', 'listbox', ...
                       'Position', [10, 40, 280, 505], ...
                       'Tag', 'historyList', ...
                       'FontName', 'Consolas', ...
                       'Callback', @loadFromHistory);

% Knapper for historik
uicontrol('Parent', historyPanel, 'Style', 'pushbutton', ...
         'String', 'Genbrug valgt', ...
         'Position', [10, 10, 135, 25], ...
         'Callback', @loadFromHistory);

uicontrol('Parent', historyPanel, 'Style', 'pushbutton', ...
         'String', 'Ryd historik', ...
         'Position', [155, 10, 135, 25], ...
         'Callback', @clearHistory);

% Opret log-panel i bunden
logPanel = uipanel('Parent', fig, 'Title', 'Log', ...
                  'Position', [0, 0, 1, 0.15]);

logText = uicontrol('Parent', logPanel, 'Style', 'edit', ...
                   'Position', [10, 10, 980, 80], ...
                   'Max', 5, ... % Tillad flere linjer
                   'HorizontalAlignment', 'left', ...
                   'Tag', 'logText', ...
                   'FontName', 'Consolas', ...
                   'FontSize', 9, ...
                   'Enable', 'inactive');

% Initialiser historik
if ~isappdata(fig, 'history')
    setappdata(fig, 'history', {});
end

% Opsæt alle faner
setupLaplaceTab(lapTab);
setupFourierTab(fourierTab);
setupLTITab(ltiTab);
setupDiffEqTab(diffEqTab);
setupRLCTab(rlcTab);
setupSpecialFunctionsTab(specFuncTab);
setupFormulaLibrary(formulaTab);

% Log initial meddelelse
logMessage('ElektroMath Problem Solver startet. Klar til eksamen!', fig);
logMessage('GENVEJSTASTER: 1-6 skifter tab, R kører beregning, C kopierer resultat', fig);

% ------------------------------------------------------------------------
% Hjælpefunktioner til faneblade
% ------------------------------------------------------------------------

function setupLaplaceTab(tab)
    % Opret layout for Laplace-transformationer
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Opret knapsæt
    bg = uibuttongroup('Parent', panel, 'Title', 'Operation', ...
                 'Position', [0.05, 0.80, 0.4, 0.15], ...
                 'SelectionChangedFcn', @laplaceModeChanged);
    
    % Tilføj radioknapper til valg af operation
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
             'String', 'Direkte Laplace-transformation', ...
             'Position', [10, 30, 250, 30], ...
             'Tag', 'directLap', ...
             'TooltipString', 'Beregn Laplacetransformation af f(t)');
    
    uicontrol('Parent', bg, 'Style', 'radiobutton', ...
             'String', 'Invers Laplace-transformation', ...
             'Position', [10, 0, 250, 30], ...
             'Tag', 'inverseLap', ...
             'TooltipString', 'Beregn den inverse Laplacetransformation af F(s)');
    
    % Standardindstillingen er direkte transformation
    set(findobj(bg, 'Tag', 'directLap'), 'Value', 1);
    
    % Input-felt til funktion
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Indtast funktion:', ...
             'Position', [30, 385, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    inputField = uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [150, 385, 400, 30], ...
             'Tag', 'functionInput', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas', ...
             'FontSize', 10);
    
    % Quick-help knap ved siden af input
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', '?', ...
             'Position', [560, 385, 30, 30], ...
             'Callback', @showLaplaceInputHelp, ...
             'TooltipString', 'Vis hjælp til input-format');
    
    % Information om funktionsformat
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Eksempel: exp(-2*t)*cos(3*t) eller s/(s^2+4)', ...
             'Position', [150, 355, 400, 20], ...
             'HorizontalAlignment', 'left', ...
             'FontAngle', 'italic');
    
    % Template-vælger for almindelige funktioner
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Almindelige funktioner:', ...
             'Position', [30, 320, 120, 30], ...
             'HorizontalAlignment', 'left');
    
    templates = {'Vælg template...', ...
                 'exp(-a*t)', ...
                 'sin(a*t)', ...
                 'cos(a*t)', ...
                 't^n*exp(-a*t)', ...
                 'exp(-a*t)*sin(b*t)', ...
                 'exp(-a*t)*cos(b*t)', ...
                 '1/(s^2+a^2)', ...
                 's/(s^2+a^2)', ...
                 '1/((s+a)^2+b^2)'};
    
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', templates, ...
             'Position', [150, 325, 200, 20], ...
             'Tag', 'laplaceTemplate', ...
             'Callback', @insertLaplaceTemplate);
    
    % Beregningsknap
    computeBtn = uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Beregn transformation', ...
             'Position', [150, 275, 150, 40], ...
             'FontWeight', 'bold', ...
             'Tag', 'laplaceComputeBtn', ...
             'Callback', @computeLaplace);
    
    % Knap til at tilføje til historik
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Føj til historik', ...
             'Position', [320, 275, 120, 40], ...
             'Callback', {@addToHistory, 'Laplace'});
    
    % LaTeX-knap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Kopier som LaTeX', ...
             'Position', [460, 275, 120, 40], ...
             'Callback', @copyAsLaTeX);
    
    % Resultatområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Resultat:', ...
             'Position', [30, 235, 100, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [150, 235, 440, 30], ...
             'Tag', 'resultOutput', ...
             'Enable', 'inactive', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas', ...
             'FontSize', 10, ...
             'FontWeight', 'bold');
    
    % Forklaringsområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Trinvis forklaring:', ...
             'Position', [30, 205, 120, 20], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 170], ...
             'Tag', 'explanationOutput', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
end

function laplaceModeChanged(src, event)
    % Håndter valg af Laplace-transformationstype
    mode = get(event.NewValue, 'String');
    fig = ancestor(src, 'figure');
    
    % Opdater eksemplerne baseret på valgt tilstand
    if strcmp(mode, 'Direkte Laplace-transformation')
        set(findobj(fig, 'Style', 'text', 'String', 'Eksempel: exp(-2*t)*cos(3*t) eller s/(s^2+4)'), ...
            'String', 'Eksempel: exp(-2*t)*cos(3*t) eller t^2*exp(-a*t)');
        updateLaplaceTemplates(fig, true);
    else
        set(findobj(fig, 'Style', 'text', 'String', 'Eksempel: exp(-2*t)*cos(3*t) eller t^2*exp(-a*t)'), ...
            'String', 'Eksempel: s/(s^2+4) eller 1/((s+1)*(s+2))');
        updateLaplaceTemplates(fig, false);
    end
end

function updateLaplaceTemplates(fig, isDirectMode)
    templateCtrl = findobj(fig, 'Tag', 'laplaceTemplate');
    
    if isDirectMode
        templates = {'Vælg template...', ...
                     'exp(-a*t)', ...
                     'sin(a*t)', ...
                     'cos(a*t)', ...
                     't^n*exp(-a*t)', ...
                     'exp(-a*t)*sin(b*t)', ...
                     'exp(-a*t)*cos(b*t)', ...
                     'u(t-a)', ...
                     'delta(t-a)'};
    else
        templates = {'Vælg template...', ...
                     '1/(s-a)', ...
                     '1/(s-a)^2', ...
                     'a/(s^2+a^2)', ...
                     's/(s^2+a^2)', ...
                     '1/((s+a)^2+b^2)', ...
                     'b/((s+a)^2+b^2)'};
    end
    
    set(templateCtrl, 'String', templates);
    set(templateCtrl, 'Value', 1);
end

function insertLaplaceTemplate(src, event)
    % Indsæt valgt template i input-feltet
    fig = ancestor(src, 'figure');
    idx = get(src, 'Value');
    
    if idx == 1
        return;  % "Vælg template" blev valgt
    end
    
    templates = get(src, 'String');
    selectedTemplate = templates{idx};
    
    % Indsæt den valgte template i input-feltet
    set(findobj(fig, 'Tag', 'functionInput'), 'String', selectedTemplate);
    
    % Nulstil dropdown til "Vælg template..."
    set(src, 'Value', 1);
end

function showLaplaceInputHelp(src, event)
    % Vis hjælp til Laplace-input format
    helpFig = figure('Name', 'Laplace Input Hjælp', ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'Position', [300, 300, 500, 400]);
                    
    uicontrol('Parent', helpFig, 'Style', 'text', ...
             'String', {'Laplace Transformation Input Guide:', '', ...
                       '• Tidsvariabel: t', ...
                       '• Kompleks variabel: s', ...
                       '• Eksponentialfunktion: exp(-a*t) eller e^(-a*t)', ...
                       '• Trigonometriske funktioner: sin(a*t), cos(a*t)', ...
                       '• Polynomier: t^2 + 3*t + 4', ...
                       '• Potens: t^n, s^2', ...
                       '• Brøker: 1/(s^2+4) eller (s+1)/(s^2-4)', ...
                       '• Specialfunktioner: u(t) (enhedstrin), delta(t) (delta-funktion)', ...
                       '', ...
                       'Eksempler på direkte transformation:', ...
                       '• exp(-3*t)*sin(2*t)    →    2/((s+3)^2+4)', ...
                       '• t^2*exp(-t)    →    2/(s+1)^3', ...
                       '', ...
                       'Eksempler på invers transformation:', ...
                       '• 1/(s^2+4)    →    (1/2)*sin(2*t)', ...
                       '• s/((s+1)*(s+2))    →    2*exp(-t) - exp(-2*t)'}, ...
             'Position', [20, 20, 460, 360], ...
             'HorizontalAlignment', 'left');
end

function computeLaplace(src, event)
    % Udfør Laplace-transformation beregning
    fig = ancestor(src, 'figure');
    
    % Få brugerinput
    functionStr = get(findobj(fig, 'Tag', 'functionInput'), 'String');
    
    % Tjek om inputtet er tomt
    if isempty(functionStr)
        logMessage('Fejl: Indtast venligst en funktion', fig);
        return;
    end
    
    % Tjek hvilken tilstand der er valgt
    bg = findobj(fig, 'Title', 'Operation'); 
    directMode = get(findobj(bg, 'Tag', 'directLap'), 'Value');
    
    % Opret symbolske variable
    syms t s;
    
    % Ryd tidligere output
    set(findobj(fig, 'Tag', 'resultOutput'), 'String', '');
    set(findobj(fig, 'Tag', 'explanationOutput'), 'String', {});
    
    % Start beregning
    logMessage('Starter Laplace-transformation...', fig);
    
    try
        % Erstat e^(...) med exp(...)
        functionStr = regexprep(functionStr, 'e\^', 'exp');
        
        if directMode
            % Direkte Laplace-transformation: f(t) -> F(s)
            f_t = sym(functionStr);
            logMessage(['Beregner Laplace-transformation af f(t) = ' char(f_t)], fig);
            
            % Udfør transformation
            [F_s, explanation] = ElektroMatBibTrinvis.laplaceMedForklaring(f_t, t, s);
            
            % Vis resultat
            set(findobj(fig, 'Tag', 'resultOutput'), 'String', char(F_s));
            
            % Vis trinvis forklaring
            displayExplanation(explanation, fig);
            
            logMessage('Laplace-transformation beregnet!', fig);
        else
            % Invers Laplace-transformation: F(s) -> f(t)
            F_s = sym(functionStr);
            logMessage(['Beregner invers Laplace-transformation af F(s) = ' char(F_s)], fig);
            
            % Udfør invers transformation
            [f_t, explanation] = ElektroMatBibTrinvis.inversLaplaceMedForklaring(F_s, s, t);
            
            % Vis resultat
            set(findobj(fig, 'Tag', 'resultOutput'), 'String', char(f_t));
            
            % Vis trinvis forklaring
            displayExplanation(explanation, fig);
            
            logMessage('Invers Laplace-transformation beregnet!', fig);
        end
        
        % Føj til historik automatisk
        addToHistory([], [], 'Laplace', fig);
        
    catch e
        logMessage(['Fejl: ' e.message], fig);
        set(findobj(fig, 'Tag', 'resultOutput'), 'String', 'Fejl i beregning. Tjek syntax.');
    end
end

function setupFourierTab(tab)
    % Opret layout for Fourier-analyse
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Vælg operationstype
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Vælg operation:', ...
             'Position', [30, 520, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    operationTypes = {'Fourier-transformation', 'Fourier-rækkekoefficienter', 'Fourier-række approksimation'};
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', operationTypes, ...
             'Position', [160, 525, 230, 25], ...
             'Tag', 'fourierOperation', ...
             'Callback', @fourierModeChanged);
    
    % Quick-help knap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', '?', ...
             'Position', [400, 525, 30, 25], ...
             'Callback', @showFourierInputHelp, ...
             'TooltipString', 'Vis hjælp til Fourier-analyse');
    
    % Input-felt til funktion
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Indtast funktion f(t):', ...
             'Position', [30, 475, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [160, 480, 400, 30], ...
             'Tag', 'fourierFunctionInput', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas', ...
             'FontSize', 10);
    
    % Information om funktionsformat
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Eksempel: exp(-t)*sin(2*t) eller cos(t)^2', ...
             'Position', [160, 450, 400, 20], ...
             'HorizontalAlignment', 'left', ...
             'FontAngle', 'italic');
    
    % Templates for almindelige funktioner
    templates = {'Vælg template...', ...
                 'sin(a*t)', ...
                 'cos(a*t)', ...
                 'sin(a*t)*cos(b*t)', ...
                 'exp(-a*t)*sin(b*t)', ...
                 'exp(-a*t)*cos(b*t)', ...
                 'cos(t)^2', ...
                 'sin(t)^2'};
    
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Almindelige funktioner:', ...
             'Position', [30, 420, 120, 30], ...
             'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', templates, ...
             'Position', [160, 425, 200, 20], ...
             'Tag', 'fourierTemplate', ...
             'Callback', @insertFourierTemplate);
    
    % Periode input (for Fourier-række)
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Periode (T):', ...
             'Position', [30, 380, 120, 25], ...
             'HorizontalAlignment', 'left', ...
             'Tag', 'periodLabel', ...
             'Visible', 'off');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [160, 380, 100, 25], ...
             'Tag', 'periodInput', ...
             'String', '2*pi', ...
             'HorizontalAlignment', 'left', ...
             'Visible', 'off');
    
    % Antal led (for Fourier række approksimation)
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Antal led:', ...
             'Position', [280, 380, 120, 25], ...
             'HorizontalAlignment', 'left', ...
             'Tag', 'termsLabel', ...
             'Visible', 'off');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [380, 380, 80, 25], ...
             'Tag', 'termsInput', ...
             'String', '5', ...
             'HorizontalAlignment', 'left', ...
             'Visible', 'off');
    
    % Beregningsknap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Beregn', ...
             'Position', [160, 330, 150, 40], ...
             'FontWeight', 'bold', ...
             'Tag', 'fourierComputeBtn', ...
             'Callback', @computeFourier);
    
    % Knap til at tilføje til historik
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Føj til historik', ...
             'Position', [320, 330, 120, 40], ...
             'Callback', {@addToHistory, 'Fourier'});
    
    % Resultatområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Resultat:', ...
             'Position', [30, 280, 100, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [160, 285, 440, 35], ...
             'Tag', 'fourierResultOutput', ...
             'Enable', 'inactive', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas', ...
             'FontSize', 10, ...
             'FontWeight', 'bold', ...
             'Max', 2);  % Tillad flere linjer
    
    % Forklaringsområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Trinvis forklaring:', ...
             'Position', [30, 250, 120, 20], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 215], ...
             'Tag', 'fourierExplanationOutput', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
end

function fourierModeChanged(src, event)
    % Opdater Fourier-fane baseret på valgt operation
    fig = ancestor(src, 'figure');
    selectedIndex = get(src, 'Value');
    
    % Viser/skjuler felter baseret på valg
    periodVisible = selectedIndex > 1; % Vis til Fourier-række
    termsVisible = selectedIndex == 3; % Vis til approksimation
    
    set(findobj(fig, 'Tag', 'periodLabel'), 'Visible', iif(periodVisible, 'on', 'off'));
    set(findobj(fig, 'Tag', 'periodInput'), 'Visible', iif(periodVisible, 'on', 'off'));
    set(findobj(fig, 'Tag', 'termsLabel'), 'Visible', iif(termsVisible, 'on', 'off'));
    set(findobj(fig, 'Tag', 'termsInput'), 'Visible', iif(termsVisible, 'on', 'off'));
end

function insertFourierTemplate(src, event)
    % Indsæt valgt template i input-feltet
    fig = ancestor(src, 'figure');
    idx = get(src, 'Value');
    
    if idx == 1
        return;  % "Vælg template" blev valgt
    end
    
    templates = get(src, 'String');
    selectedTemplate = templates{idx};
    
    % Indsæt den valgte template i input-feltet
    set(findobj(fig, 'Tag', 'fourierFunctionInput'), 'String', selectedTemplate);
    
    % Nulstil dropdown til "Vælg template..."
    set(src, 'Value', 1);
end

function showFourierInputHelp(src, event)
    % Vis hjælp til Fourier-input format
    helpFig = figure('Name', 'Fourier Analyse Hjælp', ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'Position', [300, 300, 500, 400]);
                    
    uicontrol('Parent', helpFig, 'Style', 'text', ...
             'String', {'Fourier Analyse Input Guide:', '', ...
                       '• Tidsvariabel: t', ...
                       '• Eksponentialfunktion: exp(-a*t) eller e^(-a*t)', ...
                       '• Trigonometriske funktioner: sin(a*t), cos(a*t)', ...
                       '• Polynomier: t^2 + 3*t + 4', ...
                       '• Potens: t^n', ...
                       '', ...
                       'Fourier-transformation:', ...
                       '• Transformerer en funktion fra tidsdomæne til frekvensdomæne', ...
                       '• Resultat gives som funktion af ω', ...
                       '', ...
                       'Fourier-rækkekoefficienter:', ...
                       '• Beregner Fourier-koefficienterne cn for periodiske funktioner', ...
                       '• Kræver angivelse af periode T', ...
                       '• For reelle funktioner er c₋ₙ = cₙ*', ...
                       '', ...
                       'Fourier-række approksimation:', ...
                       '• Approksimerer en periodisk funktion med et endeligt antal led', ...
                       '• Kræver periode T og antal led N', ...
                       '• Højere N giver bedre approksimation'}, ...
             'Position', [20, 20, 460, 360], ...
             'HorizontalAlignment', 'left');
end

function computeFourier(src, event)
    % Håndter Fourier-beregninger baseret på valgt tilstand
    fig = ancestor(src, 'figure');
    selectedIndex = get(findobj(fig, 'Tag', 'fourierOperation'), 'Value');
    functionStr = get(findobj(fig, 'Tag', 'fourierFunctionInput'), 'String');
    
    % Tjek om inputtet er tomt
    if isempty(functionStr)
        logMessage('Fejl: Indtast venligst en funktion', fig);
        return;
    }
    
    % Ryd tidligere output
    set(findobj(fig, 'Tag', 'fourierResultOutput'), 'String', '');
    set(findobj(fig, 'Tag', 'fourierExplanationOutput'), 'String', {});
    
    % Symbolske variable
    syms t omega;
    
    try
        % Erstat e^(...) med exp(...)
        functionStr = regexprep(functionStr, 'e\^', 'exp');
        f_t = sym(functionStr);
        
        switch selectedIndex
            case 1 % Fourier-transformation
                logMessage('Beregner Fourier-transformation...', fig);
                [F, explanation] = ElektroMatBibTrinvis.fourierMedForklaring(f_t, t, omega);
                
                % Vis resultat
                set(findobj(fig, 'Tag', 'fourierResultOutput'), 'String', char(F));
                displayExplanation(explanation, fig, 'fourierExplanationOutput');
                
            case 2 % Fourier-rækkekoefficienter
                periodStr = get(findobj(fig, 'Tag', 'periodInput'), 'String');
                try
                    % Konverter periode-streng til symbolsk udtryk
                    T = sym(periodStr);
                    T_val = double(T);
                    
                    if isnan(T_val) || T_val <= 0
                        logMessage('Fejl: Ugyldig periode. Skal være et positivt tal.', fig);
                        return;
                    end
                catch
                    logMessage('Fejl: Kunne ikke fortolke perioden. Brug tal eller simple udtryk.', fig);
                    return;
                end
                
                logMessage(['Beregner Fourier-rækkekoefficienter med periode T = ' char(T) '...'], fig);
                [cn, explanation] = ElektroMatBibTrinvis.fourierKoefficienterMedForklaring(f_t, t, T);
                
                % Formater koefficienter til visning
                c0 = cn.c0;
                coefStr = ['c₀ = ' num2str(c0, '%.6f')];
                
                % Vis nogle positive og negative koefficienter
                for k = 1:5
                    if isfield(cn, ['c' num2str(k)])
                        c_pos = cn.(['c' num2str(k)]);
                        coefStr = [coefStr newline 'c₍' num2str(k) '₎ = ' num2str(c_pos, '%.6f')];
                    end
                    
                    if isfield(cn, ['cm' num2str(k)])
                        c_neg = cn.(['cm' num2str(k)]);
                        coefStr = [coefStr newline 'c₍₋' num2str(k) '₎ = ' num2str(c_neg, '%.6f')];
                    end
                end
                
                % Vis resultater
                set(findobj(fig, 'Tag', 'fourierResultOutput'), 'String', coefStr);
                displayExplanation(explanation, fig, 'fourierExplanationOutput');
                
            case 3 % Fourier-række approksimation
                periodStr = get(findobj(fig, 'Tag', 'periodInput'), 'String');
                termsStr = get(findobj(fig, 'Tag', 'termsInput'), 'String');
                
                try
                    % Konverter periode-streng til symbolsk udtryk
                    T = sym(periodStr);
                    T_val = double(T);
                    
                    if isnan(T_val) || T_val <= 0
                        logMessage('Fejl: Ugyldig periode. Skal være et positivt tal.', fig);
                        return;
                    end
                catch
                    logMessage('Fejl: Kunne ikke fortolke perioden. Brug tal eller simple udtryk.', fig);
                    return;
                end
                
                try
                    N = str2double(termsStr);
                    if isnan(N) || N <= 0 || mod(N,1) ~= 0
                        logMessage('Fejl: Ugyldigt antal led. Skal være et positivt heltal.', fig);
                        return;
                    end
                catch
                    logMessage('Fejl: Kunne ikke fortolke antal led.', fig);
                    return;
                end
                
                logMessage(['Beregner Fourier-række approksimation med ' num2str(N) ' led...'], fig);
                
                % Først beregn koefficienter
                [cn, ~] = ElektroMatBibTrinvis.fourierKoefficienterMedForklaring(f_t, t, T);
                
                % Derefter beregn approksimation
                [f_approx, explanation] = ElektroMatBibTrinvis.fourierRaekkeMedForklaring(cn, t, T, N);
                
                % Vis resultater
                set(findobj(fig, 'Tag', 'fourierResultOutput'), 'String', char(f_approx));
                displayExplanation(explanation, fig, 'fourierExplanationOutput');
        end
        
        logMessage('Fourier-beregning gennemført!', fig);
        
        % Føj til historik automatisk
        addToHistory([], [], 'Fourier', fig);
        
    catch e
        logMessage(['Fejl: ' e.message], fig);
        set(findobj(fig, 'Tag', 'fourierResultOutput'), 'String', 'Fejl i beregning. Tjek syntax.');
    end
end

function setupLTITab(tab)
    % Opret layout for LTI-systemer
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Vælg operation
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Vælg operation:', ...
             'Position', [30, 520, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    operationTypes = {'Overføringsfunktion-analyse', 'Step-respons', 'Bode-plot'};
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', operationTypes, ...
             'Position', [160, 525, 230, 25], ...
             'Tag', 'ltiOperation');
    
    % Quick-help knap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', '?', ...
             'Position', [400, 525, 30, 25], ...
             'Callback', @showLTIInputHelp, ...
             'TooltipString', 'Vis hjælp til LTI-system input');
    
    % Tæller-koefficienter
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Tæller-koefficienter:', ...
             'Position', [30, 480, 130, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [170, 485, 300, 30], ...
             'Tag', 'numCoefInput', ...
             'String', '[1 0]', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    % Nævner-koefficienter
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Nævner-koefficienter:', ...
             'Position', [30, 440, 130, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [170, 445, 300, 30], ...
             'Tag', 'denCoefInput', ...
             'String', '[1 2 5]', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    % Format-forklaring
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Format: [a_n a_{n-1} ... a_1 a_0] for a_n*s^n + a_{n-1}*s^{n-1} + ... + a_1*s + a_0', ...
             'Position', [170, 415, 420, 25], ...
             'HorizontalAlignment', 'left', ...
             'FontAngle', 'italic');
    
    % Almindelige systemer
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Almindelige systemer:', ...
             'Position', [30, 380, 130, 30], ...
             'HorizontalAlignment', 'left');
    
    systemTemplates = {'Vælg system...', ...
                      'Første ordens lavpasfilter: [1], [1 1]', ...
                      'Anden ordens lavpasfilter: [1], [1 1.4 1]', ...
                      'Anden ordens højpasfilter: [1 0 0], [1 1.4 1]', ...
                      'Integrator: [1], [1 0]', ...
                      'Differentiator: [1 0], [1]', ...
                      'PID-controller: [Kd Kp Ki], [1 0]', ...
                      'Underdæmpet system: [1], [1 0.4 1]', ...
                      'Kritisk dæmpet system: [1], [1 2 1]', ...
                      'Overdæmpet system: [1], [1 3 1]'};
    
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', systemTemplates, ...
             'Position', [170, 385, 300, 25], ...
             'Tag', 'ltiSystemTemplate', ...
             'Callback', @insertLTITemplate);
    
    % Beregningsknap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Analyser system', ...
             'Position', [170, 340, 150, 40], ...
             'FontWeight', 'bold', ...
             'Tag', 'ltiComputeBtn', ...
             'Callback', @analyzeLTISystem);
    
    % Knap til at tilføje til historik
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Føj til historik', ...
             'Position', [330, 340, 120, 40], ...
             'Callback', {@addToHistory, 'LTI'});
    
    % Resultatområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'System information:', ...
             'Position', [30, 300, 150, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 270], ...
             'Tag', 'ltiOutputInfo', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
end

function insertLTITemplate(src, event)
    % Indsæt valgt LTI system template
    fig = ancestor(src, 'figure');
    idx = get(src, 'Value');
    
    if idx == 1
        return;  % "Vælg system" blev valgt
    end
    
    templates = get(src, 'String');
    selectedTemplate = templates{idx};
    
    % Udtræk num og den fra template-strengen
    [~, remain] = strtok(selectedTemplate, ':');
    coeffs = strtrim(remain(2:end));
    [numStr, denStr] = strtok(coeffs, ',');
    denStr = strtrim(denStr(2:end));
    
    % Indsæt de valgte værdier
    set(findobj(fig, 'Tag', 'numCoefInput'), 'String', numStr);
    set(findobj(fig, 'Tag', 'denCoefInput'), 'String', denStr);
    
    % Nulstil dropdown til "Vælg system..."
    set(src, 'Value', 1);
end

function showLTIInputHelp(src, event)
    % Vis hjælp til LTI-system input
    helpFig = figure('Name', 'LTI System Input Hjælp', ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'Position', [300, 300, 500, 400]);
                    
    uicontrol('Parent', helpFig, 'Style', 'text', ...
             'String', {'LTI System Input Guide:', '', ...
                       '• Overføringsfunktion på formen: H(s) = num(s)/den(s)', ...
                       '• Koefficienter skal indtastes som vektorer: [a_n a_{n-1} ... a_1 a_0]', ...
                       '• Koefficienterne svarer til polynomier på formen:', ...
                       '   a_n*s^n + a_{n-1}*s^{n-1} + ... + a_1*s + a_0', ...
                       '', ...
                       'Eksempler:', ...
                       '', ...
                       '• Første ordens system H(s) = 1/(s+1):', ...
                       '  Tæller: [1]', ...
                       '  Nævner: [1 1]', ...
                       '', ...
                       '• Anden ordens system H(s) = ω²/(s² + 2ζω·s + ω²):', ...
                       '  For ω = 1, ζ = 0.7:', ...
                       '  Tæller: [1]', ...
                       '  Nævner: [1 1.4 1]', ...
                       '', ...
                       '• Integrator H(s) = 1/s:', ...
                       '  Tæller: [1]', ...
                       '  Nævner: [1 0]', ...
                       '', ...
                       '• Differentiator H(s) = s:', ...
                       '  Tæller: [1 0]', ...
                       '  Nævner: [1]'}, ...
             'Position', [20, 20, 460, 360], ...
             'HorizontalAlignment', 'left');
end

function analyzeLTISystem(src, event)
    % Håndter LTI-system analyse
    fig = ancestor(src, 'figure');
    selectedIndex = get(findobj(fig, 'Tag', 'ltiOperation'), 'Value');
    
    % Hent systemkoefficienter
    numStr = get(findobj(fig, 'Tag', 'numCoefInput'), 'String');
    denStr = get(findobj(fig, 'Tag', 'denCoefInput'), 'String');
    
    % Ryd tidligere output
    set(findobj(fig, 'Tag', 'ltiOutputInfo'), 'String', {});
    
    try
        % Konverter streng til koefficient-array
        numStr = strrep(numStr, ',', ' ');
        denStr = strrep(denStr, ',', ' ');
        
        num = str2num(numStr); %#ok<ST2NM>
        den = str2num(denStr); %#ok<ST2NM>
        
        if isempty(num) || isempty(den)
            logMessage('Fejl: Ugyldigt koefficient-format', fig);
            return;
        end
        
        switch selectedIndex
            case 1 % Overføringsfunktion-analyse
                logMessage('Analyserer differentialligning...', fig);
                forklaringsOutput = ElektroMatBibTrinvis.analyserDifferentialligningMedForklaring(den);
                
                % Vis nøgleinformation om systemet
                displaySystemInfo(num, den, forklaringsOutput, fig);
                
            case 2 % Step-respons
                logMessage('Beregner step-respons...', fig);
                [t, y, forklaringsOutput] = ElektroMatBibTrinvis.beregnStepresponsMedForklaring(num, den, [0, 20]);
                
                % Funktionen opretter automatisk en figur
                % Logger blot at det er gennemført
                logMessage('Step-respons beregnet og vist i figur.', fig);
                
                % Vis nøgleinformation i listboxen
                displaySystemInfo(num, den, forklaringsOutput, fig);
                
            case 3 % Bode-plot
                logMessage('Genererer Bode-diagram...', fig);
                forklaringsOutput = ElektroMatBibTrinvis.visBodeDiagramMedForklaring(num, den, [0.01, 100]);
                
                % Funktionen opretter automatisk en figur
                logMessage('Bode-diagram genereret og vist i figur.', fig);
                
                % Vis nøgleinformation i listboxen
                displaySystemInfo(num, den, forklaringsOutput, fig);
        end
        
        % Føj til historik automatisk
        addToHistory([], [], 'LTI', fig);
        
    catch e
        logMessage(['Fejl: ' e.message], fig);
    end
end

function displaySystemInfo(num, den, forklaringsOutput, fig)
    % Formatterer nøgleinformation om systemet til visning
    infoLines = {};
    
    % Overføringsfunktion information
    syms s;
    H_s = poly2sym(num, s) / poly2sym(den, s);
    infoLines{end+1} = ['Overføringsfunktion H(s) = ' char(H_s)];
    infoLines{end+1} = '';
    
    % Poler og nulpunkter
    poles = roots(den);
    zeros = roots(num);
    
    infoLines{end+1} = 'System poler:';
    for i = 1:length(poles)
        if imag(poles(i)) == 0
            infoLines{end+1} = ['  p' num2str(i) ' = ' num2str(poles(i))];
        else
            infoLines{end+1} = ['  p' num2str(i) ' = ' num2str(real(poles(i))) ' + ' num2str(imag(poles(i))) 'i'];
        end
    end
    infoLines{end+1} = '';
    
    infoLines{end+1} = 'System nulpunkter:';
    if isempty(zeros)
        infoLines{end+1} = '  (Ingen nulpunkter)';
    else
        for i = 1:length(zeros)
            if imag(zeros(i)) == 0
                infoLines{end+1} = ['  z' num2str(i) ' = ' num2str(zeros(i))];
            else
                infoLines{end+1} = ['  z' num2str(i) ' = ' num2str(real(zeros(i))) ' + ' num2str(imag(zeros(i))) 'i'];
            end
        end
    end
    infoLines{end+1} = '';
    
    % System type og stabilitet
    infoLines{end+1} = 'System egenskaber:';
    if all(real(poles) < 0)
        infoLines{end+1} = '  Stabilitet: STABIL (alle poler i venstre halvplan)';
    else
        infoLines{end+1} = '  Stabilitet: USTABIL (poler i højre halvplan)';
    end
    
    % Forsøg at identificere systemtype
    if length(den) > 1 && den(end) == 0
        % Mindst én pol i nul
        numZeroPoles = sum(den == 0);
        infoLines{end+1} = ['  Systemtype: ' num2str(numZeroPoles)];
    else
        infoLines{end+1} = '  Systemtype: 0';
    end
    
    % Hvis det er et anden ordens system, vis dæmpning og naturlig frekvens
    if length(den) == 3
        try
            a = den(1);
            b = den(2);
            c = den(3);
            
            omega_n = sqrt(c/a);
            zeta = b/(2*sqrt(a*c));
            
            infoLines{end+1} = '';
            infoLines{end+1} = 'Anden ordens system parametre:';
            infoLines{end+1} = ['  Naturlig frekvens (ω_n): ' num2str(omega_n, '%.4f') ' rad/s'];
            infoLines{end+1} = ['  Dæmpningsforhold (ζ): ' num2str(zeta, '%.4f')];
            
            if zeta < 1
                % Underdæmpet system
                infoLines{end+1} = '  System type: UNDERDÆMPET (ζ < 1)';
                
                % Beregn oversving og indsvingningstid
                pct_overshoot = 100 * exp(-pi * zeta / sqrt(1 - zeta^2));
                settling_time = 4 / (zeta * omega_n);
                rise_time = 1.8 / omega_n;  % Approksimation
                
                infoLines{end+1} = ['  Oversving: ' num2str(pct_overshoot, '%.2f') '%'];
                infoLines{end+1} = ['  Indsvingningstid (2%): ' num2str(settling_time, '%.4f') ' s'];
                infoLines{end+1} = ['  Stigetid (10-90%): ' num2str(rise_time, '%.4f') ' s'];
            elseif zeta == 1
                % Kritisk dæmpet system
                infoLines{end+1} = '  System type: KRITISK DÆMPET (ζ = 1)';
                infoLines{end+1} = ['  Indsvingningstid: ' num2str(4/omega_n, '%.4f') ' s'];
            else
                % Overdæmpet system
                infoLines{end+1} = '  System type: OVERDÆMPET (ζ > 1)';
                infoLines{end+1} = ['  Indsvingningstid: ' num2str(4/omega_n, '%.4f') ' s'];
            end
        catch
            % Ignorer fejl i beregningen af dæmpning
        end
    end
    
    % Vis informationen
    set(findobj(fig, 'Tag', 'ltiOutputInfo'), 'String', infoLines);
end

function setupDiffEqTab(tab)
    % Opret layout for differentiallignings-fane
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Dette er en simplere brugerflade fokuseret på direkte analyse af differentialligninger
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Indtast differentiallignings-koefficienter:', ...
             'Position', [30, 520, 300, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Format: [a_n, a_{n-1}, ..., a_1, a_0] for a_n*y^(n) + a_{n-1}*y^(n-1) + ... + a_1*y'' + a_0*y = 0', ...
             'Position', [30, 490, 560, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontAngle', 'italic');
    
    % Koefficient-input
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Koefficienter a:', ...
             'Position', [30, 450, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [160, 455, 300, 30], ...
             'Tag', 'diffEqCoefInput', ...
             'String', '[1, 3, 2]', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    % Almindelige differentialligninger
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Almindelige differentialligninger:', ...
             'Position', [30, 410, 200, 30], ...
             'HorizontalAlignment', 'left');
    
    diffEqTemplates = {'Vælg differentialligning...', ...
                       'Første ordens: [1, 1] (y'' + y = 0)', ...
                       'Anden ordens underdæmpet: [1, 0.4, 1] (y'''' + 0.4y'' + y = 0)', ...
                       'Anden ordens kritisk dæmpet: [1, 2, 1] (y'''' + 2y'' + y = 0)', ...
                       'Anden ordens overdæmpet: [1, 3, 1] (y'''' + 3y'' + y = 0)', ...
                       'Homogen ligning: [1, 0, 1, 0] (y'''''' + y'' = 0)', ...
                       'RLC kredsløb: [L, R, 1/C] (L·d²i/dt² + R·di/dt + (1/C)·i = 0)'};
    
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', diffEqTemplates, ...
             'Position', [240, 415, 350, 25], ...
             'Tag', 'diffEqTemplate', ...
             'Callback', @insertDiffEqTemplate);
    
    % Beregningsknap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Analyser ligning', ...
             'Position', [160, 360, 150, 40], ...
             'FontWeight', 'bold', ...
             'Tag', 'diffEqAnalyzeBtn', ...
             'Callback', @analyzeDiffEq);
    
    % Knap til at tilføje til historik
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Føj til historik', ...
             'Position', [320, 360, 120, 40], ...
             'Callback', {@addToHistory, 'DiffEq'});
    
    % Resultatområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Analyse:', ...
             'Position', [30, 310, 100, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 280], ...
             'Tag', 'diffEqOutput', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
end

function insertDiffEqTemplate(src, event)
    % Indsæt valgt differentialligning template
    fig = ancestor(src, 'figure');
    idx = get(src, 'Value');
    
    if idx == 1
        return;  % "Vælg differentialligning" blev valgt
    end
    
    templates = get(src, 'String');
    selectedTemplate = templates{idx};
    
    % Udtræk koefficienter fra template-strengen
    [~, remain] = strtok(selectedTemplate, ':');
    coefsStr = strtrim(remain(2:end));
    
    % Udtræk koefficient-delen fra parentesen
    startIdx = strfind(coefsStr, '(');
    if ~isempty(startIdx)
        endIdx = strfind(coefsStr, ')');
        if ~isempty(endIdx)
            coefsStr = coefsStr(1:startIdx-1);
        end
    end
    
    % Indsæt de valgte koefficienter
    set(findobj(fig, 'Tag', 'diffEqCoefInput'), 'String', strtrim(coefsStr));
    
    % Nulstil dropdown til "Vælg differentialligning..."
    set(src, 'Value', 1);
end

function analyzeDiffEq(src, event)
    % Håndter differentialligning-analyse
    fig = ancestor(src, 'figure');
    
    % Hent koefficienter
    coefStr = get(findobj(fig, 'Tag', 'diffEqCoefInput'), 'String');
    
    % Ryd tidligere output
    set(findobj(fig, 'Tag', 'diffEqOutput'), 'String', {});
    
    try
        % Parse koefficient-streng - håndter både [1, 2, 3] og [1 2 3] formater
        coefStr = strrep(coefStr, ',', ' ');
        a = str2num(coefStr); %#ok<ST2NM>
        
        if isempty(a)
            logMessage('Fejl: Ugyldigt koefficient-format', fig);
            return;
        end
        
        logMessage('Analyserer differentialligning...', fig);
        forklaringsOutput = ElektroMatBibTrinvis.analyserDifferentialligningMedForklaring(a);
        
        % Formater forklaringstrin
        steps = {};
        for i = 1:length(forklaringsOutput.trin)
            step = forklaringsOutput.trin{i};
            steps{end+1} = ['Trin ' num2str(step.nummer) ': ' step.titel];
            steps{end+1} = ['  ' step.tekst];
            if ~isempty(step.formel)
                steps{end+1} = ['  ' step.formel];
            end
            steps{end+1} = ' '; % Tilføj blank linje mellem trin
        end
        
        % Tilføj slutresultat
        steps{end+1} = ['RESULTAT: ' forklaringsOutput.resultat];
        
        % Vis output
        set(findobj(fig, 'Tag', 'diffEqOutput'), 'String', steps);
        logMessage('Differentialligning-analyse gennemført!', fig);
        
        % Føj til historik automatisk
        addToHistory([], [], 'DiffEq', fig);
        
    catch e
        logMessage(['Fejl: ' e.message], fig);
    end
end

function setupRLCTab(tab)
    % Opret layout for RLC-kredsløbs-fane
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Komponentværdier
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Modstand (R) i Ohm:', ...
             'Position', [30, 520, 150, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [190, 525, 100, 30], ...
             'Tag', 'resistanceInput', ...
             'String', '100', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Induktans (L) i Henry:', ...
             'Position', [30, 480, 150, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [190, 485, 100, 30], ...
             'Tag', 'inductanceInput', ...
             'String', '0.1', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Kapacitans (C) i Farad:', ...
             'Position', [30, 440, 150, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [190, 445, 100, 30], ...
             'Tag', 'capacitanceInput', ...
             'String', '1e-6', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    % Tilbagevendende kredsløbstyper
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Almindelige kredsløbstyper:', ...
             'Position', [320, 480, 150, 30], ...
             'HorizontalAlignment', 'left');
    
    rlcTemplates = {'Vælg kredsløb...', ...
                    'Underdæmpet: R=5 Ω, L=1 H, C=0.1 F', ...
                    'Kritisk dæmpet: R=6.32 Ω, L=1 H, C=0.1 F', ...
                    'Overdæmpet: R=20 Ω, L=1 H, C=0.1 F', ...
                    'Typisk audiofilter: R=10 kΩ, L=1 mH, C=1 µF', ...
                    'RF-kredsløb: R=50 Ω, L=1 µH, C=10 pF', ...
                    'Effektelektronik: R=0.1 Ω, L=1 mH, C=100 µF'};
    
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', rlcTemplates, ...
             'Position', [320, 450, 250, 30], ...
             'Tag', 'rlcTemplate', ...
             'Callback', @insertRLCTemplate);
    
    % Beregningsknap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Analyser kredsløb', ...
             'Position', [190, 390, 150, 40], ...
             'FontWeight', 'bold', ...
             'Tag', 'rlcAnalyzeBtn', ...
             'Callback', @analyzeRLCCircuit);
    
    % Knap til at tilføje til historik
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Føj til historik', ...
             'Position', [350, 390, 120, 40], ...
             'Callback', {@addToHistory, 'RLC'});
    
    % Resultatområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Kredsløbsanalyse resultater:', ...
             'Position', [30, 340, 200, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 310], ...
             'Tag', 'rlcOutput', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
end

function insertRLCTemplate(src, event)
    % Indsæt valgt RLC kredsløbstype
    fig = ancestor(src, 'figure');
    idx = get(src, 'Value');
    
    if idx == 1
        return;  % "Vælg kredsløb" blev valgt
    end
    
    templates = get(src, 'String');
    selectedTemplate = templates{idx};
    
    % Udtræk værdier fra template-strengen
    params = regexp(selectedTemplate, 'R=([^\s,]+)\s+Ω,\s+L=([^\s,]+)\s+([^\s,]+),\s+C=([^\s,]+)\s+([^\s,]+)', 'tokens');
    
    if ~isempty(params)
        params = params{1};
        
        % Fortolk R-værdi
        R = str2double(params{1});
        
        % Fortolk L-værdi og enhed
        L = str2double(params{2});
        L_unit = params{3};
        switch L_unit
            case 'mH'
                L = L * 1e-3;
            case 'µH'
                L = L * 1e-6;
            case 'nH'
                L = L * 1e-9;
        end
        
        % Fortolk C-værdi og enhed
        C = str2double(params{4});
        C_unit = params{5};
        switch C_unit
            case 'mF'
                C = C * 1e-3;
            case 'µF'
                C = C * 1e-6;
            case 'nF'
                C = C * 1e-9;
            case 'pF'
                C = C * 1e-12;
        end
        
        % Indsæt de valgte værdier
        set(findobj(fig, 'Tag', 'resistanceInput'), 'String', num2str(R));
        set(findobj(fig, 'Tag', 'inductanceInput'), 'String', num2str(L));
        set(findobj(fig, 'Tag', 'capacitanceInput'), 'String', num2str(C));
    end
    
    % Nulstil dropdown til "Vælg kredsløb..."
    set(src, 'Value', 1);
end

function analyzeRLCCircuit(src, event)
    % Håndter RLC-kredsløbsanalyse
    fig = ancestor(src, 'figure');
    
    % Hent kredsløbsparametre
    R = str2double(get(findobj(fig, 'Tag', 'resistanceInput'), 'String'));
    L = str2double(get(findobj(fig, 'Tag', 'inductanceInput'), 'String'));
    C = str2double(get(findobj(fig, 'Tag', 'capacitanceInput'), 'String'));
    
    % Ryd tidligere output
    set(findobj(fig, 'Tag', 'rlcOutput'), 'String', {});
    
    try
        % Valider input
        if isnan(R) || isnan(L) || isnan(C) || R < 0 || L <= 0 || C <= 0
            logMessage('Fejl: Ugyldige kredsløbsparametre', fig);
            return;
        end
        
        logMessage('Analyserer RLC-kredsløb...', fig);
        
        % Beregn nøgleparametre
        omega_0 = 1 / sqrt(L * C);  % Naturlig frekvens
        zeta = R / (2 * sqrt(L / C));  % Dæmpningsforhold
        
        % Formater resultater til visning
        results = {};
        results{end+1} = 'RLC-Kredsløbsparametre:';
        results{end+1} = ['Modstand (R): ' num2str(R) ' Ω'];
        results{end+1} = ['Induktans (L): ' num2str(L) ' H'];
        results{end+1} = ['Kapacitans (C): ' num2str(C) ' F'];
        results{end+1} = '';
        
        results{end+1} = 'Kredsløbskarakteristik:';
        results{end+1} = ['Naturlig frekvens (ω₀): ' num2str(omega_0, '%.4f') ' rad/s (' num2str(omega_0/(2*pi), '%.4f') ' Hz)'];
        results{end+1} = ['Dæmpningsforhold (ζ): ' num2str(zeta, '%.4f')];
        results{end+1} = ['Q-faktor: ' num2str(1/(2*zeta), '%.4f')];
        
        % Dæmningsklassifikation
        results{end+1} = '';
        results{end+1} = 'Responsklassifikation:';
        if zeta > 1
            results{end+1} = 'OVERDÆMPET (ζ > 1) - Kredsløbet vil ikke oscillere';
            results{end+1} = 'Kredsløbet vil vende tilbage til ligevægt uden oscillation.';
        elseif abs(zeta - 1) < 1e-6
            results{end+1} = 'KRITISK DÆMPET (ζ = 1) - Hurtigste ikke-oscillerende respons';
            results{end+1} = 'Kredsløbet vil vende tilbage til ligevægt på kortest mulig tid uden oscillation.';
        elseif zeta > 0
            results{end+1} = 'UNDERDÆMPET (0 < ζ < 1) - Kredsløbet vil oscillere med aftagende amplitude';
            
            % Beregn dæmpet frekvens
            omega_d = omega_0 * sqrt(1 - zeta^2);
            results{end+1} = ['Dæmpet frekvens (ω_d): ' num2str(omega_d, '%.4f') ' rad/s (' num2str(omega_d/(2*pi), '%.4f') ' Hz)'];
            
            % Beregn rise time, settling time og overshoot
            rise_time = 1.8 / omega_0;  % Approksimation
            settling_time = 4 / (zeta * omega_0);  % 2% kriterie
            percent_overshoot = 100 * exp(-pi * zeta / sqrt(1 - zeta^2));
            
            results{end+1} = ['Stigetid (10% til 90%): ' num2str(rise_time, '%.4f') ' sekunder'];
            results{end+1} = ['Indsvingningstid (2%): ' num2str(settling_time, '%.4f') ' sekunder'];
            results{end+1} = ['Procent oversving: ' num2str(percent_overshoot, '%.2f') '%'];
        else
            results{end+1} = 'UDÆMPET (ζ = 0) - Kredsløbet vil oscillere kontinuerligt';
            results{end+1} = 'Kredsløbet vil oscillere uden at aftage.';
        end
        
        % Kredsløbsdifferentialligning
        results{end+1} = '';
        results{end+1} = 'Kredsløbsdifferentialligning:';
        results{end+1} = ['L·d²i/dt² + R·di/dt + (1/C)·i = v(t)'];
        results{end+1} = [num2str(L) '·d²i/dt² + ' num2str(R) '·di/dt + ' num2str(1/C) '·i = v(t)'];
        
        % Vis resultaterne
        set(findobj(fig, 'Tag', 'rlcOutput'), 'String', results);
        
        % Kald den aktuelle analysefunktion, som vil generere plotninger
        ElektroMatBibTrinvis.RLCKredsloebsAnalyse(R, L, C);
        
        logMessage('RLC-kredsløbsanalyse gennemført. Se figurer for detaljerede resultater.', fig);
        
        % Føj til historik automatisk
        addToHistory([], [], 'RLC', fig);
        
    catch e
        logMessage(['Fejl: ' e.message], fig);
    end
end

function setupSpecialFunctionsTab(tab)
    % Opret layout for specialfunktioner-fane
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Funktionsvalg
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Vælg funktionstype:', ...
             'Position', [30, 520, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    functionTypes = {'Enhedstrin-funktion', 'Delta-funktion (impuls)', 'Tidsskift (forsinkelsesregel)'};
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', functionTypes, ...
             'Position', [160, 525, 230, 25], ...
             'Tag', 'specialFunctionType', ...
             'Callback', @specialFunctionChanged);
    
    % Quick-help knap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', '?', ...
             'Position', [400, 525, 30, 25], ...
             'Callback', @showSpecialFunctionHelp, ...
             'TooltipString', 'Vis hjælp til specialfunktioner');
    
    % Tidsforskydningsparameter
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Tidsforskydning (t₀):', ...
             'Position', [30, 480, 120, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [160, 485, 100, 25], ...
             'Tag', 'timeShiftInput', ...
             'String', '1', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas');
    
    % Oprindelig funktion (til tidsskiftsregel)
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Oprindelig funktion f(t):', ...
             'Position', [30, 440, 130, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold', ...
             'Tag', 'origFuncLabel', ...
             'Visible', 'off');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [170, 445, 300, 25], ...
             'Tag', 'origFuncInput', ...
             'String', 'exp(-t)', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas', ...
             'Visible', 'off');
    
    % Beregningsknap
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Beregn transformation', ...
             'Position', [160, 390, 150, 40], ...
             'FontWeight', 'bold', ...
             'Tag', 'specialFuncComputeBtn', ...
             'Callback', @computeSpecialFunction);
    
    % Knap til at tilføje til historik
    uicontrol('Parent', panel, 'Style', 'pushbutton', ...
             'String', 'Føj til historik', ...
             'Position', [320, 390, 120, 40], ...
             'Callback', {@addToHistory, 'SpecFunc'});
    
    % Resultatområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Resultat:', ...
             'Position', [30, 340, 100, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [140, 345, 450, 30], ...
             'Tag', 'specialFuncResult', ...
             'Enable', 'inactive', ...
             'HorizontalAlignment', 'left', ...
             'FontName', 'Consolas', ...
             'FontSize', 10, ...
             'FontWeight', 'bold');
    
    % Forklaringsområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Trinvis forklaring:', ...
             'Position', [30, 310, 120, 20], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 280], ...
             'Tag', 'specialFuncExplanation', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
end

function specialFunctionChanged(src, event)
    % Opdater specialfunktioner-fane baseret på valgt funktionstype
    fig = ancestor(src, 'figure');
    selectedIndex = get(src, 'Value');
    
    % Vis/skjul oprindelig funktions-input kun til tidsskiftsregel
    origFuncVisible = selectedIndex == 3;
    set(findobj(fig, 'Tag', 'origFuncLabel'), 'Visible', iif(origFuncVisible, 'on', 'off'));
    set(findobj(fig, 'Tag', 'origFuncInput'), 'Visible', iif(origFuncVisible, 'on', 'off'));
end

function showSpecialFunctionHelp(src, event)
    % Vis hjælp til specialfunktioner
    helpFig = figure('Name', 'Specialfunktioner Hjælp', ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'Position', [300, 300, 500, 400]);
                    
    uicontrol('Parent', helpFig, 'Style', 'text', ...
             'String', {'Specialfunktioner Guide:', '', ...
                       '• Enhedstrin-funktion u(t-t₀):', ...
                       '  - Defineres som: u(t-t₀) = { 0 for t < t₀, 1 for t ≥ t₀ }', ...
                       '  - Laplacetransformation: L{u(t-t₀)} = e^(-s·t₀)/s for t₀ ≥ 0', ...
                       '', ...
                       '• Delta-funktion (impuls) δ(t-t₀):', ...
                       '  - Uendelig smal og høj impuls ved t = t₀', ...
                       '  - Arealet under funktionen er 1', ...
                       '  - Laplacetransformation: L{δ(t-t₀)} = e^(-s·t₀) for t₀ ≥ 0', ...
                       '', ...
                       '• Tidsskift (forsinkelsesregel):', ...
                       '  - Forskydning af en funktion i tid', ...
                       '  - L{f(t-t₀)·u(t-t₀)} = e^(-s·t₀) · L{f(t)}', ...
                       '  - Eksempel: L{e^(-(t-2))·u(t-2)} = e^(-2s) · 1/(s+1)', ...
                       '', ...
                       '• Specialfunktionerne er vigtige byggeblokke i signalanalyse', ...
                       '• De bruges til at modellere diskontinuerte signaler og impulser', ...
                       '• Kombineret med andre funktioner giver de løsninger til mange systemer'}, ...
             'Position', [20, 20, 460, 360], ...
             'HorizontalAlignment', 'left');
end

function computeSpecialFunction(src, event)
    % Håndter specialfunktions-beregning
    fig = ancestor(src, 'figure');
    selectedIndex = get(findobj(fig, 'Tag', 'specialFunctionType'), 'Value');
    t0Str = get(findobj(fig, 'Tag', 'timeShiftInput'), 'String');
    
    % Ryd tidligere output
    set(findobj(fig, 'Tag', 'specialFuncResult'), 'String', '');
    set(findobj(fig, 'Tag', 'specialFuncExplanation'), 'String', {});
    
    % Parse tidsforskydningsværdi
    try
        t0 = str2double(t0Str);
        if isnan(t0)
            logMessage('Fejl: Ugyldig tidsforskydningsværdi', fig);
            return;
        end
    catch
        logMessage('Fejl: Ugyldig tidsforskydningsværdi', fig);
        return;
    end
    
    % Symbolske variable
    syms t s;
    
    try
        switch selectedIndex
            case 1 % Enhedstrin-funktion
                logMessage(['Beregner Laplacetransformation af enhedstrin u(t-' num2str(t0) ')...'], fig);
                [F, explanation] = ElektroMatBibTrinvis.enhedsTrinMedForklaring(t0, t, s);
                
                % Vis resultater
                set(findobj(fig, 'Tag', 'specialFuncResult'), 'String', char(F));
                displayExplanation(explanation, fig, 'specialFuncExplanation');
                
            case 2 % Delta-funktion
                logMessage(['Beregner Laplacetransformation af delta-funktion δ(t-' num2str(t0) ')...'], fig);
                [F, explanation] = ElektroMatBibTrinvis.deltaFunktionMedForklaring(t0, t, s);
                
                % Vis resultater
                set(findobj(fig, 'Tag', 'specialFuncResult'), 'String', char(F));
                displayExplanation(explanation, fig, 'specialFuncExplanation');
                
            case 3 % Tidsskift regel
                funcStr = get(findobj(fig, 'Tag', 'origFuncInput'), 'String');
                
                % Tjek om inputtet er tomt
                if isempty(funcStr)
                    logMessage('Fejl: Indtast venligst en funktion', fig);
                    return;
                end
                
                % Erstat e^(...) med exp(...)
                funcStr = regexprep(funcStr, 'e\^', 'exp');
                f_expr = sym(funcStr);
                
                logMessage(['Beregner Laplacetransformation vha. tidsskiftregel for f(t-' num2str(t0) ')u(t-' num2str(t0) ')...'], fig);
                [F, explanation] = ElektroMatBibTrinvis.forsinkelsesRegelMedForklaring(f_expr, t0, t, s);
                
                % Vis resultater
                set(findobj(fig, 'Tag', 'specialFuncResult'), 'String', char(F));
                displayExplanation(explanation, fig, 'specialFuncExplanation');
        end
        
        logMessage('Specialfunktions-transformation beregnet!', fig);
        
        % Føj til historik automatisk
        addToHistory([], [], 'SpecFunc', fig);
        
    catch e
        logMessage(['Fejl: ' e.message], fig);
        set(findobj(fig, 'Tag', 'specialFuncResult'), 'String', 'Fejl i beregning. Tjek inputs.');
    end
end

function setupFormulaLibrary(tab)
    % Opret et formelbibliotek-fane
    panel = uipanel('Parent', tab, 'Position', [0 0 1 1]);
    
    % Kategoriområde
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Vælg formelkategori:', ...
             'Position', [30, 520, 130, 30], ...
             'HorizontalAlignment', 'left', ...
             'FontWeight', 'bold');
    
    categories = {'Laplace transformationer', 'Inverse Laplace transformationer', ...
                  'Fourier transformationer', 'Fourier række', ...
                  'LTI systemer', 'Differentialligninger', 
                  'RLC kredsløb', 'Specialfunktioner'};
    
    uicontrol('Parent', panel, 'Style', 'popupmenu', ...
             'String', categories, ...
             'Position', [170, 525, 250, 25], ...
             'Tag', 'formulaCategory', ...
             'Callback', @updateFormulaDisplay);
    
    % Søgefelt
    uicontrol('Parent', panel, 'Style', 'text', ...
             'String', 'Søg:', ...
             'Position', [440, 520, 40, 30], ...
             'HorizontalAlignment', 'left');
    
    uicontrol('Parent', panel, 'Style', 'edit', ...
             'Position', [480, 525, 120, 25], ...
             'Tag', 'formulaSearch', ...
             'Callback', @searchFormulas);
    
    % Formeldisplay
    uicontrol('Parent', panel, 'Style', 'listbox', ...
             'Position', [30, 30, 560, 485], ...
             'Tag', 'formulaDisplay', ...
             'FontName', 'Consolas', ...
             'FontSize', 9);
    
    % Indlæs formler ved opstart
    loadFormulas(panel);
end

function loadFormulas(panel)
    % Indlæs og vis formelbibliotek
    fig = ancestor(panel, 'figure');
    
    % Definér formelbibliotek
    formulas = struct();
    
    % Laplace transformationer
    formulas.laplace = {
        'f(t) = 1                    ↔  F(s) = 1/s',
        'f(t) = t^n                  ↔  F(s) = n!/s^(n+1)',
        'f(t) = e^(at)               ↔  F(s) = 1/(s-a)',
        'f(t) = sin(at)              ↔  F(s) = a/(s^2+a^2)',
        'f(t) = cos(at)              ↔  F(s) = s/(s^2+a^2)',
        'f(t) = t·sin(at)            ↔  F(s) = 2as/(s^2+a^2)^2',
        'f(t) = t·cos(at)            ↔  F(s) = s^2-a^2/(s^2+a^2)^2',
        'f(t) = e^(at)·sin(bt)       ↔  F(s) = b/((s-a)^2+b^2)',
        'f(t) = e^(at)·cos(bt)       ↔  F(s) = (s-a)/((s-a)^2+b^2)',
        'f(t) = sinh(at)             ↔  F(s) = a/(s^2-a^2)',
        'f(t) = cosh(at)             ↔  F(s) = s/(s^2-a^2)',
        'f(t) = t·e^(at)             ↔  F(s) = 1/(s-a)^2',
        'f(t) = t^n·e^(at)           ↔  F(s) = n!/(s-a)^(n+1)',
        'f(t) = u(t)                 ↔  F(s) = 1/s',
        'f(t) = u(t-a)               ↔  F(s) = e^(-as)/s',
        'f(t) = δ(t)                 ↔  F(s) = 1',
        'f(t) = δ(t-a)               ↔  F(s) = e^(-as)',
        'f(t) = d^n/dt^n g(t)        ↔  F(s) = s^n·G(s) - s^(n-1)·g(0) - ... - g^(n-1)(0)'
    };
    
    % Inverse Laplace transformationer
    formulas.inv_laplace = {
        'F(s) = 1/s                   ↔  f(t) = 1',
        'F(s) = 1/s^(n+1)             ↔  f(t) = t^n/n!',
        'F(s) = 1/(s-a)               ↔  f(t) = e^(at)',
        'F(s) = a/(s^2+a^2)           ↔  f(t) = sin(at)',
        'F(s) = s/(s^2+a^2)           ↔  f(t) = cos(at)',
        'F(s) = 2as/(s^2+a^2)^2       ↔  f(t) = t·sin(at)',
        'F(s) = (s^2-a^2)/(s^2+a^2)^2 ↔  f(t) = t·cos(at)',
        'F(s) = b/((s-a)^2+b^2)       ↔  f(t) = e^(at)·sin(bt)',
        'F(s) = (s-a)/((s-a)^2+b^2)   ↔  f(t) = e^(at)·cos(bt)',
        'F(s) = 1/(s-a)^2             ↔  f(t) = t·e^(at)',
        'F(s) = 1/(s-a)^(n+1)         ↔  f(t) = t^n·e^(at)/n!',
        'F(s) = e^(-as)/s             ↔  f(t) = u(t-a)',
        'F(s) = e^(-as)               ↔  f(t) = δ(t-a)',
        'F(s) = s^n·G(s) - s^(n-1)·g(0) - ... - g^(n-1)(0) ↔ f(t) = d^n/dt^n g(t)'
    };
    
    % Fourier transformationer
    formulas.fourier = {
        'f(t) = 1                    ↔  F(ω) = 2π·δ(ω)',
        'f(t) = e^(-a|t|)            ↔  F(ω) = 2a/(a^2+ω^2)',
        'f(t) = e^(-at^2)            ↔  F(ω) = √(π/a)·e^(-ω^2/(4a))',
        'f(t) = cos(ω₀t)             ↔  F(ω) = π·[δ(ω-ω₀) + δ(ω+ω₀)]',
        'f(t) = sin(ω₀t)             ↔  F(ω) = π·i·[δ(ω+ω₀) - δ(ω-ω₀)]',
        'f(t) = rect(t/a)            ↔  F(ω) = a·sinc(aω/2)',
        'f(t) = δ(t-t₀)              ↔  F(ω) = e^(-iωt₀)',
        'f(t) = e^(-at)·u(t)         ↔  F(ω) = 1/(a+iω)',
        'f(t) = t^n·e^(-at)·u(t)     ↔  F(ω) = n!/(a+iω)^(n+1)',
        'f(t) = d^n/dt^n g(t)        ↔  F(ω) = (iω)^n·G(ω)',
        'f(t) = g(t-t₀)              ↔  F(ω) = e^(-iωt₀)·G(ω)',
        'f(t) = e^(iω₀t)·g(t)        ↔  F(ω) = G(ω-ω₀)',
        'f(t) = g(at)                ↔  F(ω) = (1/|a|)·G(ω/a)',
        'f(t) = g(t)·h(t)            ↔  F(ω) = (1/2π)·[G(ω) * H(ω)]',
        'f(t) = [g * h](t)           ↔  F(ω) = G(ω)·H(ω)'
    };
    
    % Fourier række
    formulas.fourier_series = {
        'Fourierrække (kompleks form):',
        '  f(t) = ∑ cₙ·e^(inω₀t) fra n = -∞ til ∞',
        '  cₙ = (1/T)·∫ f(t)·e^(-inω₀t) dt fra -T/2 til T/2',
        '',
        'Fourierrække (trigonometrisk form):',
        '  f(t) = a₀/2 + ∑ [aₙ·cos(nω₀t) + bₙ·sin(nω₀t)] fra n = 1 til ∞',
        '  a₀ = (2/T)·∫ f(t) dt fra -T/2 til T/2',
        '  aₙ = (2/T)·∫ f(t)·cos(nω₀t) dt fra -T/2 til T/2 for n ≥ 1',
        '  bₙ = (2/T)·∫ f(t)·sin(nω₀t) dt fra -T/2 til T/2 for n ≥ 1',
        '',
        'Relationer mellem komplekse og trigonometriske koefficienter:',
        '  c₀ = a₀/2',
        '  cₙ = (aₙ-ibₙ)/2 for n > 0',
        '  c₋ₙ = (aₙ+ibₙ)/2 for n > 0',
        '',
        'Parsevals teorem:',
        '  (1/T)·∫|f(t)|² dt fra -T/2 til T/2 = ∑|cₙ|² fra n = -∞ til ∞',
        '  = a₀²/2 + ∑(aₙ² + bₙ²)/2 fra n = 1 til ∞'
    };
    
    % LTI systemer
    formulas.lti = {
        'Overføringsfunktion H(s) = Y(s)/X(s)',
        '',
        'Impulsrespons: h(t) = L^(-1){H(s)}',
        '',
        'Steprespons: g(t) = L^(-1){H(s)/s}',
        '',
        'Konvolution: y(t) = (x * h)(t) = ∫ x(τ)·h(t-τ) dτ fra -∞ til ∞',
        '',
        'Anden ordens system:',
        '  H(s) = ω²ₙ/(s² + 2ζωₙs + ω²ₙ)',
        '  Naturlig frekvens: ωₙ = √(k/m) rad/s',
        '  Dæmpningsforhold: ζ = c/(2√(km))',
        '  Oversving: PO = e^(-πζ/√(1-ζ²)) · 100%',
        '  Stigetid (10-90%): tᵣ ≈ 1.8/ωₙ',
        '  Indsvingningstid (2%): tₛ ≈ 4/(ζωₙ)',
        '',
        'Stabilitetskriterier:',
        '  Alle poler skal ligge i venstre halvplan (negativ realdel)',
        '  Fasemargin > 0° (positiv)',
        '  Forstærkningsmargin > 0 dB',
        '',
        'Frekvensrespons:',
        '  H(jω) = |H(jω)|·e^(j·∠H(jω))',
        '  Amplituderespons: |H(jω)| = |Y(jω)| / |X(jω)|',
        '  Faserespons: ∠H(jω) = ∠Y(jω) - ∠X(jω)'
    };
    
    % Differentialligninger
    formulas.diff_eq = {
        'Generel form: a_n·y^(n) + a_(n-1)·y^(n-1) + ... + a_1·y'' + a_0·y = f(t)',
        '',
        'Homogen løsning:',
        '  Karakteristisk ligning: a_n·λ^n + a_(n-1)·λ^(n-1) + ... + a_1·λ + a_0 = 0',
        '  For forskellige reelle rødder λ_i:',
        '    y_h(t) = C_1·e^(λ_1·t) + C_2·e^(λ_2·t) + ... + C_n·e^(λ_n·t)',
        '  For dobbelte reelle rødder λ_i med multiplicitet k:',
        '    y_h(t) = (C_1 + C_2·t + ... + C_k·t^(k-1))·e^(λ_i·t)',
        '  For komplekse rødder λ = α±jβ:',
        '    y_h(t) = e^(αt)·[C_1·cos(βt) + C_2·sin(βt)]',
        '',
        'Partikulær løsning:',
        '  For f(t) = P(t)·e^(rt) (P(t) er et polynom):',
        '    Hvis r ikke er rod: y_p(t) = Q(t)·e^(rt)',
        '    Hvis r er rod med multiplicitet k: y_p(t) = t^k·Q(t)·e^(rt)',
        '  For f(t) = A·cos(ωt) eller B·sin(ωt):',
        '    Hvis jω ikke er rod: y_p(t) = C·cos(ωt) + D·sin(ωt)',
        '    Hvis jω er rod: y_p(t) = t·[C·cos(ωt) + D·sin(ωt)]',
        '',
        'Fuldstændig løsning:',
        '  y(t) = y_h(t) + y_p(t)'
    };
    
    % RLC kredsløb
    formulas.rlc = {
        'Seriel RLC-kredsløb:',
        '  Differentialligning: L·d²i/dt² + R·di/dt + (1/C)·i = v(t)',
        '  Overføringsfunktion (strøm): H(s) = 1/(Ls² + Rs + 1/C)',
        '  Impedans: Z(s) = Ls + R + 1/(Cs)',
        '',
        'Parallel RLC-kredsløb:',
        '  Differentialligning: C·d²v/dt² + (1/R)·dv/dt + (1/L)·v = i(t)',
        '  Overføringsfunktion (spænding): H(s) = 1/(Cs² + (1/R)s + 1/L)',
        '  Admittans: Y(s) = Cs + 1/R + 1/(Ls)',
        '',
        'Naturlig frekvens: ω₀ = 1/√(LC) rad/s',
        'Dæmpningsforhold:',
        '  Seriel: ζ = R/(2·√(L/C))',
        '  Parallel: ζ = (1/R)·√(L/C)/2',
        '',
        'Respons-klassifikation:',
        '  Overdæmpet: ζ > 1',
        '  Kritisk dæmpet: ζ = 1',
        '  Underdæmpet: 0 < ζ < 1',
        '  Udæmpet: ζ = 0',
        '',
        'Båndbredde: ω_BW = 2ζω₀',
        'Resonansforstærkning (Underdæmpet): Q = 1/(2ζ)'
    };
    
    % Specialfunktioner
    formulas.spec_func = {
        'Enhedstrin-funktion:',
        '  u(t) = { 0 for t < 0, 1 for t ≥ 0 }',
        '  L{u(t)} = 1/s',
        '  L{u(t-a)} = e^(-as)/s for a > 0',
        '',
        'Delta-funktion (Dirac impuls):',
        '  ∫ δ(t-a)·f(t) dt = f(a)',
        '  L{δ(t)} = 1',
        '  L{δ(t-a)} = e^(-as)',
        '',
        'Forsinkelsesreglen:',
        '  L{f(t-a)·u(t-a)} = e^(-as)·L{f(t)}',
        '',
        'Dæmpede harmoniske funktioner:',
        '  L{e^(-at)·sin(bt)} = b/((s+a)² + b²)',
        '  L{e^(-at)·cos(bt)} = (s+a)/((s+a)² + b²)',
        '',
        'Foldningssætning:',
        '  L{(f * g)(t)} = L{f(t)} · L{g(t)} = F(s) · G(s)',
        '',
        'Differentiering og integration:',
        '  L{df/dt} = s·L{f(t)} - f(0)',
        '  L{∫f(τ)dτ} = (1/s)·L{f(t)}'
    };
    
    % Gem formlerne i figure data
    setappdata(fig, 'formulas', formulas);
    
    % Vis den første kategori
    updateFormulaDisplay(findobj(fig, 'Tag', 'formulaCategory'));
end

function updateFormulaDisplay(src, event)
    % Opdater formelvisning baseret på valgt kategori
    if isempty(src)
        return;
    end
    
    fig = ancestor(src, 'figure');
    idx = get(src, 'Value');
    
    if isempty(idx) || idx < 1
        idx = 1;
    end
    
    % Hent formelbibliotek fra figure data
    formulas = getappdata(fig, 'formulas');
    
    % Vælg kategori
    categories = fieldnames(formulas);
    if length(categories) >= idx
        category = categories{idx};
        formulaList = formulas.(category);
    else
        formulaList = {'Ingen formler tilgængelige'};
    end
    
    % Vis formlerne
    formulaDisplay = findobj(fig, 'Tag', 'formulaDisplay');
    set(formulaDisplay, 'String', formulaList);
end

function searchFormulas(src, event)
    % Søg i formelbiblioteket
    fig = ancestor(src, 'figure');
    searchTerm = lower(get(src, 'String'));
    
    if isempty(searchTerm)
        % Hvis søgefeltet er tomt, vis standard-kategorien
        updateFormulaDisplay(findobj(fig, 'Tag', 'formulaCategory'));
        return;
    end
    
    % Hent formelbibliotek fra figure data
    formulas = getappdata(fig, 'formulas');
    categories = fieldnames(formulas);
    
    % Søg i alle kategorier
    searchResults = {};
    for i = 1:length(categories)
        category = categories{i};
        categoryFormulas = formulas.(category);
        
        % Find formler der indeholder søgetermen
        for j = 1:length(categoryFormulas)
            if contains(lower(categoryFormulas{j}), searchTerm)
                searchResults{end+1} = ['[' upper(category(1)) category(2:end) '] ' categoryFormulas{j}];
            end
        end
    end
    
    % Vis søgeresultater
    if isempty(searchResults)
        searchResults = {'Ingen resultater fundet'};
    end
    
    formulaDisplay = findobj(fig, 'Tag', 'formulaDisplay');
    set(formulaDisplay, 'String', searchResults);
end

function openFormulaLibrary(src, event)
    % Skift til formelbibliotek-fanen
    fig = gcbf;
    tabGroup = findobj(fig, 'Type', 'uitabgroup');
    formulaTab = findobj(tabGroup, 'Title', 'Formler');
    set(tabGroup, 'SelectedTab', formulaTab);
end

% -------------------------------------------------------------------------
% Hjælpefunktioner til historik og generelle operationer
% -------------------------------------------------------------------------

function addToHistory(src, event, category, figHandle)
    % Tilføj aktuel beregning til historik
    if nargin < 4
        fig = ancestor(src, 'figure');
    else
        fig = figHandle;
    end
    
    % Find resultatfelt baseret på kategori
    switch category
        case 'Laplace'
            resultCtrl = findobj(fig, 'Tag', 'resultOutput');
        case 'Fourier'
            resultCtrl = findobj(fig, 'Tag', 'fourierResultOutput');
        case 'LTI'
            % For LTI er resultatet en lidt mere kompleks struktur
            resultStr = 'LTI-systemanalyse gennemført';
            history = getappdata(fig, 'history');
            history{end+1} = ['[LTI] ' resultStr];
            setappdata(fig, 'history', history);
            updateHistoryList(fig);
            logMessage('Føjet til historik: LTI-systemanalyse', fig);
            return;
        case 'DiffEq'
            % For differentialligninger er resultatet en lidt mere kompleks struktur
            coefStr = get(findobj(fig, 'Tag', 'diffEqCoefInput'), 'String');
            resultStr = ['Differentialligning: ' coefStr];
            history = getappdata(fig, 'history');
            history{end+1} = ['[DIFF] ' resultStr];
            setappdata(fig, 'history', history);
            updateHistoryList(fig);
            logMessage('Føjet til historik: ' resultStr, fig);
            return;
        case 'RLC'
            % For RLC er resultatet kredsløbsparametre
            R = get(findobj(fig, 'Tag', 'resistanceInput'), 'String');
            L = get(findobj(fig, 'Tag', 'inductanceInput'), 'String');
            C = get(findobj(fig, 'Tag', 'capacitanceInput'), 'String');
            resultStr = ['RLC: R=' R 'Ω, L=' L 'H, C=' C 'F'];
            history = getappdata(fig, 'history');
            history{end+1} = ['[RLC] ' resultStr];
            setappdata(fig, 'history', history);
            updateHistoryList(fig);
            logMessage('Føjet til historik: ' resultStr, fig);
            return;
        case 'SpecFunc'
            resultCtrl = findobj(fig, 'Tag', 'specialFuncResult');
    end
    
    % Hent resultattekst
    resultStr = get(resultCtrl, 'String');
    
    % Tjek om der er et resultat at gemme
    if isempty(resultStr)
        logMessage('Ingen resultat at føje til historik', fig);
        return;
    end
    
    % Hent historik fra figure data
    history = getappdata(fig, 'history');
    
    % Tilføj nyt element til historik
    history{end+1} = ['[' upper(category(1)) category(2:end) '] ' resultStr];
    
    % Gem opdateret historik
    setappdata(fig, 'history', history);
    
    % Opdater historikliste
    updateHistoryList(fig);
    
    logMessage(['Føjet til historik: ' resultStr], fig);
end

function updateHistoryList(fig)
    % Opdater historiklistens indhold
    history = getappdata(fig, 'history');
    historyList = findobj(fig, 'Tag', 'historyList');
    set(historyList, 'String', history);
    
    % Rul ned til nyeste element
    if ~isempty(history)
        set(historyList, 'Value', length(history));
    end
end

function loadFromHistory(src, event)
    % Indlæs valgt beregning fra historik
    fig = ancestor(src, 'figure');
    historyList = findobj(fig, 'Tag', 'historyList');
    
    history = getappdata(fig, 'history');
    if isempty(history)
        return;
    end
    
    selectedIdx = get(historyList, 'Value');
    if selectedIdx > length(history)
        return;
    end
    
    selectedItem = history{selectedIdx};
    
    % Findkategori og beregning
    category = regexp(selectedItem, '^\[(.*?)\]', 'tokens');
    if isempty(category)
        return;
    end
    
    category = lower(category{1}{1});
    content = strtrim(selectedItem(length(category)+3:end));
    
    % Håndter forskellige kategorier
    if strcmpi(category, 'laplace')
        % Skift til Laplace-fane
        tabGroup = findobj(fig, 'Type', 'uitabgroup');
        lapTab = findobj(tabGroup, 'Title', 'Laplace');
        set(tabGroup, 'SelectedTab', lapTab);
        
        % Sæt resultat (ikke inputtet, da vi ikke kender det)
        set(findobj(fig, 'Tag', 'resultOutput'), 'String', content);
        logMessage('Indlæst Laplace-beregning fra historik', fig);
    elseif strcmpi(category, 'fourier')
        % Skift til Fourier-fane
        tabGroup = findobj(fig, 'Type', 'uitabgroup');
        fourierTab = findobj(tabGroup, 'Title', 'Fourier');
        set(tabGroup, 'SelectedTab', fourierTab);
        
        % Sæt resultat (ikke inputtet, da vi ikke kender det)
        set(findobj(fig, 'Tag', 'fourierResultOutput'), 'String', content);
        logMessage('Indlæst Fourier-beregning fra historik', fig);
    elseif strcmpi(category, 'lti')
        % Skift til LTI-fane
        tabGroup = findobj(fig, 'Type', 'uitabgroup');
        ltiTab = findobj(tabGroup, 'Title', 'LTI Systemer');
        set(tabGroup, 'SelectedTab', ltiTab);
        logMessage('Indlæst LTI-systemanalyse fra historik', fig);
    elseif strcmpi(category, 'diff')
        % Skift til Diff. ligninger-fane
        tabGroup = findobj(fig, 'Type', 'uitabgroup');
        diffTab = findobj(tabGroup, 'Title', 'Diff. Ligninger');
        set(tabGroup, 'SelectedTab', diffTab);
        
        % Udtræk koefficienterne
        eqMatch = regexp(content, 'Differentialligning: (.*)', 'tokens');
        if ~isempty(eqMatch)
            set(findobj(fig, 'Tag', 'diffEqCoefInput'), 'String', eqMatch{1}{1});
        end
        logMessage('Indlæst differentialligning fra historik', fig);
    elseif strcmpi(category, 'rlc')
        % Skift til RLC-fane
        tabGroup = findobj(fig, 'Type', 'uitabgroup');
        rlcTab = findobj(tabGroup, 'Title', 'RLC Kredsløb');
        set(tabGroup, 'SelectedTab', rlcTab);
        
        % Udtræk RLC-parametre
        rlcMatch = regexp(content, 'RLC: R=([^Ω]+)Ω, L=([^H]+)H, C=([^F]+)F', 'tokens');
        if ~isempty(rlcMatch)
            params = rlcMatch{1};
            set(findobj(fig, 'Tag', 'resistanceInput'), 'String', params{1});
            set(findobj(fig, 'Tag', 'inductanceInput'), 'String', params{2});
            set(findobj(fig, 'Tag', 'capacitanceInput'), 'String', params{3});
        end
        logMessage('Indlæst RLC-kredsløb fra historik', fig);
    elseif strcmpi(category, 'specfunc')
        % Skift til specialfunktioner-fane
        tabGroup = findobj(fig, 'Type', 'uitabgroup');
        specFuncTab = findobj(tabGroup, 'Title', 'Spec. Funktioner');
        set(tabGroup, 'SelectedTab', specFuncTab);
        
        % Sæt resultat (ikke inputtet, da vi ikke kender det)
        set(findobj(fig, 'Tag', 'specialFuncResult'), 'String', content);
        logMessage('Indlæst specialfunktion fra historik', fig);
    end
end

function clearHistory(src, event)
    % Ryd historik
    fig = gcbf;
    setappdata(fig, 'history', {});
    updateHistoryList(fig);
    logMessage('Historik ryddet', fig);
end

function handleKeyPress(src, event)
    % Håndter tastaturgenveje
    fig = gcbf;
    tabGroup = findobj(fig, 'Type', 'uitabgroup');
    
    switch event.Key
        case '1'  % Tryk 1 for Laplace
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'Laplace'));
        case '2'  % Tryk 2 for Fourier
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'Fourier'));
        case '3'  % Tryk 3 for LTI Systemer
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'LTI Systemer'));
        case '4'  % Tryk 4 for Diff. Ligninger
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'Diff. Ligninger'));
        case '5'  % Tryk 5 for RLC Kredsløb
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'RLC Kredsløb'));
        case '6'  % Tryk 6 for Specialfunktioner
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'Spec. Funktioner'));
        case '7'  % Tryk 7 for Formler
            set(tabGroup, 'SelectedTab', findobj(tabGroup, 'Title', 'Formler'));
        case 'c'  % Tryk c for at kopiere resultatet
            copyResult(fig);
        case 'r'  % Tryk r for at køre beregning
            runCurrentCalculation(fig);
        case 'h'  % Tryk h for at vise tastaturgenveje
            showKeyboardShortcuts([], []);
    end
end

function copyResult(fig)
    % Kopier aktuel resultat til clipboard
    tabGroup = findobj(fig, 'Type', 'uitabgroup');
    selectedTab = get(tabGroup, 'SelectedTab');
    tabTitle = get(selectedTab, 'Title');
    
    % Find det relevante resultatfelt baseret på valgt fane
    switch tabTitle
        case 'Laplace'
            resultCtrl = findobj(fig, 'Tag', 'resultOutput');
        case 'Fourier'
            resultCtrl = findobj(fig, 'Tag', 'fourierResultOutput');
        case 'LTI Systemer'
            % For LTI er der ikke et enkelt resultatfelt, tag første linje af info
            ltiInfo = get(findobj(fig, 'Tag', 'ltiOutputInfo'), 'String');
            if ~isempty(ltiInfo)
                clipboard('copy', ltiInfo{1});
                logMessage('Kopieret LTI-system info til clipboard', fig);
            end
            return;
        case 'Diff. Ligninger'
            % For differentialligninger, kopier koefficienterne
            resultCtrl = findobj(fig, 'Tag', 'diffEqCoefInput');
        case 'RLC Kredsløb'
            % For RLC, kopier kredsløbsparametre
            R = get(findobj(fig, 'Tag', 'resistanceInput'), 'String');
            L = get(findobj(fig, 'Tag', 'inductanceInput'), 'String');
            C = get(findobj(fig, 'Tag', 'capacitanceInput'), 'String');
            clipboard('copy', ['R=' R ' Ω, L=' L ' H, C=' C ' F']);
            logMessage('Kopieret RLC-kredsløbsparametre til clipboard', fig);
            return;
        case 'Spec. Funktioner'
            resultCtrl = findobj(fig, 'Tag', 'specialFuncResult');
        case 'Formler'
            % For formler, kopier den valgte formel
            formulaCtrl = findobj(fig, 'Tag', 'formulaDisplay');
            formulaList = get(formulaCtrl, 'String');
            selectedIdx = get(formulaCtrl, 'Value');
            if ~isempty(formulaList) && selectedIdx <= length(formulaList)
                clipboard('copy', formulaList{selectedIdx});
                logMessage('Kopieret formel til clipboard', fig);
            end
            return;
        otherwise
            return;
    end
    
    % Kopier indholdet
    resultText = get(resultCtrl, 'String');
    if ~isempty(resultText)
        clipboard('copy', resultText);
        logMessage(['Kopieret til clipboard: ' resultText], fig);
    end
end

function runCurrentCalculation(fig)
    % Kør aktuelt valgt beregning
    tabGroup = findobj(fig, 'Type', 'uitabgroup');
    selectedTab = get(tabGroup, 'SelectedTab');
    tabTitle = get(selectedTab, 'Title');
    
    % Find og klik på den relevante beregningsknap
    switch tabTitle
        case 'Laplace'
            computeBtn = findobj(fig, 'Tag', 'laplaceComputeBtn');
        case 'Fourier'
            computeBtn = findobj(fig, 'Tag', 'fourierComputeBtn');
        case 'LTI Systemer'
            computeBtn = findobj(fig, 'Tag', 'ltiComputeBtn');
        case 'Diff. Ligninger'
            computeBtn = findobj(fig, 'Tag', 'diffEqAnalyzeBtn');
        case 'RLC Kredsløb'
            computeBtn = findobj(fig, 'Tag', 'rlcAnalyzeBtn');
        case 'Spec. Funktioner'
            computeBtn = findobj(fig, 'Tag', 'specialFuncComputeBtn');
        otherwise
            return;
    end
    
    % Simuler klik på beregningsknappen
    if ~isempty(computeBtn)
        callback = get(computeBtn, 'Callback');
        if ~isempty(callback)
            if iscell(callback)
                feval(callback{1}, computeBtn, [], callback{2:end});
            else
                feval(callback, computeBtn, []);
            end
        end
    end
end

function saveResult(src, event)
    % Gem aktuelt resultat til fil
    fig = gcbf;
    tabGroup = findobj(fig, 'Type', 'uitabgroup');
    selectedTab = get(tabGroup, 'SelectedTab');
    tabTitle = get(selectedTab, 'Title');
    
    % Få indhold baseret på valgt fane
    switch tabTitle
        case 'Laplace'
            resultCtrl = findobj(fig, 'Tag', 'resultOutput');
            resultText = get(resultCtrl, 'String');
            explanationCtrl = findobj(fig, 'Tag', 'explanationOutput');
            filename = 'laplace_resultat.txt';
        case 'Fourier'
            resultCtrl = findobj(fig, 'Tag', 'fourierResultOutput');
            resultText = get(resultCtrl, 'String');
            explanationCtrl = findobj(fig, 'Tag', 'fourierExplanationOutput');
            filename = 'fourier_resultat.txt';
        case 'LTI Systemer'
            infoCtrl = findobj(fig, 'Tag', 'ltiOutputInfo');
            resultText = get(infoCtrl, 'String');
            explanationCtrl = [];
            filename = 'lti_system_analyse.txt';
        case 'Diff. Ligninger'
            infoCtrl = findobj(fig, 'Tag', 'diffEqOutput');
            resultText = get(infoCtrl, 'String');
            explanationCtrl = [];
            filename = 'differentialligning_analyse.txt';
        case 'RLC Kredsløb'
            infoCtrl = findobj(fig, 'Tag', 'rlcOutput');
            resultText = get(infoCtrl, 'String');
            explanationCtrl = [];
            filename = 'rlc_kredsloeb_analyse.txt';
        case 'Spec. Funktioner'
            resultCtrl = findobj(fig, 'Tag', 'specialFuncResult');
            resultText = get(resultCtrl, 'String');
            explanationCtrl = findobj(fig, 'Tag', 'specialFuncExplanation');
            filename = 'specialfunktion_resultat.txt';
        otherwise
            logMessage('Ingen resultater at gemme for denne fane', fig);
            return;
    end
    
    % Bed brugeren om filnavn
    [file, path] = uiputfile('*.txt', 'Gem resultat', filename);
    if isequal(file, 0) || isequal(path, 0)
        return;  % Brugeren annullerede
    end
    
    % Åbn filen til skrivning
    fullpath = fullfile(path, file);
    fid = fopen(fullpath, 'w');
    
    % Skriv overskrift
    fprintf(fid, '===== %s BEREGNINGSRESULTAT =====\n\n', upper(tabTitle));
    fprintf(fid, 'Dato og tid: %s\n\n', datestr(now));
    
    % Skriv resultat
    fprintf(fid, 'RESULTAT:\n');
    if ischar(resultText)
        fprintf(fid, '%s\n\n', resultText);
    else
        for i = 1:length(resultText)
            fprintf(fid, '%s\n', resultText{i});
        end
        fprintf(fid, '\n');
    end
    
    % Skriv forklaring hvis tilgængelig
    if ~isempty(explanationCtrl)
        explanationText = get(explanationCtrl, 'String');
        if ~isempty(explanationText)
            fprintf(fid, 'TRINVIS FORKLARING:\n');
            for i = 1:length(explanationText)
                fprintf(fid, '%s\n', explanationText{i});
            end
        end
    end
    
    % Luk filen
    fclose(fid);
    
    logMessage(['Resultat gemt til fil: ' fullpath], fig);
end

function exportToLatex(src, event)
    % Eksporter aktuelt resultat til LaTeX-format
    fig = gcbf;
    tabGroup = findobj(fig, 'Type', 'uitabgroup');
    selectedTab = get(tabGroup, 'SelectedTab');
    tabTitle = get(selectedTab, 'Title');
    
    % Få indhold baseret på valgt fane
    switch tabTitle
        case 'Laplace'
            resultCtrl = findobj(fig, 'Tag', 'resultOutput');
            resultText = get(resultCtrl, 'String');
            filename = 'laplace_resultat.tex';
        case 'Fourier'
            resultCtrl = findobj(fig, 'Tag', 'fourierResultOutput');
            resultText = get(resultCtrl, 'String');
            filename = 'fourier_resultat.tex';
        case 'LTI Systemer'
            infoCtrl = findobj(fig, 'Tag', 'ltiOutputInfo');
            resultText = get(infoCtrl, 'String');
            if ~isempty(resultText)
                resultText = resultText{1};  % Tag kun overføringsfunktionen
            else
                resultText = '';
            end
            filename = 'lti_system.tex';
        case 'Diff. Ligninger'
            % For differentialligninger, brug kun koefficienterne
            coefCtrl = findobj(fig, 'Tag', 'diffEqCoefInput');
            coefText = get(coefCtrl, 'String');
            
            % Opbyg differentialligning som tekst
            resultText = '';
            coefs = str2num(strrep(coefText, ',', ' '));  %#ok<ST2NM>
            if ~isempty(coefs)
                for i = 1:length(coefs)
                    idx = length(coefs) - i + 1;
                    if i == 1
                        if coefs(idx) == 1
                            term = 'y';
                        else
                            term = [num2str(coefs(idx)) ' y'];
                        end
                    else
                        order = i - 1;
                        if coefs(idx) == 0
                            term = '';
                        elseif coefs(idx) == 1
                            term = [' + y^{' num2str(order) '}'];
                        elseif coefs(idx) < 0
                            term = [' - ' num2str(abs(coefs(idx))) ' y^{' num2str(order) '}'];
                        else
                            term = [' + ' num2str(coefs(idx)) ' y^{' num2str(order) '}'];
                        end
                    end
                    resultText = [resultText term];
                end
                resultText = [resultText ' = 0'];
            end
            filename = 'differentialligning.tex';
        case 'RLC Kredsløb'
            % For RLC, brug kredsløbsligningen
            R = get(findobj(fig, 'Tag', 'resistanceInput'), 'String');
            L = get(findobj(fig, 'Tag', 'inductanceInput'), 'String');
            C = get(findobj(fig, 'Tag', 'capacitanceInput'), 'String');
            
            % Opbyg RLC-ligning
            resultText = [L '\\frac{d^2i}{dt^2} + ' R '\\frac{di}{dt} + \\frac{1}{' C '}i = v(t)'];
            filename = 'rlc_kredsloeb.tex';
        case 'Spec. Funktioner'
            resultCtrl = findobj(fig, 'Tag', 'specialFuncResult');
            resultText = get(resultCtrl, 'String');
            filename = 'specialfunktion.tex';
        otherwise
            logMessage('Ingen resultater at eksportere til LaTeX for denne fane', fig);
            return;
    end
    
    % Konverter resultattekst til LaTeX-format
    if isempty(resultText)
        logMessage('Intet resultat at eksportere', fig);
        return;
    end
    
    % Konverter til LaTeX hvis muligt
    try
        % Ryd op i input først
        resultText = strrep(resultText, 'exp', 'e^');
        
        % Prøv at konvertere til symbolsk først
        try
            syms s t;
            symExpr = sym(resultText);
            latexText = latex(symExpr);
        catch
            % Simpel erstatning af almindelige matematiksymboler
            latexText = resultText;
            latexText = strrep(latexText, '^', '^{');
            latexText = regexprep(latexText, '\^{([^{}])', '^{$1}');
            latexText = strrep(latexText, '*', ' \\cdot ');
            latexText = strrep(latexText, 'pi', '\\pi');
            latexText = strrep(latexText, 'delta', '\\delta');
            latexText = strrep(latexText, 'omega', '\\omega');
            latexText = strrep(latexText, 'zeta', '\\zeta');
            latexText = strrep(latexText, 'sqrt', '\\sqrt');
            latexText = strrep(latexText, 'sin', '\\sin');
            latexText = strrep(latexText, 'cos', '\\cos');
            latexText = strrep(latexText, 'tan', '\\tan');
            latexText = strrep(latexText, 'log', '\\log');
        end
        
        % Bed brugeren om filnavn
        [file, path] = uiputfile('*.tex', 'Eksporter til LaTeX', filename);
        if isequal(file, 0) || isequal(path, 0)
            return;  % Brugeren annullerede
        end
        
        % Åbn filen til skrivning
        fullpath = fullfile(path, file);
        fid = fopen(fullpath, 'w');
        
        % Skriv LaTeX-dokument
        fprintf(fid, '\\documentclass{article}\n');
        fprintf(fid, '\\usepackage{amsmath}\n');
        fprintf(fid, '\\usepackage{amssymb}\n');
        fprintf(fid, '\\begin{document}\n\n');
        
        fprintf(fid, '\\section*{%s Resultat}\n\n', tabTitle);
        fprintf(fid, '\\begin{equation}\n');
        fprintf(fid, '%s\n', latexText);
        fprintf(fid, '\\end{equation}\n\n');
        
        fprintf(fid, '\\end{document}\n');
        
        % Luk filen
        fclose(fid);
        
        logMessage(['Resultat eksporteret til LaTeX-fil: ' fullpath], fig);
        
    catch e
        logMessage(['Fejl ved LaTeX-konvertering: ' e.message], fig);
    end
end

function showKeyboardShortcuts(src, event)
    % Vis hjælp om tastaturgenveje
    helpFig = figure('Name', 'Tastaturgenveje', ...
                    'NumberTitle', 'off', ...
                    'MenuBar', 'none', ...
                    'Position', [300, 300, 400, 300]);
                    
    uicontrol('Parent', helpFig, 'Style', 'text', ...
             'String', {'ElektroMath Tastaturgenveje:', '', ...
                       '1-7: Skift til fanerne:',
                       '  1: Laplace',
                       '  2: Fourier',
                       '  3: LTI Systemer',
                       '  4: Diff. Ligninger',
                       '  5: RLC Kredsløb',
                       '  6: Spec. Funktioner',
                       '  7: Formler',
                       '',
                       'R: Kør beregning på aktuel fane',
                       'C: Kopier aktuelt resultat til clipboard',
                       'H: Vis denne hjælp',
                       '',
                       'Andre nyttige genveje:',
                       '  Ctrl+S: Gem resultat til fil',
                       '  Ctrl+L: Eksporter til LaTeX',
                       '  Ctrl+H: Ryd historik',
                       '  Esc: Luk aktuel hjælpeboks'}, ...
             'Position', [20, 20, 360, 260], ...
             'HorizontalAlignment', 'left');
end

function showAbout(src, event)
    % Vis information om ElektroMathSolver
    aboutFig = figure('Name', 'Om ElektroMathSolver', ...
                     'NumberTitle', 'off', ...
                     'MenuBar', 'none', ...
                     'Position', [300, 300, 500, 350]);
                    
    uicontrol('Parent', aboutFig, 'Style', 'text', ...
             'String', {'ElektroMathSolver', ...
                       'Version 2.0', ...
                       '', ...
                       'En avanceret beregningsassistent til elektroteknisk matematik', ...
                       '', ...
                       'Funktioner:', ...
                       '• Laplace-transformationer (direkte og inverse)', ...
                       '• Fourier-analyse og -transformation', ...
                       '• LTI-systemanalyse (herunder Bode-plot og step-respons)', ...
                       '• Differentialligningsanalyse', ...
                       '• RLC-kredsløbsanalyse', ...
                       '• Specialfunktioner (enhedstrin, delta, tidsskift)', ...
                       '• Integreret formelbibliotek', ...
                       '• Beregningshistorik', ...
                       '', ...
                       'Udviklet som et eksamensværktøj til elektroteknisk matematik', ...
                       'Baseret på ElektroMatBibTrinvis bibliotek', ...
                       '', ...
                       '© 2025 - Alle rettigheder forbeholdes'}, ...
             'Position', [20, 20, 460, 310], ...
             'HorizontalAlignment', 'center', ...
             'FontSize', 10);
end

function copyAsLaTeX(src, event)
    % Kopier aktuelt resultat som LaTeX til clipboard
    fig = ancestor(src, 'figure');
    resultCtrl = findobj(fig, 'Tag', 'resultOutput');
    resultText = get(resultCtrl, 'String');
    
    if isempty(resultText)
        logMessage('Intet resultat at kopiere', fig);
        return;
    end
    
    % Konverter til LaTeX
    try
        % Ryd op i input først
        resultText = strrep(resultText, 'exp', 'e^');
        
        % Prøv at konvertere til symbolsk først
        try
            syms s t;
            symExpr = sym(resultText);
            latexText = latex(symExpr);
        catch
            % Simpel erstatning af almindelige matematiksymboler
            latexText = resultText;
            latexText = strrep(latexText, '^', '^{');
            latexText = regexprep(latexText, '\^{([^{}])', '^{$1}');
            latexText = strrep(latexText, '*', ' \\cdot ');
            latexText = strrep(latexText, 'pi', '\\pi');
            latexText = strrep(latexText, 'delta', '\\delta');
            latexText = strrep(latexText, 'omega', '\\omega');
            latexText = strrep(latexText, 'zeta', '\\zeta');
            latexText = strrep(latexText, 'sqrt', '\\sqrt');
            latexText = strrep(latexText, 'sin', '\\sin');
            latexText = strrep(latexText, 'cos', '\\cos');
            latexText = strrep(latexText, 'tan', '\\tan');
            latexText = strrep(latexText, 'log', '\\log');
        end
        
        % Kopier til clipboard
        clipboard('copy', latexText);
        logMessage('Resultat kopieret som LaTeX til clipboard', fig);
        
    catch e
        logMessage(['Fejl ved LaTeX-konvertering: ' e.message], fig);
    end
end

function logMessage(msg, fig)
    % Tilføj en meddelelse til loggen
    logCtrl = findobj(fig, 'Tag', 'logText');
    currentLog = get(logCtrl, 'String');
    
    % Formater tidsstempel
    timestamp = datestr(now, 'HH:MM:SS');
    
    % Tilføj ny besked med tidsstempel
    if isempty(currentLog)
        newLog = [timestamp ': ' msg];
    else
        newLog = [currentLog char(10) timestamp ': ' msg];
    end
    
    set(logCtrl, 'String', newLog);
end

function displayExplanation(explanation, fig, ctrlTag)
    % Vis forklaringstrin i forklaringslistbox
    if nargin < 3
        ctrlTag = 'explanationOutput';
    end
    
    explanationCtrl = findobj(fig, 'Tag', ctrlTag);
    
    % Formater forklaringstrin
    steps = {};
    for i = 1:length(explanation.trin)
        step = explanation.trin{i};
        steps{end+1} = ['Trin ' num2str(step.nummer) ': ' step.titel];
        steps{end+1} = ['  ' step.tekst];
        if ~isempty(step.formel)
            steps{end+1} = ['  ' step.formel];
        end
        steps{end+1} = ' '; % Tilføj blank linje mellem trin
    end
    
    % Tilføj slutresultat
    steps{end+1} = ['RESULTAT: ' explanation.resultat];
    
    % Sæt forklaringsteksten
    set(explanationCtrl, 'String', steps);
end

function result = iif(condition, trueVal, falseVal)
    % Inline if-funktion (ternary operator-ækvivalent)
    if condition
        result = trueVal;
    else
        result = falseVal;
    end
end