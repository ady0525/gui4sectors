classdef practice_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        SelectImageButton      matlab.ui.control.Button
        EpicardiumButton       matlab.ui.control.Button
        EndocardiumButton_2    matlab.ui.control.Button
        ContourButton          matlab.ui.control.Button
        CloseButton            matlab.ui.control.Button
        EndocardiumMaskButton  matlab.ui.control.Button
        EpicardiumMaskButton   matlab.ui.control.Button
        MyocardiumMaskButton   matlab.ui.control.Button
    end


    properties (Access = public)
%%global variables
        
        %global variables about the original image
        Y 
        
        %helps with roipoly funcoitn for Sax images
        EpiA
        EpiB
        EpiJ
        EpiCurve
        EpiNewArray
        EndoA
        EndoB
        EndoJ
        EndoCurve
        EndoNewArray
        MyocardiumMask
                 
        %variables that help make folders and displayh images
        filename
        newfoldername
        info
        Leftax
        Rightax
        Middleax
        label
        Masklabel
        TorCFolder
        endolabel
        Sax_or_4_Ch
        
        %hleps with LAX images
        nSizeRows
        nSizeCols
        Epi_x1
        Epi_y1
        Endo_x
        Endo_y
        Endo_pos
        Epi_pos1
        Epi_value1
        Endo_value
        Epimask_LA
        Endomask_LA
        Endo_arrayx
        Endo_arrayy
        
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectImageButton
        function SelectImageButtonPushed(app, event)
       close all;%closes anything you ran previously
       %allows you to select the image you want to analyze
       [file,path] = uigetfile('*.jpg', ' Select an Image')
       
       
        if isequal(file, 0)
               disp('user selected cancel')
        else
                app.info = imread(file);
                nRow = size(app.info, 1);
                nCol = size(app.info, 2);
                app.nSizeRows = cast(uint16(nRow), 'double');
                app.nSizeCols = cast(uint16(nCol), 'double');
                text = sprintf('%s %s', 'Original', 'Image');
                app.Middleax = uiaxes(app.UIFigure, 'Position', [268 96 330 330]);
                imshow(app.info, [], 'parent', app.Middleax);
                set(app.Middleax, 'visible', 'off');
                app.endolabel = uilabel(app.UIFigure, 'Text', text, 'Position', [368 100 100 32]);
                
      end%ends the overal statement if the user chooses an image or cancels the image selection part
        
        end

        % Button pushed function: EndocardiumButton_2
        function EndocardiumButton_2Pushed(app, event)
        %deletes any image or label on the GUI so that a new image and label can take its place
        delete(app.label);
        delete(app.Leftax);
        delete(app.endolabel)
        
        %tells user which button was pressed
        display('Draw Circle for Endocardium')
        h = drawcircle('DrawingArea',"auto");
        %roi = images.roi.Circle(app.info);
        %%If the image is short axis view:
