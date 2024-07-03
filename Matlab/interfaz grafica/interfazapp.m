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
        DelateButton                   matlab.ui.control.Button % Delate
        UIAxes                         matlab.ui.control.UIAxes % Grafica Señal ERG
        UIAxes2                        matlab.ui.control.UIAxes % Grafica Espectro de Potencia
        UIAxes3                        matlab.ui.control.UIAxes % Grafica Escalograma
        SaveFigureastiffDropDownLabel  matlab.ui.control.Label % Guardar archivo de figura en FIG
        GuardararchivoButton           matlab.ui.control.Button % Guardar archivo como .csv o .mat         
        SavefileButton                 matlab.ui.control.Button % Botón de guardar archivo
        datosCargados                  struct
        datosProcesados                struct
        frecuencia                     double % Datos por tomar en cuenta de la grafica Escalograma
        tiempo                         double % Datos por tomar en cuenta de la grafica Escalograma
        filename                       string % Nombre del archivo cargado
        idPaciente                     string % ID del paciente
    end

    %% INICIALIZACIÓN DE COMPONENTES %%
    methods (Access = private)
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

            % Creación Delate
            app.DelateButton = uibutton(app.UIFigure, 'push');
            app.DelateButton.BackgroundColor = [0.502 0.502 0.502];
            app.DelateButton.FontWeight = 'bold';
            app.DelateButton.FontColor = [1 1 1];
            app.DelateButton.Position = [348 432 100 22];
            app.DelateButton.Text = 'Delate';
            app.DelateButton.ButtonPushedFcn = @(~, ~) delate(app);

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
        end
        
        function addMAT(app, ~)
        % Abrir diálogo para seleccionar archivo .mat
        [file, path] = uigetfile('*.mat', 'Seleccionar archivo .mat');
        if isequal(file, 0)
            disp('No se seleccionó ningún archivo');
            return;
        end
        
        % Cargar el archivo seleccionado
        app.  fullFileName = fullfile(path, file);
        data = load(fullFileName);
        
        % Listar las variables del archivo .mat
        vars = fieldnames(data);
        [indx, tf] = listdlg('PromptString', {'Selecciona una variable:', ...
                        'Solo se puede seleccionar una variable a la vez.', ''}, ...
                        'SelectionMode', 'single', 'ListString', vars);
        if tf == 0
            disp('No se seleccionó ninguna variable');
            return;
        end
        
        % Obtener la variable seleccionada
        selectedVar = vars{indx};
        variableData = data.(selectedVar);
        
        % Convertir a tabla
        tabla = array2table(variableData);
        number = height(tabla(:,1));
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
        cfg.lpfreq = PasBjs; % filtro pasa bajas
        cfg.lpfiltord = 5;
        cfg.hpfilter = 'yes';
        cfg.hpfreq = PasAlts; % filtro pasa altas
        cfg.hpfiltord = 4;
        cfg.demean = 'yes';
        cfg.dftfilter = 'yes';
        cfg.dftreplace = 'zero';
        muestra = ft_preprocessing(cfg, muestra); % preprocesa la señal
        muestra = ft_struct2single(muestra);
        
        % Cambia frecuencia de muestreo
        cfg = [];
        cfg.resamplefs = 50;
        muestra = ft_resampledata(cfg, muestra);
        disp(muestra.trial);
        cfg = [];
        cfg.channel = canal;
        cfg.latency = TI;
        muestra = ft_selectdata(cfg, muestra);
        
        % Obtener el escalograma de todo el registro
        actualizarEscalograma(muestra);
        end
        
        %% TECLA DE COMPUTE %%
        % Para actualizar datos ingresados
        function compute(app, ~)
        end
        
        %% TECLA DE DELATE %%
        % Para borrar datos ingresados
        function delate(app, ~)
            app.IDpacientEditField.Value = '';
            app.SelectrangeoffrequencyEditField.Value = '';
            app.SelectsegmenttimeEditField.Value = '';
            cla(app.UIAxes);
            cla(app.UIAxes2);
            cla(app.UIAxes3);
            disp('Datos borrados');
        end

        %% GUARDAR FIGURAS Y ARCHIVO GENERAL %%
        % PARA GUARDAR LA FIGURA COMO .Fig %%
    function saveFigure(app, ~)
    end
  
        %% GUARDAR ARCHIVO YA SEA COMO .MAT O .CSV %%
    function saveFile(app, ~)
    end
    end
        %% CREACIÓN Y ELIMINACIÓN DE APLICACIÓN %%
    methods (Access = public)
        % Construcción de la aplicación
        function app = interfazapp
            createComponents(app)
            registerApp(app, app.UIFigure)
            % Si no hay argumentos de salida, limpiar la aplicación de la memoria
            if nargout == 0
                clear app
            end
        end
        % En caso de que se elimine la app
        function delete(app)
            delete(app.UIFigure)
        end
    end
end