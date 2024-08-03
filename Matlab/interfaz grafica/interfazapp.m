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
        TI                             double = [0 300] % Intervalo de tiempo
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
            % Valores de ejemplo que se muestran en la interfaz, se actualiza cuando el usuario ingrese los valores y de clic en compute
            app.PasAlts = 0.1;
            app.PasBjs = 2;
            app.WPasAlts = 0.1;
            app.WPasBjs = 2;
            app.canal = 1;
            app.TI = [0 300];
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
            app.SavefileButton.ButtonPushedFcn = @(~, ~) saveFigure(app);

            % Guardar archivo
            app.GuardararchivoButton = uibutton(app.UIFigure, 'push');
            app.GuardararchivoButton.BackgroundColor = [0.502 0.502 0.502];
            app.GuardararchivoButton.Position = [283 25 108 22];
            app.GuardararchivoButton.FontWeight = 'bold';
            app.GuardararchivoButton.FontColor = [1 1 1];
            app.GuardararchivoButton.Text = 'Save file';
            app.GuardararchivoButton.ButtonPushedFcn = @(~, ~) saveFile(app);
            app.UIFigure.Visible = 'on';
        end

        %% ABRIR ARCHIVOS .CSV Y .MAT %%
        % Función para leer y cargar archivos .csv 
        function addCSV(app, ~)
            [file, path] = uigetfile('*.csv');
            if isequal(file, 0)
                disp('Operación cancelada');
            else
                app.filePath = fullfile(path, file); % Asegúrate de que filePath está definido en las propiedades
                app.filename = file;
                datos = readtable(app.filePath);
                disp(['Archivo seleccionado: ', app.filePath]);

                % Ajustar los nombres de las columnas según sea necesario
                if any(strcmp('ms', datos.Properties.VariableNames)) && any(strcmp('uV', datos.Properties.VariableNames))
                    datos.Properties.VariableNames{'ms'} = 'Tiempo';
                    datos.Properties.VariableNames{'uV'} = 'Senal';
                    datosStruct = table2struct(datos, 'ToScalar', true);

                    % Guardar datos como archivo .mat
                    matFileName = fullfile(path, [fileparts(file), '.mat']);
                    save(matFileName, '-struct', 'datosStruct');

                    % Cargar y procesar el archivo .mat
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

                    % Cambiar frecuencia de muestreo
                    cfg = [];
                    cfg.resamplefs = 50;
                    muestra = ft_resampledata(cfg, muestra);
                    disp(muestra.trial);
                    cfg = [];
                    cfg.channel = app.canal;
                    cfg.latency = app.TI;
                    muestra = ft_selectdata(cfg, muestra);
                    actualizarEscalograma(app, muestra);
                else
                    uialert(app.UIFigure, 'Los datos no tienen las columnas esperadas.', 'Datos inválidos');
                end
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

            % Validar si los datos contienen NaN
            if any(isnan(muestra.trial{1,1}(:)))
                error('Los datos contienen valores NaN.');
            end

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

            % Seleccionar datos específicos
            cfg = [];
            cfg.channel = app.canal;
            cfg.latency = app.TI;
            muestra = ft_selectdata(cfg, muestra);

            % Actualizar escalograma
            actualizarEscalograma(app, muestra);
        end