%         if contains(app.Sax_or_4_Ch, 'short');
%                 
%                 %allows you to outline the endocardium, takes the vertices and creates a rounded curved outline of the endocardium
%                 [EndoBW, app.EndoA, app.EndoB] = roipoly(app.Y);
%                 app.EndoJ = boundary(app.EndoB, app.EndoA, 0.01);
%                 app.EndoNewArray = [app.EndoA(app.EndoJ), app.EndoB(app.EndoJ)].';
%                 app.EndoCurve = fnplt(cscvn(app.EndoNewArray));
%                
%                 %displays the image with the curve on the original image
%                 app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);      
%                 imshow(app.Y, [], 'Parent', app.Leftax);
%                 hold(app.Leftax);
%                 plot(app.Leftax, app.EndoCurve(1,:), app.EndoCurve(2,:),'r');
%                 set(app.Leftax, 'visible', 'off');
%                 text = sprintf('%s %s', 'Endocardium', 'Contour');
%                 app.label = uilabel(app.UIFigure,'Text', text, 'Position',[350 100 165 32]);
%         
%                 %creates a figure so you can save it
%                 figure1 = figure('name', 'Endocardium');
%                 imshow(app.Y, [], 'Border', 'tight');
%                 hold on;
%                 plot(app.EndoCurve(1,:), app.EndoCurve(2,:),'r');
%                 hold off
%                     
%                     %%if the image is tagged:
%                     if contains(app.TorCFolder,'tagged');
%                         %below saves endocardium contour as a dicom
%                         EndoContour = 'tagSax__EndoContour';
%                         EndoContourInsert = insertAfter(EndoContour, 7, [app.filename]);
%                         print(gcf, EndoContourInsert, '-djpeg', '-r600');
%                         FileEndoContour = sprintf('%s.jpg',EndoContourInsert);
%                         Dicomname = sprintf('%s.dcm', EndoContourInsert)
%                         DicomConvert = imread(FileEndoContour);
%                         dicomwrite(DicomConvert, Dicomname, app.info);
%                         movefile (FileEndoContour, app.newfoldername);
%                         movefile (Dicomname, app.newfoldername);
%                         
%                     %if the image is cine:
%                     else contains(app.TorCFolder,'cine');
%                         %below saves endocardium contour as a dicom
%                         EndoContour = 'cineSax__EndoContour';
%                         EndoContourInsert = insertAfter(EndoContour, 8, [app.filename]);
%                         print(gcf, EndoContourInsert, '-djpeg', '-r600');
%                         FileEndoContour = sprintf('%s.jpg',EndoContourInsert);
%                         Dicomname = sprintf('%s.dcm', EndoContourInsert)
%                         DicomConvert = imread(FileEndoContour);
%                         dicomwrite(DicomConvert, Dicomname, app.info);
%                         movefile (FileEndoContour, app.newfoldername);
%                         movefile (Dicomname, app.newfoldername);
%                     end 
%                     
%         %%if the image is a long-axis view            
%         else contains(app.Sax_or_4_Ch, 'four');
%                 %allow for the freehand by opening the figure and then calling the "imfreehand" function for the endo cardium
%                 figure('name', 'Endo')
%                 imshow(app.Y);
%                 Endo_h = imfreehand;
%                 app.Endo_pos = Endo_h.getPosition();
%                 app.Endo_x = app.Endo_pos(:,1)
%                 app.Endo_y = app.Endo_pos(:,2);
%                 Endo_dime = size(app.Endo_pos)
%                 app.Endo_value = Endo_dime(1);
%                 
%                 %displays the image with the curve on the original image in GUI
%                 app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);      
%                 imshow(app.Y, [], 'Parent', app.Leftax);
%                 hold(app.Leftax);
%                 plot(app.Leftax, app.Endo_x, app.Endo_y,'r', 'LineWidth', 0.5);
%                 set(app.Leftax, 'visible', 'off');
%                 text = sprintf('%s %s', 'Endocardium', 'Contour');
%                 app.label = uilabel(app.UIFigure,'Text', text, 'Position',[350 100 165 32]);
%             
%                 %creates image to see on the contour plot on the original image
%                 figure('name', 'Contour on original')
%                 imshow(app.Y,[])
%                 hold on
%                 plot(app.Endo_x,app.Endo_y, 'r', 'linewidth', 0.5)
%                 hold off
%                     
%                      %If the image is tagged:
%                      if contains(app.TorCFolder,'tagged');
%                         %below saves endocardium contour as a dicom
%                         EndoContour = 'tag4ch__EndoContour';
%                         EndoContourInsert = insertAfter(EndoContour, 7, [app.filename]);
%                         print(gcf, EndoContourInsert, '-djpeg', '-r600');
%                         FileEndoContour = sprintf('%s.jpg',EndoContourInsert);
%                         Dicomname = sprintf('%s.dcm', EndoContourInsert)
%                         DicomConvert = imread(FileEndoContour);
%                         dicomwrite(DicomConvert, Dicomname, app.info);
%                         movefile (FileEndoContour, app.newfoldername);
%                         movefile (Dicomname, app.newfoldername);
%                     %If the image is cine:
%                     else contains(app.TorCFolder,'cine');
%                         %below saves endocardium contour as a dicom
%                         EndoContour = 'cine4ch__EndoContour';
%                         EndoContourInsert = insertAfter(EndoContour, 8, [app.filename]);
%                         print(gcf, EndoContourInsert, '-djpeg', '-r600');
%                         FileEndoContour = sprintf('%s.jpg',EndoContourInsert);
%                         Dicomname = sprintf('%s.dcm', EndoContourInsert)
%                         DicomConvert = imread(FileEndoContour);
%                         dicomwrite(DicomConvert, Dicomname, app.info);
%                         movefile (FileEndoContour, app.newfoldername);
%                         movefile (Dicomname, app.newfoldername);
%                      end% ends "tagged or cine" if statement
% 
%         end %ends "short or long" if statement
            
