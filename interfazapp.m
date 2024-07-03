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
        SelectrangeoffrequencyEditField  matlab.ui.control.EditField % Seleccionar frecuencia (texto)
        SelectsegmenttimeEditFieldLabel  matlab.ui.control.Label
        SelectsegmenttimeEditField     matlab.ui.control.EditField % Seleccionar tiempo (texto)
        ComputeButton                  matlab.ui.control.Button % Compute
        DelateButton                   matlab.ui.control.Button % Delate
        UIAxes                         matlab.ui.control.UIAxes % Grafica Escalograma
        UIAxes2                        matlab.ui.control.UIAxes % Grafica Señal ERG
        UIAxes3                        matlab.ui.control.UIAxes % Grafica Promedio Escalograma
        SaveFigureastiffDropDownLabel  matlab.ui.control.Label % Guardar archivo de figura en TIFF
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

            % Creación de añadir archivo CSV
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
          
            % Creación de añadir archivo MAT
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

            % Creación del recuadro para insertar ID paciente
            app.IDpacientEditField = uieditfield(app.UIFigure, 'text');
            app.IDpacientEditField.HorizontalAlignment = 'center';
            app.IDpacientEditField.FontWeight = 'bold';
            app.IDpacientEditField.Position = [311 540 210 22];
           
            % Creación Select range of frequency
            app.SelectrangeoffrequencyEditFieldLabel = uilabel(app.UIFigure);
            app.SelectrangeoffrequencyEditFieldLabel.BackgroundColor = [0.502 0.502 0.502];
            app.SelectrangeoffrequencyEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectrangeoffrequencyEditFieldLabel.FontWeight = 'bold';
            app.SelectrangeoffrequencyEditFieldLabel.FontColor = [1 1 1];
            app.SelectrangeoffrequencyEditFieldLabel.Position = [97 487 152 22];
            app.SelectrangeoffrequencyEditFieldLabel.Text = 'Select range of frequency';

            % Se genera un recuadro que inserta texto
            app.SelectrangeoffrequencyEditField = uieditfield(app.UIFigure, 'text');
            app.SelectrangeoffrequencyEditField.Position = [256 487 100 22];

            % Creación Select segment time
            app.SelectsegmenttimeEditFieldLabel = uilabel(app.UIFigure);
            app.SelectsegmenttimeEditFieldLabel.BackgroundColor = [0.502 0.502 0.502];
            app.SelectsegmenttimeEditFieldLabel.HorizontalAlignment = 'center';
            app.SelectsegmenttimeEditFieldLabel.FontWeight = 'bold';
            app.SelectsegmenttimeEditFieldLabel.FontColor = [1 1 1];
            app.SelectsegmenttimeEditFieldLabel.Position = [340 487 122 22];
            app.SelectsegmenttimeEditFieldLabel.Text = 'Select segment time';

            % Se genera un recuadro que inserta texto
            app.SelectsegmenttimeEditField = uieditfield(app.UIFigure, 'text');
            app.SelectsegmenttimeEditField.Position = [472 487 100 22];
            
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

            % Gráfica Escalograma
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Escalograma')
            xlabel(app.UIAxes, 'Tiempo (seg)')
            ylabel(app.UIAxes, 'Frecuencia (Hz)')
            app.UIAxes.Position = [149 209 345 100];

            % Gráfica Señal ERG
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Señal ERG')
            xlabel(app.UIAxes2, 'Tiempo (s)')
            ylabel(app.UIAxes2, 'Amplitud')
            app.UIAxes2.Position = [139 314 355 95];

            % Gráfica Promedio escalograma
            app.UIAxes3 = uiaxes(app.UIFigure);
            title(app.UIAxes3, 'Promedio escalograma')
            xlabel(app.UIAxes3, 'Frecuencia (Hz)')
            ylabel(app.UIAxes3, 'Potencia')
            app.UIAxes3.Position = [149 115 345 88];

            % Creación de Guardar la figura como tiff
            app.SaveFigureastiffDropDownLabel = uilabel(app.UIFigure);
            app.SaveFigureastiffDropDownLabel.BackgroundColor = [0.502 0.502 0.502];
            app.SaveFigureastiffDropDownLabel.HorizontalAlignment = 'center';
            app.SaveFigureastiffDropDownLabel.FontWeight = 'bold';
            app.SaveFigureastiffDropDownLabel.FontColor = [1 1 1];
            app.SaveFigureastiffDropDownLabel.Position = [149 67 182 22];
            app.SaveFigureastiffDropDownLabel.Text = 'Save Figure as tiff';
            
            % Creación de Guardar archivo de figura
            app.SavefileButton = uibutton(app.UIFigure, 'push');
            app.SavefileButton.Position = [362 66 100 22];
            app.SavefileButton.Text = 'Save Figure';
            app.SavefileButton.ButtonPushedFcn = @(~, ~) saveFigureAsTIFF(app);
            
            % Creación de Guardar archivo
            app.GuardararchivoButton = uibutton(app.UIFigure, 'push');
            app.GuardararchivoButton.BackgroundColor = [0.502 0.502 0.502];
            app.GuardararchivoButton.Position = [283 25 108 22];
            app.GuardararchivoButton.FontWeight = 'bold';
            app.GuardararchivoButton.FontColor = [1 1 1];
            app.GuardararchivoButton.Text = 'Save file';
            app.GuardararchivoButton.ButtonPushedFcn = @(~, ~) guardarArchivo(app);

            app.UIFigure.Visible = 'on';
        end

        %% ABRIR ARCHIVOS .CSV Y .MAT %%
        % Función para leer y cargar archivos .csv 
        function addCSV(app, ~)
            [archivo, ruta] = uigetfile('*.csv', 'Seleccione el archivo CSV');
            if isequal(archivo, 0) || isequal(ruta, 0)
                disp('Operación cancelada');
            else
                app.filename = archivo;
                disp(['Archivo seleccionado: ', archivo]); % Imprime el nombre del archivo seleccionado
                datos = readtable(fullfile(ruta, archivo));
                
                % Ajustar los nombres de las columnas según sea necesario
                if any(strcmp('ms', datos.Properties.VariableNames)) && any(strcmp('uV', datos.Properties.VariableNames))
                    datos.Properties.VariableNames{'ms'} = 'Tiempo';
                    datos.Properties.VariableNames{'uV'} = 'Senal';
                    
                    app.datosCargados = table2struct(datos, 'ToScalar', true);
                    visualizarDatos(app, app.datosCargados); 
                else
                    uialert(app.UIFigure, 'Los datos no tienen las columnas esperadas.', 'Datos inválidos');
                end
            end
        end

        function addMAT(app, ~)
            [archivo, ruta] = uigetfile('*.mat', 'Seleccione el archivo MAT');
            if isequal(archivo, 0) || isequal(ruta, 0)
                disp('Operación cancelada');
            else 
                app.filename = archivo;
                datos = load(fullfile(ruta, archivo));
                
                % Verificar las variables en el archivo .mat
                variableNames = fieldnames(datos);
                disp(variableNames); % Mostrar nombres de variables en la consola
                
                % Intentar identificar las variables de interés
                for i = 1:length(variableNames)
                    varData = datos.(variableNames{i});
                    % Si la variable es un vector, asumimos que es la señal
                    if isvector(varData)
                        tiempo = (1:length(varData))';
                        senal = varData;
                        app.datosCargados = struct('Tiempo', tiempo, 'Senal', senal);
                        visualizarDatos(app, app.datosCargados); 
                        return;
                    % Si la variable es una estructura con campos 'Tiempo' y 'Senal'
                    elseif isstruct(varData) && isfield(varData, 'Tiempo') && isfield(varData, 'Senal')
                        app.datosCargados = varData;
                        visualizarDatos(app, app.datosCargados); 
                        return;
                    end
                end
                
                % Si no se encontraron variables de interés
                uialert(app.UIFigure, 'Los datos no tienen las variables esperadas.', 'Datos inválidos');
            end
        end

        function visualizarDatos(app, datos)
            % Verificar el tipo de datos y su estructura
            if isstruct(datos) && isfield(datos, 'Tiempo') && isfield(datos, 'Senal')
                tiempo = datos.Tiempo;
                senal = datos.Senal;
                
                % Graficar Señal ERG
                plot(app.UIAxes2, tiempo, senal);
                title(app.UIAxes2, ['Señal ERG - Archivo: ' app.filename]);
                xlabel(app.UIAxes2, 'Tiempo (s)');
                ylabel(app.UIAxes2, 'Amplitud');
                
                % Generar Escalograma
                [~, f, t, p] = spectrogram(senal, 128, 120, 128, 1E3, 'yaxis');
                surf(app.UIAxes, t, f, 10*log10(abs(p)), 'EdgeColor', 'none');
                axis(app.UIAxes, 'tight');
                view(app.UIAxes, 0, 90);
                title(app.UIAxes, ['Escalograma - Archivo: ' app.filename]);
                xlabel(app.UIAxes, 'Tiempo (s)');
                ylabel(app.UIAxes, 'Frecuencia (Hz)');
                colorbar(app.UIAxes);
                
                % Promedio del Escalograma
                promedioEscalograma = mean(10*log10(abs(p)), 2);
                plot(app.UIAxes3, f, promedioEscalograma);
                title(app.UIAxes3, ['Promedio Escalograma - Archivo: ' app.filename]);
                xlabel(app.UIAxes3, 'Frecuencia (Hz)');
                ylabel(app.UIAxes3, 'Potencia');
            else
                uialert(app.UIFigure, 'Los datos no tienen las columnas "Tiempo" y "Senal".', 'Datos inválidos');
            end
        end

        %% FUNCIONES PARA EL CÁLCULO %%
        % Función para realizar el cálculo del escalograma y la señal ERG
        function [promedioEscalograma, tiempoEscalograma, escalograma, frecuencias, senalFiltrada, tiempo] = Wavelet_Escalograma_ERG(~, datos, minFrequency, maxFrequency, minTime, maxTime)
            % Verificar el tipo de datos y su estructura
            if isfield(datos, 'Tiempo') && isfield(datos, 'Senal')
                tiempo = datos.Tiempo;
                senal = datos.Senal;
            else
                error('Los datos deben contener las columnas "Tiempo" y "Senal".');
            end

            % Filtrado de la señal
            fs = 1000; % Frecuencia de muestreo
            [b, a] = butter(4, [minFrequency maxFrequency] / (fs / 2), 'bandpass'); % Filtro paso banda
            senalFiltrada = filtfilt(b, a, senal);

            % Resampleo
            fs_resample = 50; % Frecuencia de muestreo para el resampleo
            [p, q] = rat(fs_resample / fs);
            senalResampleada = resample(senalFiltrada, p, q);

            % Generar escalograma
            [~, f, t, p] = spectrogram(senalResampleada, 128, 120, 128, fs_resample, 'yaxis');
            tiempoEscalograma = t;
            frecuencias = f;
            escalograma = 10*log10(abs(p));

            % Promedio del escalograma
            promedioEscalograma = mean(escalograma, 2);
        end

        %% TECLA DE COMPUTE %%
        % Para actualizar datos ingresados
        function compute(app)
            % Obtener los valores de los campos de entrada
            frecuenciaStr = app.SelectrangeoffrequencyEditField.Value;
            tiempoStr = app.SelectsegmenttimeEditField.Value;
            app.idPaciente = app.IDpacientEditField.Value;

            % Verificar que los valores sean válidos
            if isempty(frecuenciaStr) || isempty(tiempoStr) || isempty(app.idPaciente)
                uialert(app.UIFigure, 'Ingrese valores válidos de frecuencia, tiempo e ID de paciente.', 'Valores Inválidos');
                return;
            end
            
            try
                % Parsear los valores de frecuencia y tiempo
                freqParts = str2double(strsplit(frecuenciaStr, ','));
                timeParts = str2double(strsplit(tiempoStr, ','));

                if numel(freqParts) ~= 2 || numel(timeParts) ~= 2
                    uialert(app.UIFigure, 'Ingrese rangos válidos de frecuencia y tiempo en el formato min,max.', 'Formato Inválido');
                    return;
                end
                
                minFrequency = freqParts(1);
                maxFrequency = freqParts(2);
                minTime = timeParts(1);
                maxTime = timeParts(2);

                % Realizar cálculos y generar gráficos
                [promedioEscalograma1, tiempoEscalograma, escalograma1, frecuencias, senalFiltrada, tiempo] = app.Wavelet_Escalograma_ERG(app.datosCargados, minFrequency, maxFrequency, minTime, maxTime);

                % Visualizar escalograma
                surf(app.UIAxes, tiempoEscalograma, frecuencias, escalograma1, 'EdgeColor', 'none');
                view(app.UIAxes, 0, 90); % Vista superior
                title(app.UIAxes, 'Escalograma');
                xlabel(app.UIAxes, 'Tiempo (s)');
                ylabel(app.UIAxes, 'Frecuencia (Hz)');
                colorbar(app.UIAxes);

                % Visualizar señal ERG
                plot(app.UIAxes2, tiempo, senalFiltrada);
                title(app.UIAxes2, 'Señal ERG');
                xlabel(app.UIAxes2, 'Tiempo (s)');
                ylabel(app.UIAxes2, 'Amplitud');

                % Visualizar promedio de escalograma
                plot(app.UIAxes3, frecuencias, promedioEscalograma1);
                title(app.UIAxes3, 'Promedio Escalograma');
                xlabel(app.UIAxes3, 'Frecuencia (Hz)');
                ylabel(app.UIAxes3, 'Potencia');

                % Guardar los datos procesados en una estructura
                app.datosProcesados = struct('Tiempo', tiempo, 'Escalograma', escalograma1, 'Frecuencias', frecuencias, 'PromedioEscalograma', promedioEscalograma1, 'SenalFiltrada', senalFiltrada, 'TiempoResampleado', tiempoEscalograma, 'IDPaciente', app.idPaciente, 'Filename', app.filename);
            catch ME
                uialert(app.UIFigure, ['Error al procesar los datos: ' ME.message], 'Error');
            end
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
        % PARA GUARDAR LA FIGURA COMO .TIFF %%
    function saveFigureAsTIFF(app, ~)
        [file, path] = uiputfile('*.tiff', 'Save Figure As');
        if ischar(file)
            filePath = fullfile(path, file);

            % Crear figura temporal para las tres gráficas
            fig = figure('Visible', 'off');
            
            % Copiar y organizar los ejes en la nueva figura
            ax1 = subplot(3, 1, 1, 'Parent', fig);
            copyData(app,app.UIAxes2, ax1);
            title(ax1, 'Señal ERG');
            xlabel(ax1, 'Tiempo (s)');
            ylabel(ax1, 'Amplitud');

            ax2 = subplot(3, 1, 2, 'Parent', fig);
            copyData(app, app.UIAxes, ax2);
            title(ax2, 'Escalograma');
            xlabel(ax2, 'Tiempo (s)');
            ylabel(ax2, 'Frecuencia (Hz)');
            colorbar(ax2);

            ax3 = subplot(3, 1, 3, 'Parent', fig);
            copyData(app,app.UIAxes3, ax3);
            title(ax3, 'Promedio Escalograma');
            xlabel(ax3, 'Frecuencia (Hz)');
            ylabel(ax3, 'Potencia');

            print(fig, filePath, '-dtiff', '-r300');
            close(fig);

            disp(['Figures saved as TIFF: ', filePath]);
        else
            disp('User canceled save.');
        end
    end

    function copyData(~,srcAxes, destAxes)
        % Copiar el contenido de los ejes fuente a los ejes destino
        children = get(srcAxes, 'Children');
        for i = 1:length(children)
            child = children(i);
            copyobj(child, destAxes);
        end
        % Copiar etiquetas y otros elementos
        set(destAxes, 'XLim', get(srcAxes, 'XLim'));
        set(destAxes, 'YLim', get(srcAxes, 'YLim'));
        set(destAxes, 'ZLim', get(srcAxes, 'ZLim'));
        set(destAxes, 'CLim', get(srcAxes, 'CLim'));
        set(destAxes, 'XLabel', get(srcAxes, 'XLabel'));
        set(destAxes, 'YLabel', get(srcAxes, 'YLabel'));
        set(destAxes, 'ZLabel', get(srcAxes, 'ZLabel'));
        set(destAxes, 'Title', get(srcAxes, 'Title'));
        set(destAxes, 'Color', get(srcAxes, 'Color'));

