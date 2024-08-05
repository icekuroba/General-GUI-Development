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
        SavefileButton                 matlab.ui.control.Button % Botón de guardar archivo
        datosCargados                  struct
        datosProcesados                struct
        filename                       char % Nombre del archivo cargado
        idPaciente                     string % ID del paciente
        canal                          double = 1 % Canal
        TI                             double = [0 1] % Intervalo de tiempo
        selectedVar                    string % Variable seleccionada
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
            app.ComputeButton.ButtonPushedFcn = @(~, ~) compute(app);

            % Creación Delete
            app.DeleteButton = uibutton(app.UIFigure, 'push');
            app.DeleteButton.BackgroundColor = [0.502 0.502 0.502];
            app.DeleteButton.FontWeight = 'bold';
            app.DeleteButton.FontColor = [1 1 1];
            app.DeleteButton.Position = [348 432 100 22];
            app.DeleteButton.Text = 'Delete';
            app.DeleteButton.ButtonPushedFcn = @(~, ~) clearData(app);

            % Guardar archivo
            app.SavefileButton = uibutton(app.UIFigure, 'push');
            app.SavefileButton.BackgroundColor = [0.502 0.502 0.502];
            app.SavefileButton.Position = [283 25 108 22];
            app.SavefileButton.FontWeight = 'bold';
            app.SavefileButton.FontColor = [1 1 1];
            app.SavefileButton.Text = 'Save file';
            app.SavefileButton.Tooltip = 'Para el nombre del archivo debe tomarse en cuenta el ID del paciente como:([A-Z][ _ ][0-9]), ejemplo:Paciente1_A_totalDatos de variables';
            app.SavefileButton.ButtonPushedFcn = @(~, ~) saveFile(app);
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
                disp(['Archivo CSV seleccionado: ', app.filePath]);
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
                    disp('Archivo CSV cargado y procesado correctamente.');
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
            disp('Archivo MAT cargado y procesado correctamente.');
        end

        %% TECLA DE COMPUTE %%
        function compute(app, ~)
            % Cambiar el texto del botón a "Procesando..."
            app.ComputeButton.Text = 'Procesando...';
            drawnow; % Asegura que el cambio de texto se muestre inmediatamente

            % Iniciar medición de tiempo
            tic;

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
                app.ComputeButton.Text = 'Compute'; % Restaurar el texto del botón
                return;
            end
            if isempty(timeRange) || length(timeRange) ~= 2
                uialert(app.UIFigure, 'Por favor, ingresa un intervalo de tiempo válido en el formato [start, end]', 'Error de Datos');
                app.ComputeButton.Text = 'Compute'; % Restaurar el texto del botón
                return;
            end

            % Actualizar propiedades de frecuencia y tiempo
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

            % Validar si los datos contienen NaN
            % if any(isnan(muestra.trial{1,1}(:)))
            %    error('Los datos contienen valores NaN.');
            %end

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
            cfg = [];
            cfg.channel = app.canal;
            cfg.latency = app.TI; % Usar intervalo de tiempo ingresado
            muestra = ft_selectdata(cfg, muestra);

            % Generar advertencia de ejemplo
            warning('output time-bins are different from input time-bins, multiples of the same bin were requested but not given trial 1, frequency 191 (2.00 Hz)');

            % Medir tiempo de llamada a ft_freqanalysis
            freqAnalysisStartTime = tic;
            disp('Procesando datos...');
            % Aquí solo se procesa sin graficar
            freq = ft_freqanalysis([], muestra);  % Solo para ilustrar, asegúrate de pasar la configuración correcta
            freqAnalysisElapsedTime = toc(freqAnalysisStartTime);
            disp(['the call to "ft_freqanalysis" took ', num2str(freqAnalysisElapsedTime), ' seconds']);

            % Detener la medición de tiempo
            elapsedTime = toc;

            % Mostrar tiempo transcurrido
            disp(['Elapsed time is ', num2str(elapsedTime), ' seconds.']);

            % Mostrar alerta indicando que el procesamiento ha terminado y el tiempo transcurrido
            uialert(app.UIFigure, sprintf('El procesamiento ha terminado. En un tiempo de %.2f segundos.', elapsedTime), 'Proceso Completo');

            % Cambiar el texto del botón de nuevo a "Compute"
            app.ComputeButton.Text = 'Compute';
        end

        %% TECLA DE DELETE %% borra los datos que se ingresaron 
        function clearData(app, ~)
            clearTextFields(app);
            resetProperties(app);
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
            app.filePath = '';
            app.selectedVar = '';
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
            datosProcesados = app.datosProcesados; % Los datos procesados para guardar
            Filename = app.filename; % Nombre del archivo proporcionado por el usuario
            IDPaciente = char(app.idPaciente); % ID del paciente ingresado por el usuario
            % Guardar las variables en el archivo .mat con los nombres y el orden deseados
            save(fullFileName, 'datosProcesados', 'Filename', 'IDPaciente');
            disp(['Datos guardados en: ', fullFileName]);
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