close all;
        end

        % Button pushed function: EpicardiumButton
        function EpicardiumButtonPushed(app, event)
        %deletes any image or label on the GUI so that a new image and label can take its place
        delete(app.label)
        delete(app.Masklabel)
        delete(app.Leftax)
        
        %reminds the user which butotn they pressed:
        display('Trace teh Epicardium')
        if contains(app.Sax_or_4_Ch, 'short');
            %creates the outline of the Epicardium
            [EpiBW, app.EpiA, app.EpiB] = roipoly(app.Y);
            app.EpiJ = boundary(app.EpiB, app.EpiA, 0.01);
            app.EpiNewArray = [app.EpiA(app.EpiJ), app.EpiB(app.EpiJ)].';
            app.EpiCurve = fnplt(cscvn(app.EpiNewArray));
    
            %shows the image on the UIFigure
            app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);      
            imshow(app.Y, [], 'Parent', app.Leftax)
            hold(app.Leftax)
            plot(app.Leftax, app.EpiCurve(1,:), app.EpiCurve(2,:),'g','LineWidth', 1);
            set(app.Leftax, 'visible', 'off');
            text = sprintf('%s %s', 'Epicardium', 'Contour');
            app.label = uilabel(app.UIFigure,'Text', text, 'Position',[365 100 165 32]);
           
            %creates a figure so you can save it
            figure3 = figure('name', 'Epicardium');
            imshow(app.Y, [], 'Border', 'tight');
            hold on;
            plot(app.EpiCurve(1,:), app.EpiCurve(2,:),'g', 'LineWidth', 0.5);
            hold off
                
                if contains(app.TorCFolder,'tagged');
                    %saves epicardium contour as a dicom
                    EpiContour = 'tagSax__EpiContour';
                    EpiContourInsert = insertAfter(EpiContour, 7, [app.filename]);
                    print(gcf, EpiContourInsert, '-djpeg', '-r600');
                    FileEpiContour = sprintf('%s.jpg',EpiContourInsert);
                    Dicomname = sprintf('%s.dcm', EpiContourInsert)
                    DicomConvert = imread(FileEpiContour);
                    dicomwrite(DicomConvert, Dicomname, app.info) ;
                    movefile(FileEpiContour, app.newfoldername);
                    movefile (Dicomname, app.newfoldername);
                    
                else contains(app.TorCFolder,'cine');
                    %saves epicardium contour as a dicom
                    EpiContour = 'cineSax__EpiContour';
                    EpiContourInsert = insertAfter(EpiContour, 8, [app.filename]);
                    print(gcf, EpiContourInsert, '-djpeg', '-r600');
                    FileEpiContour = sprintf('%s.jpg',EpiContourInsert);
                    Dicomname = sprintf('%s.dcm', EpiContourInsert)
                    DicomConvert = imread(FileEpiContour);
                    dicomwrite(DicomConvert, Dicomname, app.info) ;
                    movefile(FileEpiContour, app.newfoldername);
                    movefile (Dicomname, app.newfoldername);
                end 
                
        else contains(app.Sax_or_4_Ch, 'four');
            %long axis freehand creation of contour
            imshow(app.Y);
            hold on
            Epi_h1 = imfreehand
            app.Epi_pos1 = Epi_h1.getPosition()
            app.Epi_x1 = app.Epi_pos1(:,1);
            app.Epi_y1 = app.Epi_pos1(:,2);
            Epi_dime1 = size(app.Epi_pos1);
            app.Epi_value1 = Epi_dime1(1);
            close all;
            %epicardium contour on original image on GUI
            app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);                 
            imshow(app.Y, [], 'Parent', app.Leftax)
            hold(app.Leftax)
            plot(app.Leftax, app.Epi_x1,app.Epi_y1,'g','LineWidth', 0.5);
            set(app.Leftax, 'visible', 'off');
            text = sprintf('%s %s', 'Epicardium', 'Contour');
            app.label = uilabel(app.UIFigure,'Text', text, 'Position',[350 100 165 32]);
               
            %creatres plot to save image as a dicom
            imshow(app.Y,[],'border', 'tight')
            hold on
            plot(app.Epi_x1,app.Epi_y1,'g', 'linewidth', 0.5)
            hold off
            
            %saves images based on either tagged or cine name
                    if contains(app.TorCFolder,'tagged');
                    %saves epicardium contour as a dicom
                    EpiContour = 'tag4ch__EpiContour';
                    EpiContourInsert = insertAfter(EpiContour, 7, [app.filename]);
                    print(gcf, EpiContourInsert, '-djpeg', '-r600');
                    FileEpiContour = sprintf('%s.jpg',EpiContourInsert);
                    Dicomname = sprintf('%s.dcm', EpiContourInsert)
                    DicomConvert = imread(FileEpiContour);
                    dicomwrite(DicomConvert, Dicomname, app.info) ;
                    movefile(FileEpiContour, app.newfoldername);
                    movefile (Dicomname, app.newfoldername);
                    
                  else contains(app.TorCFolder,'cine');
                    %saves epicardium contour as a dicom
                    EpiContour = 'cine4ch__EpiContour';
                    EpiContourInsert = insertAfter(EpiContour, 8, [app.filename]);
                    print(gcf, EpiContourInsert, '-djpeg', '-r600');
                    FileEpiContour = sprintf('%s.jpg',EpiContourInsert);
                    Dicomname = sprintf('%s.dcm', EpiContourInsert)
                    DicomConvert = imread(FileEpiContour);
                    dicomwrite(DicomConvert, Dicomname, app.info) ;
                    movefile(FileEpiContour, app.newfoldername);
                    movefile (Dicomname, app.newfoldername);
                  end 
                   
       end
                    