%% TECLA DE COMPUTE %%     % Para actualizar datos ingresados
function compute(app, ~)
    % Actualizar las variables de nombre y ID del paciente
    app.filename = app.IDpacientEditField.Value;  % Asignar el valor del campo de texto de nombre
    app.idPaciente = app.IDpacientEditField.Value;  % Asignar el valor del campo de texto de ID
    freqRangeStr = app.SelectrangeoffrequencyEditField.Value;
    timeRangeStr = app.SelectsegmenttimeEditField.Value;
    freqRange = str2num(freqRangeStr); % Convertir a números
    timeRange = str2num(timeRangeStr); % Convertir a números

    % Validar rango de frecuencia y tiempo
    if isempty(freqRange) || length(freqRange) ~= 2
        uialert(app.UIFigure, 'Por favor, ingresa un rango de frecuencia válido en el formato [min, max]', 'Error de Datos');
        return;
    end
    if isempty(timeRange) || length(timeRange) ~= 2
        uialert(app.UIFigure, 'Por favor, ingresa un intervalo de tiempo válido en el formato [start, end]', 'Error de Datos');
        return;
    end

    % Actualizar propiedades de frecuencia y tiempo
    app.WPasAlts = freqRange(1);
    app.WPasBjs = freqRange(2);
    app.TI = timeRange;

    % Verificar que se haya cargado un archivo y seleccionado una variable
    if isempty(app.datosCargados) || isempty(app.selectedVar)
        uialert(app.UIFigure, 'Por favor, carga un archivo y selecciona una variable antes de computar los cambios.', 'Error de Datos');
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

    % Validar si los datos contienen NaN
    if any(isnan(muestra.trial{1,1}(:)))
        error('Los datos contienen valores NaN.');
    end

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

    % Cambiar frecuencia de muestreo
    cfg = [];
    cfg.resamplefs = 50;
    muestra = ft_resampledata(cfg, muestra);
    disp(muestra.trial);

    % Seleccionar datos específicos
    cfg = [];
    cfg.channel = app.canal;
    cfg.latency = app.TI; % Usar intervalo de tiempo ingresado
    muestra = ft_selectdata(cfg, muestra);

    % Actualizar escalograma
    actualizarEscalograma(app, muestra);
end


        %% TECLA DE DELETE %% borra los datos que se ingresaron 
        function clearData(app, ~)
            clearTextFields(app);
            resetProperties(app);
            resetUIAxes(app, app.UIAxes);
            resetUIAxes(app, app.UIAxes2);
            resetUIAxes(app, app.UIAxes3);
            disp('Datos borrados');
        end

        function clearTextFields(app)
            app.IDpacientEditField.Value = '';
            app.SelectrangeoffrequencyEditField.Value = '';
            app.SelectsegmenttimeEditField.Value = '';
        end

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

        function resetUIAxes(ax)
            cla(ax);
            xlabel(ax, '');
            ylabel(ax, '');
            title(ax, '');
            colorbar(ax, 'off');
            set(ax, 'XLimMode', 'auto', 'YLimMode', 'auto', 'ZLimMode', 'auto');
        end

        %% GUARDAR COMO FIGURA 
        function saveFigure(app)
            % Solicitar al usuario el nombre y la ruta para guardar el archivo
            [file, path] = uiputfile('*.fig', 'Guardar figura como');
            if isequal(file, 0)
                disp('No se seleccionó ningún archivo');
                return;
            end
            fullFileName = fullfile(path, file); % Crear el nombre completo del archivo
            h = figure('Visible', 'off'); % Crear una nueva figura temporal
            tempAxes1 = subplot(3, 1, 1, 'Parent', h);
            tempAxes2 = subplot(3, 1, 2, 'Parent', h);
            tempAxes3 = subplot(3, 1, 3, 'Parent', h);
            app.copyContent(app.UIAxes, tempAxes1);
            app.copyContent(app.UIAxes2, tempAxes2);
            app.copyContent(app.UIAxes3, tempAxes3);
            set(h, 'Visible', 'on');
            saveas(h, fullFileName); % Se guarda en fig dejando una visualización temporal de la imagen
            close(h);
            disp(['Figura guardada en: ', fullFileName]);
        end

        function copyContent(app, srcAxes, destAxes)
            % Copia los datos del eje fuente al eje de la figura restante
            children = allchild(srcAxes);
            for i = 1:numel(children)
                newChild = copyobj(children(i), destAxes);
                set(newChild, 'Parent', destAxes);
            end
            % Copiar propiedades importantes
            set(destAxes, 'XLim', get(srcAxes, 'XLim'));
            set(destAxes, 'YLim', get(srcAxes, 'YLim'));
            set(destAxes, 'ZLim', get(srcAxes, 'ZLim'));
            set(destAxes, 'CLim', get(srcAxes, 'CLim'));
            set(destAxes, 'View', get(srcAxes, 'View'));
            set(destAxes, 'Colormap', get(srcAxes, 'Colormap'));
            set(destAxes, 'Title', get(srcAxes, 'Title'));
            set(destAxes, 'XLabel', get(srcAxes, 'XLabel'));
            set(destAxes, 'YLabel', get(srcAxes, 'YLabel'));
            set(destAxes, 'ZLabel', get(srcAxes, 'ZLabel'));
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
            Escalograma = app.escalograma1;
            Filename = app.filename; % Nombre del archivo proporcionado por el usuario
            Frecuencias = app.frecuencias;
            IDPaciente = char(app.idPaciente); % ID del paciente ingresado por el usuario
            PromedioEscalograma = app.promedioEscalograma1;
            SenalFiltrada = app.senfilt;
            Tiempo = app.tiempo;
            TiempoResampleado = app.TiempoEscalograma;
            % Guardar las variables en el archivo .mat
            save(fullFileName, 'Escalograma', 'Filename', 'Frecuencias', 'IDPaciente', 'PromedioEscalograma', 'SenalFiltrada', 'Tiempo', 'TiempoResampleado');
            disp(['Datos guardados en: ', fullFileName]);
        end    

        %% Graficas
