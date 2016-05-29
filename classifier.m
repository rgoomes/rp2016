function varargout = classifier(varargin)
% CLASSIFIER MATLAB code for classifier.fig
%      CLASSIFIER, by itself, creates a new CLASSIFIER or raises the existing
%      singleton*.
%
%      H = CLASSIFIER returns the handle to a new CLASSIFIER or the handle to
%      the existing singleton*.
%
%      CLASSIFIER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFIER.M with the given input arguments.
%
%      CLASSIFIER('Property','Value',...) creates a new CLASSIFIER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before classifier_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to classifier_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help classifier

% Last Modified by GUIDE v2.5 29-May-2016 11:18:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classifier_OpeningFcn, ...
                   'gui_OutputFcn',  @classifier_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before classifier is made visible.
function classifier_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to classifier (see VARARGIN)

% Choose default command line output for classifier
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes classifier wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global reduce;
global equalize;
global normalize;
global feat_select;
global pca_;
global lda_;
global classifier_type;
global verbose;
reduce = 0;
normalize = 0;
equalize = 0;
feat_select = 0;
pca_ = 0;
lda_ = 0;
classifier_type = 'mdc';
verbose = 0;


% --- Outputs from this function are returned to the command line.
function varargout = classifier_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
value = get(handles.checkbox1, 'Value');

% --- Executes on button press in reduce_chk.
function reduce_chk_Callback(hObject, eventdata, handles)
% hObject    handle to reduce_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reduce_chk
global reduce;
reduce = get(handles.reduce_chk, 'Value');

function ratio_txt_Callback(hObject, eventdata, handles)
% hObject    handle to ratio_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ratio_txt as text
%        str2double(get(hObject,'String')) returns contents of ratio_txt as a double


% --- Executes during object creation, after setting all properties.
function ratio_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ratio_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in norm_chk.
function norm_chk_Callback(hObject, eventdata, handles)
% hObject    handle to norm_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of norm_chk
global normalize;
normalize = get(handles.norm_chk, 'Value');

% --- Executes on button press in eq_chk.
function eq_chk_Callback(hObject, eventdata, handles)
% hObject    handle to eq_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of eq_chk
global equalize;
equalize = get(handles.eq_chk, 'Value');

% --- Executes on button press in feat_select_chk.
function feat_select_chk_Callback(hObject, eventdata, handles)
% hObject    handle to feat_select_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feat_select_chk
global feat_select;
feat_select = get(handles.feat_select_chk, 'Value');

function kruskal_k_txt_Callback(hObject, eventdata, handles)
% hObject    handle to kruskal_k_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kruskal_k_txt as text
%        str2double(get(hObject,'String')) returns contents of kruskal_k_txt as a double


% --- Executes during object creation, after setting all properties.
function kruskal_k_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kruskal_k_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_corr_txt_Callback(hObject, eventdata, handles)
% hObject    handle to max_corr_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_corr_txt as text
%        str2double(get(hObject,'String')) returns contents of max_corr_txt as a double


% --- Executes during object creation, after setting all properties.
function max_corr_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_corr_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in feat_reduce_list.
function feat_reduce_list_Callback(hObject, eventdata, handles)
% hObject    handle to feat_reduce_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns feat_reduce_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from feat_reduce_list


% --- Executes during object creation, after setting all properties.
function feat_reduce_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feat_reduce_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pca_chk.
function pca_chk_Callback(hObject, eventdata, handles)
% hObject    handle to pca_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pca_chk
global pca_;
pca_ = get(handles.pca_chk, 'Value');

% --- Executes on button press in lda_chk.
function lda_chk_Callback(hObject, eventdata, handles)
% hObject    handle to lda_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of lda_chk
global lda_;
lda_ = get(handles.lda_chk, 'Value');

% --- Executes on selection change in classifier_pop.
function classifier_pop_Callback(hObject, eventdata, handles)
% hObject    handle to classifier_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns classifier_pop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from classifier_pop
global classifier_type;
ind = get(handles.classifier_pop, 'value');
if ind == 1
    classifier_type = 'mdc';
elseif ind == 2
    classifier_type = 'fld';
elseif ind == 3
    classifier_type = 'knn';
elseif ind == 4
    classifier_type = 'bayes';
elseif ind == 5
    classifier_type = 'svm';
end

% --- Executes during object creation, after setting all properties.
function classifier_pop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to classifier_pop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function split_ratio_txt_Callback(hObject, eventdata, handles)
% hObject    handle to split_ratio_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of split_ratio_txt as text
%        str2double(get(hObject,'String')) returns contents of split_ratio_txt as a double


% --- Executes during object creation, after setting all properties.
function split_ratio_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to split_ratio_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in classify_btn.
function classify_btn_Callback(hObject, eventdata, handles)
% hObject    handle to classify_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reduce;
global equalize;
global normalize;
global feat_select;
global pca_;
global lda_;
global classifier_type;
global verbose;

set(handles.acc_txt, 'String', '');
set(handles.sens_txt, 'String', '');
set(handles.spec_txt, 'String', '');

kruskal_k = inf;
max_corr  = inf;
reduce_ratio_txt = inf;
knn_k = 1;
err = 0;

if feat_select == 1
   kruskal_k = str2num(get(handles.kruskal_k_txt,'String'));
   max_corr = str2num(get(handles.max_corr_txt,'String'));
   if isempty(kruskal_k) == 1 || isempty(max_corr) == 1
      err = 1;
   end
end

if reduce == 1
    reduce_ratio_txt = str2num(get(handles.ratio_txt,'String'));
    if isempty(reduce_ratio_txt) == 1
       err = 1;
    end
end

if strcmp(classifier_type, 'knn')
    knn_k = str2num(get(handles.knn_k_txt,'String'));
    if isempty(knn_k) == 1
       err = 1;
    end
end

split_ratio = str2num(get(handles.split_ratio_txt,'String'));
if isempty(split_ratio) == 1
   err = 1;
end

if err == 0
    results = myclassify(equalize, reduce, reduce_ratio_txt, normalize, ...
        feat_select, kruskal_k, max_corr, pca_, lda_, split_ratio, classifier_type, knn_k, verbose);

    set(handles.acc_txt, 'String', sprintf('%s%%', num2str(results(1))));
    set(handles.sens_txt, 'String', sprintf('%s%%', num2str(results(2))));
    set(handles.spec_txt, 'String', sprintf('%s%%', num2str(results(3))));
else
    disp('Something is empty');
end

function knn_k_txt_Callback(hObject, eventdata, handles)
% hObject    handle to knn_k_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of knn_k_txt as text
%        str2double(get(hObject,'String')) returns contents of knn_k_txt as a double


% --- Executes during object creation, after setting all properties.
function knn_k_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to knn_k_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in verbose_chk.
function verbose_chk_Callback(hObject, eventdata, handles)
% hObject    handle to verbose_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of verbose_chk
global verbose;
verbose = get(handles.verbose_chk, 'Value');