close all;
        end

        % Button pushed function: ContourButton
        function ContourButtonPushed(app, event)
        %deletes any image or label on the GUI so that a new image and label can take its place
        delete(app.Leftax)
        delete(app.label)
        delete(app.Rightax)
        delete(app.Masklabel)
       %drawing the myocardial contour onto original image 
        if contains(app.Sax_or_4_Ch, 'short');
            %plots the curves onto one image in UIFigure
            app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);      
            imshow(app.Y, [], 'Parent', app.Leftax)
            hold(app.Leftax)
            plot(app.Leftax, app.EndoCurve(1,:), app.EndoCurve(2,:),'r', 'LineWidth', 0.5);%plot of the "splined" boundary trace of the epicardim
            plot(app.Leftax, app.EpiCurve(1,:),app.EpiCurve(2,:), 'g', 'LineWidth', 0.5);%plot of the "spline" boundary trace of the endocardium
            text = sprintf('%s %s', 'Myocardial', 'Contour')
            app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[365 100 165 32]);
            
            %allows the contour to be saved:
            figure4 = figure('name', 'Epicardial and Endocardial Contours');
            imshow(app.Y, [], 'Border', 'tight');
            hold on;
            plot(app.EndoCurve(1,:), app.EndoCurve(2,:),'r', 'LineWidth', 0.5);%plot of the "splined" boundary trace of the epicardim
            plot(app.EpiCurve(1,:),app.EpiCurve(2,:), 'g', 'LineWidth', 0.5);%plot of the "spline" boundary trace of the endocardium 
            hold off
            
                if contains(app.TorCFolder,'tagged');        
                    %creates the dicom of the epi and endo cardium on one graph
                    Contour = 'tagSax__Contour';
                    ContourInsert = insertAfter(Contour, 7, [app.filename]);
                    print(gcf, ContourInsert, '-djpeg', '-r600');
                    FileContour = sprintf('%s.jpg',ContourInsert);
                    Dicomname = sprintf('%s.dcm', ContourInsert);
                    DicomConvert = imread(FileContour);
                    dicomwrite(DicomConvert,Dicomname, app.info) ;
                    movefile(FileContour, app.newfoldername);
                    movefile (Dicomname, app.newfoldername);
                else contains(app.TorCFolder,'cine');
                    %creates the dicom of the epi and endo cardium on one graph
                    Contour = 'cineSax__Contour';
                    ContourInsert = insertAfter(Contour, 8, [app.filename]);
                    print(gcf, ContourInsert, '-djpeg', '-r600');
                    FileContour = sprintf('%s.jpg',ContourInsert);
                    Dicomname = sprintf('%s.dcm', ContourInsert);
                    DicomConvert = imread(FileContour);
                    dicomwrite(DicomConvert,Dicomname, app.info) ;
                    movefile(FileContour, app.newfoldername);
                    movefile (Dicomname, app.newfoldername);
                end 
                
        else contains(app.Sax_or_4_Ch , 'four');
            %identifying the important four points that end and start the epi and endocardium contour.
            app.Endo_arrayx= [ app.Epi_pos1(1,1); app.Endo_pos(1,1);  app.Endo_pos(app.Endo_value, 1);  app.Epi_pos1(app.Epi_value1,1)];
            app.Endo_arrayy= [app.Epi_pos1(1,2); app.Endo_pos(1,2);  app.Endo_pos(app.Endo_value, 2); app.Epi_pos1(app.Epi_value1,2)];
            
            %display the epicardium lines so you can save the image
            figure11 = figure('name', 'put it all together');
            imshow(app.Y, [], 'Border', 'tight');        
            hold on
            plot(app.Endo_arrayx, app.Endo_arrayy,'b', 'linewidth', 0.1);
            plot(app.Endo_x,app.Endo_y, 'r', 'linewidth', 0.1)
            plot(app.Epi_x1,app.Epi_y1,'g', 'linewidth', 0.1)
            hold off
            
            %plots the curves onto one image in UIFigure
            app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);      
            imshow(app.Y, [], 'Parent', app.Leftax)
            hold(app.Leftax)
            plot(app.Leftax, app.Endo_arrayx, app.Endo_arrayy,'b', 'linewidth', 0.5);
            plot(app.Leftax, app.Endo_x,app.Endo_y,'r', 'linewidth', 0.5);
            plot(app.Leftax, app.Epi_x1,app.Epi_y1,'g', 'linewidth', 0.5);
            text = sprintf('%s %s', 'Myocardial', 'Contour')
            app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[365 100 165 32]);
            
                        if contains(app.TorCFolder,'tagged');        
                            %creates the dicom of the epi and endo cardium on one graph
                            Contour = 'tagSax__Contour';
                            ContourInsert = insertAfter(Contour, 7, [app.filename]);
                            print(gcf, ContourInsert, '-djpeg', '-r600');
                            FileContour = sprintf('%s.jpg',ContourInsert);
                            Dicomname = sprintf('%s.dcm', ContourInsert);
                            DicomConvert = imread(FileContour);
                            dicomwrite(DicomConvert,Dicomname, app.info) ;
                            movefile(FileContour, app.newfoldername);
                            movefile (Dicomname, app.newfoldername);
                        else contains(app.TorCFolder,'cine');
                            %creates the dicom of the epi and endo cardium on one graph
                            Contour = 'cineSax__Contour';
                            ContourInsert = insertAfter(Contour, 8, [app.filename]);
                            print(gcf, ContourInsert, '-djpeg', '-r600');
                            FileContour = sprintf('%s.jpg',ContourInsert);
                            Dicomname = sprintf('%s.dcm', ContourInsert);
                            DicomConvert = imread(FileContour);
                            dicomwrite(DicomConvert,Dicomname, app.info) ;
                            movefile(FileContour, app.newfoldername);
                            movefile (Dicomname, app.newfoldername);
                        end
        end 
        
