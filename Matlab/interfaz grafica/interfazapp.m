classdef interfazapp < matlab.apps.AppBase
    %% COMPONENTES DE LA APLICACIÓN %%
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        AddfilecontainingcsvfileDropDownLabel  matlab.ui.control.Label 
        AbrirarchivoButton             matlab.ui.control.Button % archivo .csv
        AddfilecontainingmatfileDropDownLabel_2  matlab.ui.control.Label
        AbrirarchivoButton_2           matlab.ui.control.Button % archivo .mat
        IDpacientEditFieldLabel        matlab.ui.control.Label
        IDpacientEditField             matlab.ui.control.EditField % ID paciente
        SelectrangeoffrequencyEditFieldLabel  matlab.ui.control.Label
        SelectrangeoffrequencyEditField  matlab.ui.control.EditField % Seleccionar frecuencia
        SelectsegmenttimeEditFieldLabel  matlab.ui.control.Label
        SelectsegmenttimeEditField     matlab.ui.control.EditField % Seleccionar tiempo
        ComputeButton                  matlab.ui.control.Button % Compute
        DeleteButton                   matlab.ui.control.Button % Delete
        UIAxes                         matlab.ui.control.UIAxes % Grafica Señal ERG
        UIAxes2                        matlab.ui.control.UIAxes % Grafica Espectro de Potencia
        UIAxes3                        matlab.ui.control.UIAxes % Grafica Escalograma
        SaveFigureastiffDropDownLabel  matlab.ui.control.Label % Guardar archivo de figura en FIG
        GuardararchivoButton           matlab.ui.control.Button % Guardar archivo como .csv o .mat         
        SavefileButton                 matlab.ui.control.Button % Botón de guardar archivo
        datosCargados                  struct
        datosProcesados                struct
        filename                       char % Nombre del archivo cargado
        idPaciente                     string % ID del paciente
        PasAlts                        double = 0.1 % Filtro pasa altas
        PasBjs                         double = 2 % Filtro pasa bajas
        WPasAlts                       double = 0.1 % Frecuencia mínima de wavelet
        WPasBjs                        double = 2 % Frecuencia máxima de wavelet
        canal                          double = 1 % Canal
        TI                             double = [0 1] % Intervalo de tiempo
        selectedVar                    string % Variable seleccionada
        escalograma1
        frecuencias
        promedioEscalograma1
        senfilt
        tiempo
        TiempoEscalograma
        filePath                       string % Ruta del archivo cargado para abrir un CSV
    end
    %% INICIALIZACIÓN DE COMPONENTES %%
    methods (Access = private)
        function startupFcn(app)
        end
        function createComponents(app)
            % Creación UIFigure
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 629 722];
            app.UIFigure.Name = 'MATLAB App';

            % Abrir y leer CSV
            app.AddfilecontainingcsvfileDropDownLabel = uilabel(app.UIFigure);
            app.AddfilecontainingcsvfileDropDownLabel.BackgroundColor = [0.502 0.502 0.502];
            app.AddfilecontainingcsvfileDropDownLabel.HorizontalAlignment = 'center';
            app.AddfilecontainingcsvfileDropDownLabel.FontWeight = 'bold';
            app.AddfilecontainingcsvfileDropDownLabel.FontColor = [1 1 1];
            app.AddfilecontainingcsvfileDropDownLabel.Position = [103 634 183 22];
            app.AddfilecontainingcsvfileDropDownLabel.Text = 'Add file containing .csv file';
            % Abrir archivo
            app.AbrirarchivoButton = uibutton(app.UIFigure, 'push');
            app.AbrirarchivoButton.Position = [317 634 202 22];
            app.AbrirarchivoButton.Text = 'Open file';
            app.AbrirarchivoButton.ButtonPushedFcn = @(~, ~) addCSV(app);

            % Abrir y leer MAT
            app.AddfilecontainingmatfileDropDownLabel_2 = uilabel(app.UIFigure);
            app.AddfilecontainingmatfileDropDownLabel_2.BackgroundColor = [0.502 0.502 0.502];
            app.AddfilecontainingmatfileDropDownLabel_2.HorizontalAlignment = 'center';
            app.AddfilecontainingmatfileDropDownLabel_2.FontWeight = 'bold';
            app.AddfilecontainingmatfileDropDownLabel_2.FontColor = [1 1 1];
            app.AddfilecontainingmatfileDropDownLabel_2.Position = [102 587 184 22];
            app.AddfilecontainingmatfileDropDownLabel_2.Text = 'Add file containing .mat file';
            % Abrir archivo
            app.AbrirarchivoButton_2 = uibutton(app.UIFigure, 'push');
            app.AbrirarchivoButton_2.Position = [318 586 202 22];
            app.AbrirarchivoButton_2.Text = 'Open file';
            app.AbrirarchivoButton_2.ButtonPushedFcn = @(~, ~) addMAT(app);

            % Creación de ID paciente
            app.IDpacientEditFieldLabel = uilabel(app.UIFigure);
            app.IDpacientEditFieldLabel.BackgroundColor = [0.502 0.502 0.502];
            app.IDpacientEditFieldLabel.HorizontalAlignment = 'center';
            app.IDpacientEditFieldLabel.FontWeight = 'bold';
            app.IDpacientEditFieldLabel.FontColor = [1 1 1];
            app.IDpacientEditFieldLabel.Position = [101 540 185 22];
            app.IDpacientEditFieldLabel.Text = 'ID pacient';
            % Recuadro para insertar ID paciente
            app.IDpacientEditField = uieditfield(app.UIFigure, 'text');
            app.IDpacientEditField.Position = [311 540 210 22];
            app.IDpacientEditField.Tooltip = 'Ingrese el ID del paciente';
            app.IDpacientEditField.Tooltip = 'Para el ID ingresar letras y numeros como: Paciente1';

            % Creación Select range of frequency
            app.SelectrangeoffrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.SelectrangeoffrequencyEditFieldLabel.BackgroundColor = [0.502 0.502 0.502];
            app.SelectrangeoffrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectrangeoffrequencyEditFieldLabel.FontWeight = 'bold';
            app.SelectrangeoffrequencyEditFieldLabel.FontColor = [1 1 1];
            app.SelectrangeoffrequencyEditFieldLabel.Position = [100 487 150 22];
            app.SelectrangeoffrequencyEditFieldLabel.Text = 'Select range of frequency';
            % Se genera un recuadro que inserta texto para frecuencia
            app.SelectrangeoffrequencyEditField = uieditfield(app.UIFigure, 'text');
            app.SelectrangeoffrequencyEditField.Position = [256 487 50 22];
            app.SelectrangeoffrequencyEditField.Tooltip = 'Ingrese el rango de frecuencia como min,max por ejemplo: 1,60';

            % Creación Select segment time
            app.SelectsegmenttimeEditFieldLabel = uilabel(app.UIFigure);
            app.SelectsegmenttimeEditFieldLabel.BackgroundColor = [0.502 0.502 0.502];
            app.SelectsegmenttimeEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectsegmenttimeEditFieldLabel.FontWeight = 'bold';
            app.SelectsegmenttimeEditFieldLabel.FontColor = [1 1 1];
            app.SelectsegmenttimeEditFieldLabel.Position = [341 487 122 22];
            app.SelectsegmenttimeEditFieldLabel.Text = 'Select segment time';
            % Se genera un recuadro que inserta texto para el tiempo
            app.SelectsegmenttimeEditField = uieditfield(app.UIFigure, 'text');
            app.SelectsegmenttimeEditField.Position = [469 487 50 22];
            app.SelectsegmenttimeEditField.Tooltip = 'Ingrese el rango de tiempo como min,max por ejemplo: 0,300';

            % Creación Compute
            app.ComputeButton = uibutton(app.UIFigure, 'push');
            app.ComputeButton.BackgroundColor = [0.502 0.502 0.502];
            app.ComputeButton.FontWeight = 'bold';
            app.ComputeButton.FontColor = [1 1 1];
            app.ComputeButton.Position = [186 431 100 22];
            app.ComputeButton.Text = 'Compute';
            %app.ComputeButton.Tooltip = 'Dar clic en compute antes de guardar como figura o archivo';
            app.ComputeButton.ButtonPushedFcn = @(~, ~) compute(app);

            % Creación Delete
            app.DeleteButton = uibutton(app.UIFigure, 'push');
            app.DeleteButton.BackgroundColor = [0.502 0.502 0.502];
            app.DeleteButton.FontWeight = 'bold';
            app.DeleteButton.FontColor = [1 1 1];
            app.DeleteButton.Position = [348 432 100 22];
            app.DeleteButton.Text = 'Delete';
            app.DeleteButton.ButtonPushedFcn = @(~, ~) clearData(app);

            % Gráfica Señal ERG
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Señal ERG')
            xlabel(app.UIAxes, 'Tiempo (seg)')
            ylabel(app.UIAxes, 'Amplitud')
            app.UIAxes.Position = [139 314 355 95];

            % Gráfica Espectro de Potencia
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Espectro de Potencia')
            xlabel(app.UIAxes2, 'Frecuencia (Hz)')
            ylabel(app.UIAxes2, 'Potencia')
            app.UIAxes2.Position = [149 209 345 100];

            % Gráfica Escalograma
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'Escalograma')
            xlabel(app.UIAxes3, 'Tiempo (seg)')
            ylabel(app.UIAxes3, 'Frecuencia (Hz)')
            app.UIAxes3.Position = [149 100 345 100];

            % Etiqueta y botón para guardar la figura como FIG
            app.SaveFigureastiffDropDownLabel = uilabel(app.UIFigure);
            app.SaveFigureastiffDropDownLabel.BackgroundColor = [0.502 0.502 0.502];
            app.SaveFigureastiffDropDownLabel.HorizontalAlignment = 'center';
            app.SaveFigureastiffDropDownLabel.FontWeight = 'bold';
            app.SaveFigureastiffDropDownLabel.FontColor = [1 1 1];
            app.SaveFigureastiffDropDownLabel.Position = [188 70 100 22];
            app.SaveFigureastiffDropDownLabel.Text = 'Save as FIG';
            app.SavefileButton = uibutton(app.UIFigure, 'push');
            app.SavefileButton.Position = [320 70 140 22];
            app.SavefileButton.Text = 'Save figure';
            app.SavefileButton.Tooltip = 'Para el nombre de la figura debe tomarse en cuenta el ID del paciente como:([A-Z][ _ ][0-9]), ejemplo:Paciente1_A_totalEscalograma';
            app.SavefileButton.ButtonPushedFcn = @(~, ~) saveFigure(app);

            % Guardar archivo
            app.GuardararchivoButton = uibutton(app.UIFigure, 'push');
            app.GuardararchivoButton.BackgroundColor = [0.502 0.502 0.502];
            app.GuardararchivoButton.Position = [283 25 108 22];
            app.GuardararchivoButton.FontWeight = 'bold';
            app.GuardararchivoButton.FontColor = [1 1 1];
            app.GuardararchivoButton.Text = 'Save file';
            app.GuardararchivoButton.Tooltip = 'Para el nombre del archivo debe tomarse en cuenta el ID del paciente como:([A-Z][ _ ][0-9]), ejemplo:Paciente1_A_totalDatos de variables';
            app.GuardararchivoButton.ButtonPushedFcn = @(~, ~) saveFile(app);
            app.UIFigure.Visible = 'on';
        end
    %% Función para leer y cargar archivos .csv
    function addCSV(app, ~)
        [file, path] = uigetfile('*.csv');
        if isequal(file, 0)
            disp('Operación cancelada');
        else
            app.filePath = fullfile(path, file); % Asegúrate de que filePath está definido en las propiedades
            app.filename = file;
            datos = readtable(app.filePath);
            disp(['Archivo seleccionado: ', app.filePath]);
            if width(datos) < 2
                uialert(app.UIFigure, 'El archivo CSV debe tener al menos dos columnas.', 'Datos inválidos');
                return;
            end
            % Renombrar columnas genéricamente
            datos.Properties.VariableNames{1} = 'Variable1';
            datos.Properties.VariableNames{2} = 'Variable2';
            datosStruct = table2struct(datos, 'ToScalar', true);
            % Guardar datos como archivo .mat
            matFileName = fullfile(path, [fileparts(file), '.mat']);
            save(matFileName, '-struct', 'datosStruct');
            app.datosCargados = load(matFileName);
            vars = fieldnames(app.datosCargados);
            [indx, tf] = listdlg('PromptString', {'Selecciona una variable:', ...
                            'Solo se puede seleccionar una variable a la vez.', ''}, ...
                            'SelectionMode', 'single', 'ListString', vars);
            if tf == 0
                disp('No se seleccionó ninguna variable');
                return;
            end
            app.selectedVar = vars{indx};
            variableData = app.datosCargados.(app.selectedVar);
            tabla = array2table(variableData);
            number = height(tabla(:,1));
            muestra.fsample = 2000;
            time = 1/muestra.fsample:1/muestra.fsample:number/muestra.fsample;
            muestra.sampleinfo = [1 length(time)];
            datos = table2array(tabla);
            muestra.trial{1} = datos';
            muestra.time{1} = time;
            muestra.label = {'1'};
            Q = muestra.trial{1,1}(:,:);
            Q(isnan(Q)) = 0;
            muestra.trial{1,1}(:,:) = Q;
            % Validar si los datos contienen NaN
            if any(isnan(muestra.trial{1,1}(:)))
                error('Los datos contienen valores NaN.');
            end
            % Filtrar la señal
            cfg = [];
            cfg.lpfilter = 'yes';
            cfg.lpfreq = [app.PasBjs];
            cfg.lpfiltord = 5;
            cfg.hpfilter = 'yes';
            cfg.hpfreq = [app.PasAlts];
            cfg.hpfiltord = 4;
            cfg.demean = 'yes';
            cfg.dftfilter = 'yes';
            cfg.dftreplace = 'zero';
            muestra = ft_preprocessing(cfg, muestra);
            muestra = ft_struct2single(muestra);
                cfg = [];
            cfg.resamplefs = 50;
            muestra = ft_resampledata(cfg, muestra);
            disp(muestra.trial);
            cfg = [];
            cfg.channel = app.canal;
            cfg.latency = app.TI;
            muestra = ft_selectdata(cfg, muestra);
            actualizarEscalograma(app, muestra);
        end
    end
        %% Función para leer y cargar archivos .mat 
    function addMAT(app, ~)
        [file, path] = uigetfile('*.mat', 'Seleccionar archivo .mat');
        if isequal(file, 0)
            disp('Operación cancelada');
            return;
        end
        fullFileName = fullfile(path, file);
        app.datosCargados = load(fullFileName);
        vars = fieldnames(app.datosCargados);
        % Muestra una lista de las variables contenidas en el archivo cargado, permitiendo al usuario seleccionar la que desea procesar.
        [indx, tf] = listdlg('PromptString', {'Selecciona una variable:', ...
                        'Solo se puede seleccionar una variable a la vez.', ''}, ...
                        'SelectionMode', 'single', 'ListString', vars);
        if tf == 0
            disp('No se seleccionó ninguna variable');
            return;
        end
        app.selectedVar = vars{indx}; % la variable seleccionada
        variableData = app.datosCargados.(app.selectedVar);
        tabla = array2table(variableData); % canal a usar
        % Configurar muestra
        number = height(tabla(:,1)); % cuenta el número de canales
        muestra.fsample = 2000; % poner Frec de muestreo en Hz
        time = 1/muestra.fsample:1/muestra.fsample:number/muestra.fsample;
        muestra.sampleinfo = [1 length(time)]; % cuenta el número de datos
        datos = table2array(tabla);
        muestra.trial{1} = datos';
        muestra.time{1} = time;
        muestra.label = {'1'}; % poner el nombre de los canales
        Q = muestra.trial{1,1}(:,:);
        Q(isnan(Q)) = 0;
        muestra.trial{1,1}(:,:) = Q;
        % Filtrar la señal
        cfg = [];
        cfg.lpfilter = 'yes';
        cfg.lpfreq = app.PasBjs; % filtro pasa bajas 
        cfg.lpfiltord = 5;
        cfg.hpfilter = 'yes';
        cfg.hpfreq = app.PasAlts; % filtro pasa altas 
        cfg.hpfiltord = 4;
        cfg.demean = 'yes';
        cfg.dftfilter = 'yes';
        cfg.dftreplace = 'zero';
        muestra = ft_preprocessing(cfg, muestra); % preprocesa la señal
        muestra = ft_struct2single(muestra);

        % Cambiar frecuencia de muestreo
        cfg = [];
        cfg.resamplefs = 50;
        muestra = ft_resampledata(cfg, muestra); % cambio a 50 Hz
        disp(muestra.trial);
        cfg = [];
        cfg.channel = app.canal;
        cfg.latency = app.TI;
        muestra = ft_selectdata(cfg, muestra);
        actualizarEscalograma(app, muestra);
    end
        %% TECLA DE COMPUTE %%
    function compute(app, ~)
        app.ComputeButton.Text = 'Processing...';
        drawnow; % Asegura que el cambio de texto se muestre inmediatamente
        tic;
        app.filename = app.IDpacientEditField.Value;  % Asignar el valor del campo de texto de nombre
        app.idPaciente = app.IDpacientEditField.Value;  % Asignar el valor del campo de texto de ID
        freqRangeStr = app.SelectrangeoffrequencyEditField.Value;
        timeRangeStr = app.SelectsegmenttimeEditField.Value;
        freqRange = str2num(freqRangeStr); % Convierte a números
        timeRange = str2num(timeRangeStr); % Convierte a números
        % Valida el rango de frecuencia y tiempo
        if isempty(freqRange) || length(freqRange) ~= 2
            uialert(app.UIFigure, 'Por favor, ingresa un rango de frecuencia válido en el formato [min, max]', 'Error de Datos');
            app.ComputeButton.Text = 'Compute'; 
            return;
        end
        if isempty(timeRange) || length(timeRange) ~= 2
            uialert(app.UIFigure, 'Por favor, ingresa un intervalo de tiempo válido en el formato [start, end]', 'Error de Datos');
            app.ComputeButton.Text = 'Compute'; 
            return;
        end
        % Actualizar propiedades de frecuencia y tiempo
        app.WPasAlts = freqRange(1);
        app.WPasBjs = freqRange(2);
        app.TI = timeRange;
        % Verificar que se haya cargado un archivo y seleccionado una variable
        if isempty(app.datosCargados) || isempty(app.selectedVar)
            uialert(app.UIFigure, 'Por favor, carga un archivo y selecciona una variable antes de computar los cambios.', 'Error de Datos');
            app.ComputeButton.Text = 'Compute'; % Restaurar el texto del botón
            return;
        end

        % Convertir datos de la variable seleccionada a tabla
        variableData = app.datosCargados.(app.selectedVar);
        tabla = array2table(variableData); % Canal a usar
        number = height(tabla(:,1)); % Cuenta el número de canales
        muestra.fsample = 2000; % Poner Frec de muestreo en Hz
        time = 1/muestra.fsample:1/muestra.fsample:number/muestra.fsample;
        muestra.sampleinfo = [1 length(time)]; % Cuenta el número de datos
        datos = table2array(tabla);
        muestra.trial{1} = datos';
        muestra.time{1} = time;
        muestra.label = {'1'}; % Poner el nombre de los canales
        Q = muestra.trial{1,1}(:,:);
        Q(isnan(Q)) = 0;
        muestra.trial{1,1}(:,:) = Q;
        % Mostrar valores de depuración
        disp(['Frecuencia pasa altas: ', num2str(app.WPasAlts)]);
        disp(['Frecuencia pasa bajas: ', num2str(app.WPasBjs)]);
        disp(['Intervalo de tiempo: ', num2str(app.TI)]);

        % Filtrar la señal
        cfg = [];
        cfg.lpfilter = 'yes';
        cfg.lpfreq = app.WPasBjs; % Filtro pasa bajas (usando rango de frecuencia ingresado)
        cfg.lpfiltord = 5;
        cfg.hpfilter = 'yes';
        cfg.hpfreq = app.WPasAlts; % Filtro pasa altas (usando rango de frecuencia ingresado)
        cfg.hpfiltord = 4;
        cfg.demean = 'yes';
        cfg.dftfilter = 'yes';
        cfg.dftreplace = 'zero';
        muestra = ft_preprocessing(cfg, muestra); % Preprocesa la señal
        muestra = ft_struct2single(muestra);
        cfg = [];
        cfg.resamplefs = 50;
        muestra = ft_resampledata(cfg, muestra);
        disp(muestra.trial);
        cfg = [];
        cfg.channel = app.canal;
        cfg.latency = app.TI; % Usar intervalo de tiempo ingresado
        muestra = ft_selectdata(cfg, muestra);
        warning('output time-bins are different from input time-bins, multiples of the same bin were requested but not given trial %, frequency % (%.00 Hz)'); % Generar advertencia
        % Medir tiempo de llamada a ft_freqanalysis
        freqAnalysisStartTime = tic;
        actualizarEscalograma(app, muestra);
        freqAnalysisElapsedTime = toc(freqAnalysisStartTime);
        disp(['the call to "ft_freqanalysis" took ', num2str(freqAnalysisElapsedTime), ' seconds']);
        elapsedTime = toc;
        % Mostrar tiempo transcurrido
        disp(['Elapsed time is ', num2str(elapsedTime), ' seconds.']);
        % Mostrar alerta indicando que el procesamiento ha terminado y el tiempo transcurrido
        uialert(app.UIFigure, sprintf('El procesamiento ha terminado. En un tiempo de %.2f segundos.', elapsedTime), 'Proceso Completo');
        app.ComputeButton.Text = 'Compute';
    end
        %% TECLA DE DELETE %% borra los datos que se ingresaron 
    function clearData(app, ~)
        clearTextFields(app);
        resetProperties(app);
        resetUIAxes(app.UIAxes);
        resetUIAxes(app.UIAxes2);
        resetUIAxes(app.UIAxes3);
        disp('Datos borrados');
        function clearTextFields(app)
            app.IDpacientEditField.Value = '';
            app.SelectrangeoffrequencyEditField.Value = '';
            app.SelectsegmenttimeEditField.Value = '';
        end
        % Función para restablecer las propiedades del objeto de la aplicación
        function resetProperties(app)
            app.datosCargados = struct();
            app.datosProcesados = struct();
            app.filename = '';
            app.idPaciente = '';
            app.escalograma1 = [];
            app.frecuencias = [];
            app.promedioEscalograma1 = [];
            app.senfilt = [];
            app.tiempo = [];
            app.TiempoEscalograma = [];
            app.filePath = '';
            app.selectedVar = '';
        end
        % Función para restablecer los ejes de la interfaz de usuario
        function resetUIAxes(ax)
            cla(ax); % Limpiar los ejes
            xlabel(ax, ''); % Eliminar etiquetas de eje X
            ylabel(ax, ''); % Eliminar etiquetas de eje Y
            title(ax, ''); % Eliminar título
            colorbar(ax, 'off'); % Desactivar barra de color
            set(ax, 'XLimMode', 'auto', 'YLimMode', 'auto', 'ZLimMode', 'auto'); % Restablecer límites de los ejes
        end
    end
        %% GUARDAR COMO FIGURA 
    function saveFigure(app)
        [file, path] = uiputfile('*.fig', 'Guardar figura como');
        if isequal(file, 0)
            disp('No se seleccionó ningún archivo');
            return;
        end
        fullFileName = fullfile(path, file); % Crear el nombre completo del archivo
        h = figure('Visible', 'off');
    
        % Gráfica la señal filtrada
        subplot(3, 1, 1);
        plot(app.tiempo, app.senfilt(1, :) + 2, 'k', 'LineWidth', 0.5);
        legend('ERG', 'FontSize', 17);
        xlabel('Tiempo (s)', 'FontSize', 14);
        ylabel('Amplitud normalizada', 'FontSize', 14);
        title('Señal ERG', 'FontSize', 20);
        box off;
        grid off;
        set(gca, 'Color', 'w');
        set(gca, 'TickDir', 'out');
        set(findall(gca, '-property', 'FontSize'), 'FontSize', 17);
    
        % Crear y graficar el espectro promedio del escalograma
        subplot(3, 1, 2);
        [escaloerrinf1, escaloerrsup1, promedioEscalograma1, ~] = calcPromError(app.escalograma1);
        plot(app.frecuencias, promedioEscalograma1, 'k', 'LineWidth', 2);
        xlabel('Frecuencia (Hz)', 'FontSize', 14);
        ylabel('Potencia', 'FontSize', 14);
        title('Espectro de potencia (Hz)', 'FontSize', 20);
        lo1 = escaloerrinf1;
        hi1 = escaloerrsup1;
        hp = patch([app.frecuencias'; app.frecuencias(end:-1:1)'; app.frecuencias(1)], [lo1; hi1(end:-1:1); lo1(1)], 'k');
        set(hp, 'FaceColor', [0, 0, 0], 'EdgeColor', 'none');
        alpha(hp, 0.1);
        set(gca, 'TickDir', 'out');
        set(findall(gca, '-property', 'FontSize'), 'FontSize', 17);
    
        % Graficar el escalograma
        subplot(3, 1, 3);
        surf(app.TiempoEscalograma, app.frecuencias, app.escalograma1, 'EdgeColor', 'none');
        c = colorbar;
        c.Label.String = 'Potencia';
        c.Label.FontSize = 20;
        xlabel('Tiempo (seg)', 'FontSize', 14);
        ylabel('Frecuencia (Hz)', 'FontSize', 14);
        title('Escalograma', 'FontSize', 20);
        set(gca, 'ZScale', 'log');
        axis xy;
        colormap(parula);
        view(0, 90);
        caxis([0 5]);
        set(gca, 'Color', 'w');
        ylim([app.WPasAlts app.WPasBjs]);
        set(gca, 'TickDir', 'out');
        set(findall(gca, '-property', 'FontSize'), 'FontSize', 17);
        % Asegurarse de que la figura es visible antes de guardar
        set(h, 'Visible', 'on');
        % Guardar la figura
        savefig(h, fullFileName); % Guardar como archivo .fig
        disp(['Figura guardada en: ', fullFileName]);
        close(h);
    end
        %% GUARDAR ARCHIVO COMO .MAT  
    function saveFile(app, ~)
        [file, path] = uiputfile('*.mat', 'Guardar datos como');
        if isequal(file, 0)
            disp('No se seleccionó ningún archivo');
            return;
        end
        app.filename = file; % Se actualiza el nombre del archivo basado en el nombre seleccionado por el usuario
        fullFileName = fullfile(path, file);
        promedioEscalograma1 = app.promedioEscalograma1;
        TiempoEscalograma = app.TiempoEscalograma;
        escalograma1 = app.escalograma1;
        frecuencias = app.frecuencias;
        senfilt = app.senfilt;
        tiempo = app.tiempo;
        Filename = app.filename; % Nombre del archivo proporcionado por el usuario
        IDPaciente = char(app.idPaciente); % ID del paciente ingresado por el usuario
        % Guardar las variables en el archivo .mat con los nombres y el orden deseados
        save(fullFileName, 'promedioEscalograma1', 'TiempoEscalograma', 'escalograma1', 'frecuencias', 'senfilt', 'tiempo', 'Filename', 'IDPaciente');
        disp(['Datos guardados en: ', fullFileName]);
    end
        %% Graficas
    function actualizarEscalograma(app, muestra)
        muestra.trial{1,1}(1,:) = rescale(muestra.trial{1,1}(1,:), -1, 1);
        senfilt = muestra.trial{1,1};
        % Seleccionar el rango de tiempo especificado
        tiempoTotal = muestra.time{1};
        idxTiempo = tiempoTotal >= app.TI(1) & tiempoTotal <= app.TI(2);
        tiempoRecortado = tiempoTotal(idxTiempo);
        senfiltRecortado = senfilt(:, idxTiempo);
        % Configuración para el análisis de frecuencia utilizando wavelet
        cfg = [];
        cfg.method = 'wavelet';
        cfg.width = 7;
        cfg.output = 'pow';
        cfg.foi = app.WPasAlts:0.01:app.WPasBjs; % Rango de frecuencias para analizar
        cfg.toi = linspace(tiempoRecortado(1), tiempoRecortado(end), length(tiempoRecortado)); % Intervalos de tiempo para analizar
        % Manejo de errores para el análisis de frecuencia
        try
            freq = ft_freqanalysis(cfg, muestra);
        catch ME
            error('Error en el análisis de frecuencia: %s', ME.message);
        end    
        escalograma1 = squeeze(freq.powspctrm(1,:,:));  % Extrae los datos del escalograma
        frecuencias = freq.freq;
        TiempoEscalograma = freq.time;

        % Graficar el escalograma
        cla(app.UIAxes3); % Limpiar el eje antes de graficar
        surf(app.UIAxes3, TiempoEscalograma, frecuencias, escalograma1, 'EdgeColor', 'none'); % Crea la gráfica para el espectrograma
        c = colorbar(app.UIAxes3); % Asocia la barra de color con el eje UIAxes3
        c.Label.String = 'Potencia';
        xlabel(app.UIAxes3, 'Tiempo (seg)', 'FontSize', 13, 'FontName', 'Arial', 'Interpreter', 'none');
        ylabel(app.UIAxes3, 'Frecuencia (Hz)', 'FontSize', 12, 'FontName', 'Arial', 'Interpreter', 'none');
        title(app.UIAxes3, 'Escalograma', 'FontSize', 18, 'FontName', 'Arial', 'Interpreter', 'none');
        set(app.UIAxes3, 'ZScale', 'log');
        axis(app.UIAxes3, 'xy');
        colormap(app.UIAxes3, 'parula');
        view(app.UIAxes3, 0, 90);
        caxis(app.UIAxes3, [0 5]);
        set(app.UIAxes3, 'Color', 'w');
        ylim(app.UIAxes3, [app.WPasAlts app.WPasBjs]);
        set(app.UIAxes3, 'TickDir', 'out');

        % Crear y graficar el espectro promedio del escalograma
        cla(app.UIAxes2); % Limpiar el eje antes de graficar
        [escaloerrinf1, escaloerrsup1, promedioEscalograma1, ~] = calcPromError(escalograma1);
        plot(app.UIAxes2, frecuencias', promedioEscalograma1, 'color', 'k', 'LineWidth', 2);
        xlabel(app.UIAxes2, 'Frecuencia (Hz)', 'FontSize', 13, 'FontName', 'Arial', 'Interpreter', 'none');
        ylabel(app.UIAxes2, 'Potencia', 'FontSize', 12, 'FontName', 'Arial', 'Interpreter', 'none');
        title(app.UIAxes2, 'Espectro de potencia (Hz)', 'FontSize', 18, 'FontName', 'Arial', 'Interpreter', 'none');
        lo1 = escaloerrinf1;
        hi1 = escaloerrsup1;
        hp = patch(app.UIAxes2, [frecuencias'; frecuencias(end:-1:1)'; frecuencias(1)], [lo1; hi1(end:-1:1); lo1(1)], 'k');
        hold(app.UIAxes2, 'on');
        hl = line(app.UIAxes2, frecuencias', promedioEscalograma1);
        set(hp, 'FaceColor', [0,0,0], 'EdgeColor', 'none');
        set(hl, 'Color', 'k');
        alpha(hp, .1); % Específicamente aplicar transparencia al parche 'hp'
        hold(app.UIAxes2, 'on');
        set(app.UIAxes2, 'TickDir', 'out'); % Se ajusta la dirección de las marcas de los ejes

        % Graficar la señal filtrada
        cla(app.UIAxes); % Limpiar el eje antes de graficar
        plot(app.UIAxes, tiempoRecortado, senfiltRecortado(1,:)+2, 'k', 'LineWidth', .5); % 'Color',[0.4661 0.6740 0.1880] [0.8500, 0.3250, 0.0980
        legend(app.UIAxes, 'ERG');
        xlabel(app.UIAxes, 'Tiempo (s)', 'FontSize', 13, 'FontName', 'Arial', 'Interpreter', 'none');
        ylabel(app.UIAxes, 'Amplitud normalizada', 'FontSize', 12, 'FontName', 'Arial', 'Interpreter', 'none');
        title(app.UIAxes, 'Señal ERG', 'FontSize', 18, 'FontName', 'Arial', 'Interpreter', 'none');
        box(app.UIAxes, 'off');
        grid(app.UIAxes, 'off');
        set(app.UIAxes, 'Color', 'w');
        set(app.UIAxes, 'TickDir', 'out');
        set(findall(app.UIAxes, '-property', 'FontSize'), 'FontSize', 15);

        % Guardar las variables necesarias en el workspace
        app.escalograma1 = escalograma1;
        app.frecuencias = frecuencias;
        app.promedioEscalograma1 = promedioEscalograma1;
        app.senfilt = senfiltRecortado;
        app.tiempo = tiempoRecortado;
        app.TiempoEscalograma = TiempoEscalograma;
    end
    end
    %% CREACIÓN Y ELIMINACIÓN DE APLICACIÓN %%
    methods (Access = public)
        function app = interfazapp % Construcción de la aplicación
            createComponents(app)
            startupFcn(app) % Llamada al método de inicialización
            registerApp(app, app.UIFigure)
            % Si no hay argumentos de salida, limpiar la aplicación de la memoria
            if nargout == 0
                clear app
            end
        end
        function delete(app)
            delete(app.UIFigure)
        end
    end
end