function actualizarEscalograma(app, muestra)
    % Normaliza los datos del trial para el rango [-1, 1]
    if any(isnan(muestra.trial{1,1}(1,:)))
        error('Los datos contienen valores NaN.');
    end
    muestra.trial{1,1}(1,:) = rescale(muestra.trial{1,1}(1,:), -1, 1);
    % Guarda los datos filtrados
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
    % Extrae los datos del escalograma
    escalograma1 = squeeze(freq.powspctrm(1,:,:));
    frecuencias = freq.freq;
    TiempoEscalograma = freq.time;

    % Graficar el escalograma
    cla(app.UIAxes3); % Limpiar el eje antes de graficar
    surf(app.UIAxes3, TiempoEscalograma, frecuencias, escalograma1, 'EdgeColor', 'none'); % Crea la gráfica para el espectrograma
    c = colorbar(app.UIAxes3); % Asocia la barra de color con el eje UIAxes3
    c.Label.String = 'Potencia';
    xlabel(app.UIAxes3, 'Tiempo (seg)', 'FontSize', 14);
    ylabel(app.UIAxes3, 'Frecuencia (Hz)', 'FontSize', 14);
    title(app.UIAxes3, 'Escalograma', 'FontSize', 16);
    set(app.UIAxes3, 'ZScale', 'log');
    axis(app.UIAxes3, 'xy');
    colormap(app.UIAxes3, 'parula');
    view(app.UIAxes3, 0, 90);
    caxis(app.UIAxes3, [0 5]);
    set(app.UIAxes3, 'Color', 'w');
    ylim(app.UIAxes3, [app.WPasAlts app.WPasBjs]);
    xlim(app.UIAxes3, [app.TI(1) app.TI(2)]);
    set(app.UIAxes3, 'TickDir', 'out');

    % Crear y graficar el espectro promedio del escalograma
    cla(app.UIAxes2); % Limpiar el eje antes de graficar
    [escaloerrinf1, escaloerrsup1, promedioEscalograma1, ~] = calcPromError(escalograma1);
    plot(app.UIAxes2, frecuencias', promedioEscalograma1, 'color', 'k', 'LineWidth', 2);
    xlabel(app.UIAxes2, 'Frecuencia (Hz)', 'FontSize', 14);
    ylabel(app.UIAxes2, 'Potencia', 'FontSize', 14);
    title(app.UIAxes2, 'Espectro de potencia (Hz)', 'FontSize', 16);
    lo1 = escaloerrinf1;
    hi1 = escaloerrsup1;
    hp = patch(app.UIAxes2, [frecuencias'; frecuencias(end:-1:1)'; frecuencias(1)'], [lo1; hi1(end:-1:1); lo1(1)], 'k');
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
    xlabel(app.UIAxes, 'Tiempo (s)', 'FontSize', 14);
    ylabel(app.UIAxes, 'Amplitud normalizada', 'FontSize', 14);
    title(app.UIAxes, 'Señal ERG', 'FontSize', 16);
    box(app.UIAxes, 'off');
    grid(app.UIAxes, 'off');
    set(app.UIAxes, 'Color', 'w');
    set(app.UIAxes, 'TickDir', 'out');
    set(findall(app.UIAxes, '-property', 'FontSize'), 'FontSize', 14);
    xlim(app.UIAxes, [app.TI(1) app.TI(2)]);

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
        % Construcción de la aplicación
        function app = interfazapp
            createComponents(app)
            startupFcn(app) % Llamada al método de inicialización
            registerApp(app, app.UIFigure)
            % Si no hay argumentos de salida, limpiar la aplicación de la memoria
            if nargout == 0
                clear app
            end
        end

        function delete(app)         % En caso de que se elimine la app
            delete(app.UIFigure)
        end
    end
end