% close all;
        end

        % Button pushed function: CloseButton
        function CloseButtonPushed(app, event)
            close all;
            %deletes any image or label on the GUI so that a new image and label can take its place
            delete(app.Middleax)
            delete(app.Leftax)
            delete(app.Rightax)
            delete(app.label)
            delete(app.endolabel)
            delete(app.Masklabel)
            
            %allows this to move the original image into the folder with the rest of the created images
            if contains(app.Sax_or_4_Ch, 'short');
                
                if contains(app.TorCFolder,'tagged');     
                    Contour = 'tagSax_';
                    ContourInsert = insertAfter(Contour, 7, [app.filename]);
                    DicomName = sprintf('%s.dcm', ContourInsert);
                    movefile(DicomName, app.newfoldername)
                 else contains(app.TorCFolder,'cine');
                     Contour = 'cineSax_';
                     ContourInsert = insertAfter(Contour, 8, [app.filename])
                     DicomName = sprintf('%s.dcm', ContourInsert)
                     movefile(DicomName, app.newfoldername)
                end 
                
            else contains(app.Sax_or_4_Ch, 'four');
                
                if contains(app.TorCFolder,'tagged');     
                    Contour = 'tag4ch_';
                    ContourInsert = insertAfter(Contour, 7, [app.filename]);
                    DicomName = sprintf('%s.dcm', ContourInsert)
                    movefile(DicomName, app.newfoldername)
                 else contains(app.TorCFolder,'cine');
                    Contour = 'cine4ch_';
                    ContourInsert = insertAfter(Contour, 8, [app.filename])
                    DicomName = sprintf('%s.dcm', ContourInsert)
                    movefile(DicomName, app.newfoldername)
                end 
                
            end
            
                
        end

        % Button pushed function: EndocardiumMaskButton
        function EndocardiumMaskButtonPushed(app, event)
        %deletes any image or label on the GUI so that a new image and label can take its place
        delete(app.Masklabel)    
        
        if contains(app.Sax_or_4_Ch, 'short');
                if contains(app.TorCFolder,'tagged');  
                    %mask is created
                    app.Rightax = uiaxes(app.UIFigure, 'Position', [634 120 330 330]);      
                    Endomask = poly2mask(app.EndoCurve(1,:),app.EndoCurve(2,:),app.nSizeRows,app.nSizeCols);
                    imshow(Endomask, 'parent', app.Rightax);
                    text = sprintf('%s %s', 'Endocardium', 'Mask');
                    app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[700 100 230 45]);
                    %allows image to be saved as black and white
                    EndoUint8Image = mat2gray(Endomask);
                    %writes Endocardium mask as a dicom file
                    EndoMask = 'tagSax__EndoMask';
                    EndoMaskInsert = insertAfter(EndoMask, 7, [app.filename]);
                    Dicomname = sprintf('%s.dcm', EndoMaskInsert)
                    dicomwrite(EndoUint8Image, Dicomname, app.info);
                    movefile (Dicomname,app.newfoldername);
            
                else contains(app.TorCFolder,'cine');      
                    %mask is created
                    app.Rightax = uiaxes(app.UIFigure, 'Position', [634 120 330 330]);      
                    Endomask = poly2mask(app.EndoCurve(1,:),app.EndoCurve(2,:),app.nSizeRows,app.nSizeCols);
                    imshow(Endomask, 'parent', app.Rightax);
                    text = sprintf('%s %s', 'Endocardium', 'Mask');
                    app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[746 100 165 32]);
                  
                    %allows image to be saved as black and white
                    EndoUint8Image = mat2gray(Endomask);
                    %writes Endocardium mask as a dicom file
                    EndoMask = 'cineSax__EndoMask';
                    EndoMaskInsert = insertAfter(EndoMask, 8, [app.filename]);
                    Dicomname = sprintf('%s.dcm', EndoMaskInsert)
                    dicomwrite(EndoUint8Image, Dicomname, app.info);
                    movefile (Dicomname,app.newfoldername);
                 end 
        
        else contains(app.Sax_or_4_Ch, 'four');
                %mask is created
                app.Rightax = uiaxes(app.UIFigure, 'Position', [634 120 330 330]);      
                app.Endomask_LA = poly2mask(app.Endo_x,app.Endo_y, app.nSizeRows, app.nSizeCols);
                imshow(app.Endomask_LA, 'parent', app.Rightax);
                text = sprintf('%s %s', 'Endocardium', 'Mask');
                app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[746 100 165 32]);
                %allows image to be saved as black and white
                EndoUint8Image = mat2gray(app.Endomask_LA);
                        if contains(app.TorCFolder,'tagged');  
                            %writes Endocardium mask as a dicom file
                            EndoMask = 'tag4ch__EndoMask';
                            EndoMaskInsert = insertAfter(EndoMask, 7, [app.filename]);
                            Dicomname = sprintf('%s.dcm', EndoMaskInsert)
                            dicomwrite(EndoUint8Image, Dicomname, app.info);
                            movefile (Dicomname,app.newfoldername);
                    
                        else contains(app.TorCFolder,'cine');
                            %allows image to be saved as black and white
                            EndoUint8Image = mat2gray(app.Endomask_LA);
                            %writes Endocardium mask as a dicom file
                            EndoMask = 'cine4ch__EndoMask';
                            EndoMaskInsert = insertAfter(EndoMask, 8, [app.filename]);
                            Dicomname = sprintf('%s.dcm', EndoMaskInsert)
                            dicomwrite(EndoUint8Image, Dicomname, app.info);
                            movefile (Dicomname,app.newfoldername);
                         end 
       
        end
        
        
        end

        % Button pushed function: EpicardiumMaskButton
        function EpicardiumMaskButtonPushed(app, event)
        %deletes any image or label on the GUI so that a new image and label can take its place
        delete(app.Masklabel)
        delete(app.Rightax)
        
        %If the image is short axis, this part of the code will generate the epicardium mask based on the contours prevoiusly drawn
        if contains(app.Sax_or_4_Ch, 'short');
            %creates mask and displays it in UIFigure
            app.Rightax = uiaxes(app.UIFigure, 'Position', [634 120 330 330]);  
            EpiMask = poly2mask(app.EpiCurve(1,:),app.EpiCurve(2,:),app.nSizeRows,app.nSizeCols);   
            imshow(EpiMask, 'parent', app.Rightax);
            text = sprintf('%s %s', 'Epicardium', 'Mask');
            app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[746 100 165 32]);
            %allowing image to save as black and white
            EpiUint8Image = mat2gray(EpiMask);
            
                if contains(app.TorCFolder,'tagged'); 
                    %saving as dicom image
                    EpiMask = 'tagSax__EpiMask';
                    EpiMaskInsert = insertAfter(EpiMask, 7, [app.filename]);
                    Dicomname = sprintf('%s.dcm', EpiMaskInsert);
                    dicomwrite(EpiUint8Image, [Dicomname], app.info);
                    movefile (Dicomname, app.newfoldername);
                    
                else contains(app.TorCFolder,'cine'); 
                    %saving as dicom image
                    EpiMask = 'cineSax__EpiMask';
                    EpiMaskInsert = insertAfter(EpiMask, 8, [app.filename]);
                    Dicomname = sprintf('%s.dcm', EpiMaskInsert);
                    dicomwrite(EpiUint8Image, [Dicomname], app.info);
                    movefile (Dicomname, app.newfoldername);
                end 
                
        else contains(app.Sax_or_4_Ch, 'four');
            %creates mask and displays it in UIFigure
            app.Rightax = uiaxes(app.UIFigure, 'Position', [634 120 330 330]);  
            app.Epimask_LA = poly2mask(app.Epi_x1,app.Epi_y1, app.nSizeRows, app.nSizeCols);
            imshow(app.Epimask_LA, 'parent', app.Rightax);
            text = sprintf('%s %s', 'Epicardium', 'Mask');
            app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[746 100 165 32]);
            %allowing image to save as black and white
            EpiUint8Image = mat2gray(app.Epimask_LA);
            
                    if contains(app.TorCFolder,'tagged'); 
                        %saving as dicom image
                        EpiMask = 'tagSax__EpiMask';
                        EpiMaskInsert = insertAfter(EpiMask, 7, [app.filename]);
                        Dicomname = sprintf('%s.dcm', EpiMaskInsert);
                        dicomwrite(EpiUint8Image, [Dicomname], app.info);
                        movefile (Dicomname, app.newfoldername);
                        
                    else  contains(app.TorCFolder,'cine'); 
                        %saving as dicom image
                        EpiMask = 'cineSax__EpiMask';
                        EpiMaskInsert = insertAfter(EpiMask, 8, [app.filename]);
                        Dicomname = sprintf('%s.dcm', EpiMaskInsert);
                        dicomwrite(EpiUint8Image, [Dicomname], app.info);
                        movefile (Dicomname, app.newfoldername);
                        
                    end 
        end
        
        end

        % Button pushed function: MyocardiumMaskButton
        function MyocardiumMaskButtonPushed(app, event)
        %deletes any image or label on the GUI so that a new image and label can take its place
        delete(app.Leftax)
        delete(app.Masklabel)        
        delete(app.Rightax)
        
        if contains(app.Sax_or_4_Ch, 'short');
                %the Myocardium cutout and shows the image in the UIFigure
                app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);          
                imshow(app.Y, [], 'parent', app.Leftax)
                hold(app.Leftax);
                Endomask = poly2mask(app.EndoCurve(1,:),app.EndoCurve(2,:),app.nSizeRows,app.nSizeCols);% shows the mask with the endocardium outline/mask
                Epimask = poly2mask(app.EpiCurve(1,:),app.EpiCurve(2,:),app.nSizeRows, app.nSizeCols);
                app.MyocardiumMask = Epimask-Endomask;
                Y3 = app.Y;
                Y3(app.MyocardiumMask ~= 1) = app.MyocardiumMask(app.MyocardiumMask ~= 1);
                imshow(Y3, [], 'parent', app.Leftax);
                text = sprintf('%s %s', 'Myocardium', 'Mask');
                app.label = uilabel(app.UIFigure,'Text', text, 'Position',[746 100 165 32]);
                %displays an image to save as a jpeg
                imshow(app.Y, []);
                hold on
                imshow(Y3, []);
                hold off
                    %myocardial cutout saving
                    if contains(app.TorCFolder,'tagged'); 
                        MyoCutout = 'tagSax__MyoCutout';
                        MyoCutoutInsert = insertAfter(MyoCutout, 7, [app.filename]);
                        print(gcf, MyoCutoutInsert, '-djpeg', '-r600');
                        FileMyoContour = sprintf('%s.jpg',MyoCutoutInsert);
                        Dicomname = sprintf('%s.dcm', MyoCutoutInsert);
                        dicomwrite(Y3, Dicomname , app.info);
                        movefile(FileMyoContour, app.newfoldername);
                        movefile (Dicomname, app.newfoldername);
                    else contains(app.TorCFolder,'cine'); 
                        MyoCutout = 'cineSax__MyoCutout';
                        MyoCutoutInsert = insertAfter(MyoCutout, 8, [app.filename]);
                        print(gcf, MyoCutoutInsert, '-djpeg', '-r600');
                        FileMyoContour = sprintf('%s.jpg',MyoCutoutInsert);
                        Dicomname = sprintf('%s.dcm', MyoCutoutInsert);
                        dicomwrite(Y3, Dicomname , app.info);
                        movefile(FileMyoContour, app.newfoldername);
                        movefile (Dicomname, app.newfoldername);
                    end 
                %mask is created and saved
                Endomask = poly2mask(app.EndoCurve(1,:),app.EndoCurve(2,:),app.nSizeRows,app.nSizeCols);% shows the mask with the endocardium outline/mask
                Epimask = poly2mask(app.EpiCurve(1,:),app.EpiCurve(2,:),app.nSizeRows, app.nSizeCols);
                app.MyocardiumMask = Epimask-Endomask;
                app.Rightax = uiaxes(app.UIFigure, 'Position',  [634 120 330 330]);          
                hold(app.Rightax)
                imshow(app.MyocardiumMask, 'parent', app.Rightax) ;
                text_1 = sprintf('%s %s', 'Myocardium', 'Cutout');
                app.Masklabel = uilabel(app.UIFigure,'Text', text_1, 'Position',[350 100 165 32]);
                %Mask to gray so you can save the mask
                MyoUint8Image = mat2gray(app.MyocardiumMask);
                    %saving the myomask
                    if contains(app.TorCFolder,'tagged'); 
                        MyoMask = 'tagSax__MyoMask';
                        MyoMaskInsert = insertAfter(MyoMask, 7, [app.filename]);
                        Dicomname = sprintf('%s.dcm', MyoMaskInsert);
                        dicomwrite(MyoUint8Image, [Dicomname], app.info)
                        movefile (Dicomname, app.newfoldername);
                    else contains(app.TorCFolder,'cine'); 
                        MyoMask = 'cineSax__MyoMask';
                        MyoMaskInsert = insertAfter(MyoMask, 8, [app.filename]);
                        Dicomname = sprintf('%s.dcm', MyoMaskInsert);
                        dicomwrite(MyoUint8Image, [Dicomname], app.info)
                        movefile (Dicomname, app.newfoldername);
                    end 
        
        else contains(app.Sax_or_4_Ch, 'four');
            
                %to try and combine points and create a myocardium mask on a plot
                figure('name', 'Myocardium')
                hold on
                app.Epi_x1 = [app.Endo_pos(1,1); app.Epi_x1; app.Endo_pos(app.Endo_value, 1)];
                app.Epi_y1 = [app.Endo_pos(1,2); app.Epi_y1; app.Endo_pos(app.Endo_value, 2)];
                app.Epimask_LA = poly2mask(app.Epi_x1,app.Epi_y1, app.nSizeRows, app.nSizeCols);
                app.Endomask_LA = poly2mask(app.Endo_x,app.Endo_y, app.nSizeRows, app.nSizeCols);
                Myomask_LA = app.Epimask_LA - app.Endomask_LA; %myomask variable used for the GUI
                imshow(Myomask_LA);
                hold off
                
                %mask is created on GUI
                app.Rightax = uiaxes(app.UIFigure, 'Position',  [634 120 330 330]);          
                hold(app.Rightax)
                imshow(Myomask_LA, 'parent', app.Rightax);
                text = sprintf('%s %s', 'Myocardium', 'Mask');
                app.Masklabel = uilabel(app.UIFigure,'Text', text, 'Position',[746 100 165 32]);
                
                %allows mask to be saved
                MyoUint8Image = mat2gray(Myomask_LA);
                
                    %myocardium mask to dicom image
                    if contains(app.TorCFolder,'tagged');
                        MyoMask = 'tagSax__MyoMask';
                        MyoMaskInsert = insertAfter(MyoMask, 7, [app.filename]);
                        Dicomname = sprintf('%s.dcm', MyoMaskInsert);
                        dicomwrite(MyoUint8Image, [Dicomname], app.info)
                        movefile (Dicomname, app.newfoldername);   
                    else contains(app.TorCFolder,'cine'); 
                        MyoMask = 'cineSax__MyoMask';
                        MyoMaskInsert = insertAfter(MyoMask, 8, [app.filename]);
                        Dicomname = sprintf('%s.dcm', MyoMaskInsert);
                        dicomwrite(MyoUint8Image, [Dicomname], app.info)
                        movefile (Dicomname, app.newfoldername);
                    end 
                    
                %the Myocardium cutout and shows image in a figure to save
                figure('name', 'myocutout');
                Y3 = app.Y;
                Y3(Myomask_LA ~= 1)= Myomask_LA(Myomask_LA ~=1);
                hold on
                imshow(app.Y, []);
                imshow(Y3, []);
                hold off
                %PLOTS ON THE UIFIGURE
                app.Leftax = uiaxes(app.UIFigure, 'Position', [246 120 330 330]);     
                hold(app.Leftax);
                imshow(app.Y, [], 'parent', app.Leftax)
                imshow(Y3, [], 'parent', app.Leftax);
                text = sprintf('%s %s', 'Myocardium', 'Cutout');
                app.label = uilabel(app.UIFigure,'Text', text, 'Position',[350 100 165 32]);
                 
                    if contains(app.TorCFolder,'tagged'); 
                        MyoCutout = 'tagSax__MyoCutout';
                        MyoCutoutInsert = insertAfter(MyoCutout, 7, [app.filename]);
                        print(gcf, MyoCutoutInsert, '-djpeg', '-r600');
                        FileMyoContour = sprintf('%s.jpg',MyoCutoutInsert);
                        Dicomname = sprintf('%s.dcm', MyoCutoutInsert);
                        dicomwrite(Y3, Dicomname , app.info);
                        movefile(FileMyoContour, app.newfoldername);
                        movefile (Dicomname, app.newfoldername);
                    else contains(app.TorCFolder,'cine'); 
                        MyoCutout = 'cineSax__MyoCutout';
                        MyoCutoutInsert = insertAfter(MyoCutout, 8, [app.filename]);
                        print(gcf, MyoCutoutInsert, '-djpeg', '-r600');
                        FileMyoContour = sprintf('%s.jpg',MyoCutoutInsert);
                        Dicomname = sprintf('%s.dcm', MyoCutoutInsert);
                        dicomwrite(Y3, Dicomname , app.info);
                        movefile(FileMyoContour, app.newfoldername);
                        movefile (Dicomname, app.newfoldername);
                    end 
                    
                
                
        end
        