end


        % GUARDAR ARCHIVO YA SEA COMO .MAT O .CSV %%
function guardarArchivo(app)
    % Permitir al usuario seleccionar la ubicación y el nombre del archivo
    [file, path, filterindex] = uiputfile({'.mat','MAT-files (.mat)'; '.csv','CSV-files (.csv)'}, 'Save Data As');
    if ischar(file)
        filePath = fullfile(path, file);
        datos = app.datosProcesados;

        % Verificar que los datos estén en el formato correcto
        requiredFields = {'Tiempo', 'Escalograma', 'Frecuencias', 'PromedioEscalograma', 'SenalFiltrada', 'TiempoResampleado', 'IDPaciente', 'Filename'};
        if isstruct(datos) && all(isfield(datos, requiredFields))
            if filterindex == 1
                % Guardar como archivo .mat
                try
                    save(filePath, '-struct', 'datos');
                    disp(['Data saved as MAT: ', filePath]);
                catch ME
                    uialert(app.UIFigure, ['Error al guardar archivo MAT: ' ME.message], 'Error');
                end
            elseif filterindex == 2
                % Guardar como archivo .csv
                try
                    % Convertir la estructura en una tabla
                    datosTabla = struct2table(datos, 'AsArray', true);
                    writetable(datosTabla, filePath);
                    disp(['Data saved as CSV: ', filePath]);
                catch ME
                    uialert(app.UIFigure, ['Error al guardar archivo CSV: ' ME.message], 'Error');
                end
            end
        else
            uialert(app.UIFigure, 'Los datos no están en el formato correcto para guardar.', 'Error');
        end
    else
        disp('User canceled save.');
    end
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