close all;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 977 504];
            app.UIFigure.Name = 'UI Figure';

            % Create SelectImageButton
            app.SelectImageButton = uibutton(app.UIFigure, 'push');
            app.SelectImageButton.ButtonPushedFcn = createCallbackFcn(app, @SelectImageButtonPushed, true);
            app.SelectImageButton.Position = [78 459 118 22];
            app.SelectImageButton.Text = 'Select Image';

            % Create EpicardiumButton
            app.EpicardiumButton = uibutton(app.UIFigure, 'push');
            app.EpicardiumButton.ButtonPushedFcn = createCallbackFcn(app, @EpicardiumButtonPushed, true);
            app.EpicardiumButton.Position = [78 299 118 22];
            app.EpicardiumButton.Text = 'Epicardium';

            % Create EndocardiumButton_2
            app.EndocardiumButton_2 = uibutton(app.UIFigure, 'push');
            app.EndocardiumButton_2.ButtonPushedFcn = createCallbackFcn(app, @EndocardiumButton_2Pushed, true);
            app.EndocardiumButton_2.Position = [78 406 118 22];
            app.EndocardiumButton_2.Text = 'Endocardium';

            % Create ContourButton
            app.ContourButton = uibutton(app.UIFigure, 'push');
            app.ContourButton.ButtonPushedFcn = createCallbackFcn(app, @ContourButtonPushed, true);
            app.ContourButton.Position = [78 192 118 22];
            app.ContourButton.Text = 'Contour';

            % Create CloseButton
            app.CloseButton = uibutton(app.UIFigure, 'push');
            app.CloseButton.ButtonPushedFcn = createCallbackFcn(app, @CloseButtonPushed, true);
            app.CloseButton.Position = [78 85 118 22];
            app.CloseButton.Text = 'Close';

            % Create EndocardiumMaskButton
            app.EndocardiumMaskButton = uibutton(app.UIFigure, 'push');
            app.EndocardiumMaskButton.ButtonPushedFcn = createCallbackFcn(app, @EndocardiumMaskButtonPushed, true);
            app.EndocardiumMaskButton.Position = [78 352 118 22];
            app.EndocardiumMaskButton.Text = 'Endocardium Mask';

            % Create EpicardiumMaskButton
            app.EpicardiumMaskButton = uibutton(app.UIFigure, 'push');
            app.EpicardiumMaskButton.ButtonPushedFcn = createCallbackFcn(app, @EpicardiumMaskButtonPushed, true);
            app.EpicardiumMaskButton.Position = [78 242 118 22];
            app.EpicardiumMaskButton.Text = 'Epicardium Mask';

            % Create MyocardiumMaskButton
            app.MyocardiumMaskButton = uibutton(app.UIFigure, 'push');
            app.MyocardiumMaskButton.ButtonPushedFcn = createCallbackFcn(app, @MyocardiumMaskButtonPushed, true);
            app.MyocardiumMaskButton.Position = [78 139 118 22];
            app.MyocardiumMaskButton.Text = 'Myocardium Mask';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = practice_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
