unit SudokyU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Menus, ExtCtrls, ImgList, ComCtrls, Printers, ToolWin, StdCtrls,
  MPlayer, AppEvnts;

type
  TForm1 = class(TForm)
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    ToolBar1: TToolBar;
    Load: TToolButton;
    ReshK: TToolButton;
    probepka: TToolButton;
    HelpC: TToolButton;
    Exit1: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RadioGroup2: TRadioGroup;
    SaveR: TToolButton;
    Printertools: TToolButton;
    Button1: TButton;
    MediaPlayer1: TMediaPlayer;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ToolButton1: TToolButton;
    Newgame: TToolButton;
    Led: TLabeledEdit;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //procedure NewfileClick(Sender: TObject);
    procedure PrinterToolsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure LoadClick(Sender: TObject);
    procedure SaveRClick(Sender: TObject);
    procedure probepkaClick(Sender: TObject);
    procedure ReshKClick(Sender: TObject);
    procedure HelpCClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ToolButton1Click(Sender: TObject);
    procedure NewgameClick(Sender: TObject);
    procedure LedChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  Procedure pole;
  Procedure Generation;
  Procedure Print;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
const dx = 50; dy = 50;
xk = 9 * dx; yk = 9 * dy;
xk1 = 12 * dx; yk1 = 12 * dy;
Ps =
'Это одна из разновидностей игры судоку. В отличие от    '#13+
'классической игры здесь два поля частично наложенные    '#13+
'друг на друга. Правила следующие. Необходимо заполнить  '#13+
'клетки каждого поля цифрами от 1 до 9 так чтобы в каждом'#13+
'поле по вертикалям и горизонталям каждая цифра присут-  '#13+
'ствовала один раз. Это же правило рспространяется и на  '#13+
'четырнадцать квадратов, в которых также каждая цифра    '#13+
'должна находиться один раз. Для генерации игры нажмите  '#13+
'на левую кнопку на панели инструментов. Как правило     '#13+
'программой генерируется только один вариант решения су- '#13+
'доку. Для установки цифры надо кликнуть мышкой по выбра-'#13+
'нной клетке мышкой - клетка подсветится желтым цветом.  '#13+
'Далее, кликнув мышкой по какой либо цифре, расположенных'#13+
'в колонке справа от поля, последняя помещается в выде-  '#13+
'ленную клетку. При отсутствии одиночных кандидатов то   '#13+
'есть цифр, которые можно поместить в незаполненные клет-'#13+
'ки по правилам судоку, то во всех клетках печатается    '#13+
'список кандидатов для каждой клетки. Для удаления цифры '#13+
'из клетки кликните мышкой по клетке с этой цифрой. Вари-'#13+
'анты игры бывают простыми, когда всё время присутствуют '#13+
'одиночные кандидаты, нормальные, когда одиночные канди- '#13+
'даты присутствуют не всегда, но всегда присутствуют кан-'#13+
'дидаты находящиеся один раз или в строке или в колонке  '#13+
'или в квадрате, и трудные, когда могут отсутствовать все'#13+
'перечисленные кандидаты. Уровень игры устанавливается   '#13+
'радиокнопками "Уровень игры". Можно распечатывать поле  '#13+
'игры на принтере со списком кандидатов. Также можно про-'#13+
'верять периодически правильность хода решения судоку.   '#13+
'После решения задачи можно убедиться, что вариант един- '#13+
'ственный кликнув несколько раз по кнопке "калькулятор"  '#13+
'при нажатии на которую компьютер решает задачу.         '#13+
'Имеются подсказки. Чтобы воспользоваться подсказкой надо'#13+
'кликнуть по квадрату с малыми цифрами - одиночные канди-'#13+
'даты высветятся сиреневым и или голубым цветом. Челкнув '#13+
'по одному из них все кандидаты запишутся в клетки, а ко-'#13+
'личество подсказок уменьшится на единицу.               '#13+
'Можно составлять игру вручную. Для этого необходимо кли-'#13+
'кнуть по радиокнопке "вручную" и ввести цифры в клетки. '#13+
'Для проверки наличия решения вашей игры нажмите на      '#13+
'"готово" и при положительном ответе можете начать играть'#13+
'Понравившуюся игру можно записать на диск.';
FName = 'savegame';
Nret = 6;
const
Yj: array[1..2, 1..12] of byte = (
(3, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1),
(0, 0, 1, 0, 0, 2, 0, 0, 2, 0, 0, 3));
Xi: array[1..2, 1..12] of byte = (
(2, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1),
(0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 3));
type setofbyte = set of byte;
masschi = array[1..12, 1..12] of byte;
const
 Na: array[0..1]of byte = (1, 4);
 Ko: array[0..1]of byte = (9, 12);
var
 Xf, Yf, xvk, yvk, Xpred, Ypred, Xko: integer;
 a, b, c, d, e: masschi;
 setnal: setofbyte;
 Nom, N, flagresh, Flagect, Flerror,  Nod, Trudn, FlagS, FlagPret, Fpred,
 Nxod, Fpoisk, Flagell, Npodsk: byte;
 timer:dword;
 Flagp: boolean = True;
 FNameR: String;
 f:array[1..130]of byte;

Procedure Rxy(i, j: byte; var x, y: integer);
begin
 y := (i - 1) * dy;
 x := (j - 1) * dx;
end;

Procedure Rij(var x, y: integer; var i, j: byte);
begin
 i := y div dy + 1;
 j := x div dx + 1;
 x := (j - 1) * dx;
 y := (i - 1) * dy;
end;

FUNCTION sgn(a: single): shortint;
begin
 if a < 0 then sgn := -1 else if a > 0 then sgn := 1 else sgn := 0
end;

// Определение множества допустимых чисел для установки в выбранный квадрат
// через координаты i, j
FUNCTION Oprsetnal(i, j: byte): setofbyte;
var setchi: setofbyte;
    l, k, ina, jna, fl, naf, kof: byte;
begin
 Setchi := [];
 if (i < 4) or (j < 4) then begin Kof :=0;Naf :=0 end else
 if (i > 9) or (j > 9) then begin Kof := 1;Naf := 1 end else
 begin Naf := 0;kof := 1 end;
 for fl := Naf to kof do begin
 for k := Na[fl] to Ko[fl] do if (a[k, j] > 0) then Setchi := Setchi + [a[k, j]];
 for l := Na[fl] to Ko[fl] do if (a[i, l] > 0) then setchi := setchi + [a[i, l]];
 ina := ((i - 1) div 3) * 3 + 1; jna := ((j - 1) div 3) * 3 + 1;
 for k := ina to ina + 2 do for l := jna to jna + 2 do if (a[k, l] > 0) then
 setchi := setchi + [a[k, l]];
 end;
 Oprsetnal := [1..9] - setchi;
end;

FUNCTION Oprdset(i,j: byte;setnal: setofbyte): setofbyte;
var k, l, m, ch, fl: byte;
    setnal1: setofbyte;
begin
 if (i < 10) and (j < 10) then fl := 0 else fl := 1;
 if (fl = 1) then begin
  if (i > 3) and (j > 9) then for l := 1 to 3 do if a[i, l] > 0 then begin
   ch := 0;for m := 10 to 12 do if a[i, m] = 0 then begin
    setnal1 := Oprsetnal(i, m); if a[i, l] in setnal1 then inc(ch);
   end;
   if (ch = 1) and (a[i, l] in setnal) then Setnal := [a[i, l]];
  end;
  ch:=0;
  if (j > 3) and (i > 9) then for k:=1 to 3 do if a[k, j] > 0 then begin
   for m := 10 to 12 do if a[m, j] = 0 then begin
    setnal1 := Oprsetnal(m, j);
    if a[k, j] in setnal1 then inc(ch);
   end;
   if (ch = 1) and (a[k, j] in setnal) then Setnal := [a[k, j]];
  end;
 end else begin  {fl=0}
  if (i > 3) and (j < 4) then for l := 10 to 12 do if a[i, l] > 0 then begin
   ch := 0;for m := 1 to 3 do if a[i, m] = 0 then begin
    setnal1 := Oprsetnal(i, m);if a[i, l] in setnal1 then inc(ch);
   end;
   if (ch = 1) and (a[i, l] in setnal) then Setnal := [a[i, l]];
  end;
  if (j > 3) and (i < 4) then for k := 10 to 12 do if a[k, j] > 0 then begin
   ch := 0;for m := 1 to 3 do if a[m, j] = 0 then begin
    setnal1 := Oprsetnal(m, j);
    if a[k, j] in setnal1 then inc(ch);
   end;
   if (ch = 1) and (a[k, j] in setnal) then Setnal := [a[k, j]];
  end;
 end;
 Oprdset := setnal;
end;

// Определение множества чисел, которые нельзя установить в выбранный квадрат
// по правилам судоку (по координатам X, Y)
FUNCTION Oprsetnal1(X, Y: integer): setofbyte;
var k, l: byte;
begin
 Rij(X, Y, k, l);
 Oprsetnal1 := Oprsetnal(k, l);
end;

var setc, setd: array[1..9, 1..9] of setofbyte;
o, Flo: byte;

//Поиск наличия возможности установки только одинаковых пары цифр в строках,
// колонках и квадратах, что является ошибкой в решении задачи
Procedure Scanodin;
var i, j, k, ina, jna: byte;

// Поиск всех одночисловых массивов на поле
Procedure Oprsetc(k, l: byte; var Flo: byte);
var i: byte;
begin
 setnal := Oprsetnal(k, l);
 setc[k, l] := [];
 for i := 1 to 9 do if [i] = setnal then setc[k, l] := setnal;
end;

var l: byte; x, y: integer;
begin  //scanodin
  // "обнуление" вспомогательных множеств
 for i := 1 to 9 do for j := 1 to 9 do begin
  setd[i, j] := [];
  setc[i, j] := [];
 end;
   // Поиск всех одиночных множеcтв
 Flo := 0;
 for i := 1 to 9 do for j := 1 to 9 do if (a[i, j] = 0) then
 oprsetc(i, j, Flo);
//Составление списка одинаковых одиночных множеств по горизонтали
// если их больше единицы, то это является ошибкой
Flo := 0;

 k := 1;
 While k <= 9 do begin
  for i := 1 to 8 do if setc[k, i] <> [] then
  for j := i + 1 to 9 do begin
   setnal := Oprsetnal(k, i);
   if (setc[k, i] = setnal) and (setc[k, i] = setc[k, j]) then begin
    setd[k, i] := setc[k, i]; setd[k, j] := setc[k, j];
   end;
  end;
  inc(k);
 end;
// Продолжение списка одинаковых и единственных кандидатов по вертикали
 k := 1;While k <= 9 do begin
 for i := 1 to 8 do if setc[i, k] <> [] then
 for j := i + 1 to 9 do begin
  setnal := Oprsetnal(i, k);
  if (setc[i, k] = setnal) and (setc[i, k] = setc[j, k]) then begin
  setd[i, k] := setc[i, k];
  setd[j, k] := setc[j, k];
  end;
 end;
 inc(k);
 end;
 // Продолжение списка одинаковых одиночных множеств в больших квадратах
 for i := 1 to 9 do for j := 1 to 9 do if setc[i, j] <> [] then begin
  ina := ((i - 1) div 3) * 3 + 1;
  jna := ((j - 1) div 3) * 3 + 1;
  for k := ina to ina + 2 do for l := jna to jna + 2 do
  if (i <> k) and (j <> l) and (setc[i, j] = setc[k, l]) then begin
   setd[i, j] := setc[i, j];
   setd[k, l] := setc[k, l];
  end;
 end;
end;

const bit:array[0..9]of word = (0, 1, 2, 4, 8, 16, 32, 64, 128, 256);

var fl: array [1..9] of byte;

// поиск кандидатов, которые встречаются один раз или в строке или в колонке или в квадрате
Procedure kandidati(var Flagpret: byte);
var i, j, k, l, ina, jna, m: byte;

Procedure dostroka(setnal: setofbyte);
var k: byte;
begin
 for k := 1 to 9 do if (k in setnal) then inc( fl[k] );
end;

begin
 fillchar(d, sizeof(d), 0); // обнуление массива
  Flagpret := 0;
 for i:=1 to 9 do begin
  fillchar(fl, sizeof(fl), 0);
  // поиск в строках
  for j := 1 to 9 do begin
   setnal := Oprsetnal(i, j);
   setnal := Oprdset(i, j, setnal);
   dostroka(setnal);
  end;
  // если цифра встречается один раз (fl[k]=1) то ищем координаты этой цифры
  for j := 1 to 9 do for k := 1 to 9 do if (fl[k] = 1) then begin
   setnal := Oprsetnal(i, j);
   setnal:=Oprdset(i, j, setnal);
   if (a[i, j] = 0) and (k in Setnal) and ([k] <> setnal) and (d[i, j] = 0) then
   begin
    d[i, j] := k; Flagpret := 1
   end; // фиксируем этого кандидата как единственного
  end;
 end; // for i
   // поиск в колонках
 for j := 1 to 9 do begin
  fillchar(fl, sizeof(fl), 0);
  for i := 1 to 9 do begin
   setnal := Oprsetnal(i, j);
   setnal:=Oprdset(i, j, setnal);
   dostroka(setnal)
  end;
  for i := 1 to 9 do for k := 1 to 9 do if (fl[k] = 1) then begin
  setnal := Oprsetnal(i, j);
  setnal := Oprdset(i, j, setnal);
  if (a[i, j] = 0) and (k in Setnal) and ([k] <> setnal) and (d[i, j] = 0) then
  begin
   d[i, j] := k;
   Flagpret := 1
  end;
  end;
 end; // for j
    // поиск в квадратах
 for i := 1 to 12 do for j := 1 to 12 do
 if ((i < 10) and (j < 10))
 or ((i > 3) and (j > 9))
 or ((j > 3) and (i > 9)) then
 if (i in[1, 4, 7, 10]) and (j in[1, 4, 7, 10]) then begin
  ina := ((i - 1) div 3) * 3 + 1;
  jna := ((j - 1) div 3) * 3 + 1;
  fillchar(fl, sizeof(fl), 0);
  for k := ina to ina + 2 do for l := jna to jna + 2 do if (a[k, l] = 0) then
  begin
   setnal := Oprsetnal(k, l);
   setnal := Oprdset(k, l, setnal);
   dostroka(setnal);
  end;
  for k := ina to ina + 2 do for l := jna to jna + 2 do for m:=1 to 9 do
  if (fl[m] = 1) then begin
   setnal := Oprsetnal(k, l);
   setnal := Oprdset(k, l, setnal);
   if (a[k, l] = 0) and (m in Setnal) and ([m] <> setnal) and (d[k, l] = 0) then
   begin
    d[k,l] := m;
    Flagpret := 1
   end;
  end
 end;

 for i := 10 to 12 do begin
  fillchar(fl, sizeof(fl), 0);
  // поиск в строках
  for j := 4 to 12 do begin
   setnal := Oprsetnal(i, j);
   setnal := Oprdset(i, j, setnal);
   dostroka(setnal);
  end;
  // если цифра встречается один раз (fl[k]=1) то ищем координаты этой цифры
  for j := 4 to 12 do for k := 1 to 9 do if (fl[k] = 1) then begin
   setnal := Oprsetnal(i, j);
   setnal := Oprdset(i, j, setnal);
   if (a[i, j] = 0) and (k in Setnal) and ([k] <> setnal) and (d[i, j] = 0) then
   begin
    d[i, j] := k; Flagpret := 1
   end; // фиксируем этого кандидата как единственного
  end;
 end; // for i
   // поиск в колонках
 for j := 10 to 12 do begin
  fillchar(fl, sizeof(fl), 0);
  for i := 4 to 12 do begin
   setnal := Oprsetnal(i, j);
   setnal:=Oprdset(i, j, setnal);
   dostroka(setnal)
  end;
  for i := 4 to 12 do for k := 1 to 9 do if (fl[k] = 1) then begin
  setnal := Oprsetnal(i, j);
  setnal:=Oprdset(i, j, setnal);
  if (a[i, j] = 0) and (k in Setnal) and ([k] <> setnal) and (d[i, j] = 0) then
  begin
   d[i, j] := k;
   Flagpret := 1
  end;
  end;
 end; // for j
end;

// Прорисовка рядов кандидатов в каждой ячейке поля
// Одиночные значения окрашиваются в сиреневый цвет.
// Одинаковые одноцифровые возможные множества окрашиваются в красный цвет
// "пустые" множества фиксируются красным цветом ячейки
var k, l: byte;
    setnal1: setofbyte;
Procedure fillchi(x, y: integer);
var i, j, fl, k: byte;
    S, S1: string;
begin
 Rij(x, y, i, j);
 if (i < 10) and (j < 10) then fl := 0 else fl := 1;
 if a[i, j] > 0 then exit;
 setnal := Oprsetnal(i, j);
 setnal := Oprdset(i, j, setnal);
 S := '';
 for k := 1 to 9 do if (k in setnal) then S := S + inttostr(k);
 with Form1.Image1.Canvas do begin
  Font.Size := 6;
  Font.Style := [fsbold];
  if (fl = 0) and (setnal = [])then begin
   Brush.Color := clred;
   Fillrect(Rect(x + Xi[1, j], y + Yj[1, i], x + dx - Xi[2, j], y + dy - Yj[2, i]));
   beep //в клетку нельзя поместить ни одного числа, что является ошибкой решения
  end else if (fl = 0) and (setnal = setd[i, j])
  then begin
   Brush.Color := clRed;
   Font.Color := clwhite;
   Font.Size := 12;
   beep;
  end
  else
  if (length(S) = 1) or ((d[i, j] >0 ) and (FlagS = 1)) then begin // если кандидат один
   Font.Size := 10;
   if (length(S) = 1) then begin
    Brush.Color := clfuchsia;
    Font.Color := clwhite
   end
   else if (d[i, j] > 0) and (FlagS = 1) then begin
    Brush.Color := claqua;
    Font.Color := clblack;
   end
  end else begin
   Font.Size := 6;
   Brush.Color := clwhite;
   Font.Color := clBlack;
  end;
  if (d[i, j] = 0) or (FlagS = 0) then S1 := S else S1 := inttostr(d[i, j]);
  textout(x + 2, y + 2, S1);
  Font.Size := 24;
  Font.Color := clblack;
  Brush.Color := clwhite;
 end;
end;

 // Заполнение поля числами, которые первоначально определены как известные
 // (голубой цвет квадрата) и которые уже поставлены игроком а также ряд
 // малых чисел кандидатов
var flagod: byte;
Procedure Fillpole(Va: byte);
var i, j, k: byte;
    x, y: integer;
    S: string;
begin
 Form1.pole;
 with Form1.Image1.Canvas do begin
   // фиксация решения задачи
  if (Va = 1) and (N = 126) then  with Form1.MediaPlayer1 do begin
   FileName:='C:\windows\media\Tada.wav';
   Open;
   Play;
  end;
  scanodin;//сканирование всего поля на одинаковые одиночные set
  flagod := 0;
  for i := 1 to 12 do begin
   for j := 1 to 12 do if ((i < 10) and (j < 10))
   or ((i > 9) and (j > 3))
   or ((i > 3) and (j > 9)) then begin
    setnal := Oprsetnal(i, j); setnal := Oprdset(i, j, setnal);
    S:='';
    for k := 1 to 9 do if (a[i, j] = 0) and ([k] = setnal) then
    begin
     flagod := 1; break
    end;
    if flagod = 1 then break
    end;
  end;
  if (flagod = 0) then
  kandidati(Flagpret); // поиск кандидатов, встречающихся один раз в строках, колонках
  pen.Width := 3;// или больших квадратах
  for i := 1 to 12 do for j := 1 to 12 do if ((j < 10) and (i < 10)) or ((i > 9) and
  (j > 3)) or ((j > 9) and (i > 3)) then begin
   Rxy(i, j, x, y);
   if a[i,j] > 0 then begin
    if e[i,j] > 0 then Brush.Color := clfuchsia
    else if b[i, j] > 0 then Brush.Color := clGradientInactiveCaption //cl3DLight clsilver claqua
    else Brush.Color := clwhite;
    Fillrect(Rect(x + Xi[1, j], y + Yj[1, i], x + dx - Xi[2, j], y + dy -Yj[2, i]));
    x := x + 12;
    y := y + 6;
    S := inttostr(a[i, j]);
    textout(x, y, S); //печатание числа
   end else
   if (flagod = 0) or (FlagS = 1) then fillchi(x, y);
  end; //for i j
 end;
 if (Va = 1) and (Trudn = 3) and (flagod + Flagpret = 0) and (N < 126) and (N > 0)
 and (Form1.Radiogroup2.Itemindex=0) then begin
  Form1.Label6.Visible := True;
  Form1.Label7.Visible := False;
 end
 else begin
  Form1.Label6.Visible := False;
  Form1.Label7.Visible := True;
 end;
 if N = 126 then begin
  Form1.label6.Visible := False;
  Form1.label7.Visible := False;
 end;
end;

  // Запись игры в файл
procedure write1(NameF: string);
var i, j: byte;
    fi: textfile;
begin
 assignfile(fi, NameF);
 Rewrite(fi);
 if Form1.RadioGroup2.ItemIndex = 1 then  b := a;
 if NameF = Fname then //незаконченная игра
 for i := 1 to 12 do for j := 1 to 12 do Writeln(fi, a[i, j]);
 for i := 1 to 12 do for j := 1 to 12 do Writeln(fi, b[i, j]);
 writeln(fi, Trudn);writeln(fi, Npodsk);
 for k:=1 to 130 do writeln(fi,f[k]);
 closefile(fi);
end;

Procedure Reshasgamer;
var i, j, Nod, FlagPe, Ns: byte;
begin
 Trudn := 0;Ns := N;
  repeat
   Nod := 0;FlagPe := 0;
   for i := 1 to 12 do for j := 1 to 12 do
   if ((i < 10) and (j < 10))
   or ((i > 3) and (j > 9))
   or ((j > 3) and (i > 9)) then
   if a[i, j] = 0 then begin
    setnal := Oprsetnal(i, j); setnal := Oprdset(i, j,setnal);
    for k := 1 to 9 do if [k] = setnal then begin
     inc(Nod);
     inc(N);
     a[i, j] := k
    end;
   end;
  until (N = 126) or (Nod = 0);
   // снова комп решает чтобы определить что вариант нормальный или трудный
  if N >= 126 then Trudn := 1 else begin  // сначала
   N := Ns;
   a := b;
 repeat
 Nod := 0;
  repeat
  for i := 1 to 12 do for j := 1 to 12 do
  if ((i < 10) and (j < 10))
  or ((i > 3) and (j > 9))
  or ((j > 3) and (i > 9)) then
  if a[i ,j] = 0 then begin
   setnal := Oprsetnal(i, j); setnal := Oprdset(i, j, setnal);
   // гашение единственных кандидатов
   for k := 1 to 9 do if [k] = setnal then begin
    inc(Nod);inc(N);a[i, j] := k; break;
   end;
    // при отсутствии единственных кандидатов ищет кандидатов встречающихся
    // один раз в строке или в колонке или в квадрате
   if Nod=0 then
    repeat
    Nod := 0; FlagPe := 0; kandidati(Flagpret);
    if Flagpret = 1 then for k := 1 to 12 do for l := 1 to 12 do
    if (d[k, l] > 0) and (a[k, l] = 0) then begin
     FlagPe := 1;
     a[k, l] := d[k, l]; d[k, l] := 0;
     inc(N);
     inc(Nod)
    end;
   until (Nod = 0);
  end;
  until FlagPe = 0;
 until (N = 126) or (Nod = 0);
 if N >= 126 then Trudn := 2 else Trudn := 3;
 end;
end;

 // Считывание игры из файла и заполнение поля
procedure Chit(NameF: string; var Flag: byte);
var i, j, Ns: byte;
    fi: textfile;
begin
 Flag := 0;
 assignfile(fi, NameF); {$I-} Reset(fi); {$I+}
 if (IOResult <> 0) then begin if (NameF <> Fname) then
 Showmessage('Ошибка открытия файла');
 exit;
 end;
 if NameF = Fname then
 for i := 1 to 12 do for j := 1 to 12 do Readln(fi, a[i, j]);
 for i := 1 to 12 do for j := 1 to 12 do Readln(fi, b[i, j]);
 readln(fi, Trudn);
 readln(fi, Npodsk);
 for k:=1 to 130 do readln(fi,f[k]);
 Closefile(fi);
 if NameF = Fname then erase(fi);
 Flag := 1;
 N := 0;
 if NameF = Fname then begin
  for i := 1 to 12 do for j := 1 to 12 do
  if a[i, j] > 0 then inc(N);
 end else
 for i := 1 to 12 do for j := 1 to 12 do begin
  a[i, j] := b[i, j];
  if Form1.RadioGroup2.ItemIndex = 1 then b[i, j] := 0;
  if a[i, j] > 0 then inc(N)
 end;
 Form1.Radiogroup1.ItemIndex := Trudn - 1;
 Form1.Led.Text := inttostr(Npodsk);
 Fillpole(0);
end;

// Эта процедура в свою очередь очень упрощает проседуру poisk
Procedure OprSym(i, j: byte; var Sym: word);
var ina, jna, k, l: byte;
begin
 Sym:=0;
 ina := ((i - 1) div 3) * 3 + 1;
 jna := ((j - 1) div 3) * 3 + 1;
 for k := Na[Fpoisk] to Ko[Fpoisk] do if (Sym and bit[a[k, j]] = 0) then Sym := Sym + bit[a[k, j]];
  for l := Na[Fpoisk] to Ko[Fpoisk] do if (Sym and bit[a[i, l]] = 0) then Sym := Sym + bit[a[i, l]];
  for k := ina to ina + 2 do for l := jna to jna + 2 do if (Sym and bit[a[k, l]] = 0) then Sym := Sym + bit[a[k, l]];
  if Fpoisk = 0 then begin
  if (i > 3) and (j < 4) then begin
   j:=j + 9; ina := ((i - 1) div 3) * 3 + 1;
             jna := ((j - 1) div 3) * 3 + 1;
   for k := ina to ina + 2 do for l := jna to jna + 2 do
   if (k <> i) and (Sym and bit[a[k, l]] = 0) then Sym := Sym + bit[a[k, l]];
  end;
  if (i < 4) and (j > 3) then begin
   i := i + 9;
   ina := ((i - 1) div 3) * 3 + 1;
   jna := ((j - 1) div 3) * 3 + 1;
   for k := ina to ina + 2 do for l := jna to jna + 2 do if (l <> j) and (Sym and bit[a[k,l]]=0) then Sym:=Sym + bit[a[k, l]];
  end;
 end;
end;

 // Определение возможности хода при поиске решения игры компьютером
 // работает совместно с рекурсивной проседурой поиска решения объединять их нельзя
 // то есть параметры надо менять до входа в процедуру
Function Oprnxod(var i, j: byte): boolean;
var flr: byte;
begin
 if (i < 10) and (j < 10) then Fpoisk := 0;
 if (i = 10) and (j = 9) then begin j := 4; Fpoisk := 1 end;
 repeat
 Oprnxod := True;
 flr := 0;
 if (i > ko[Fpoisk]) and (j < ko[Fpoisk]) then begin i := Na[Fpoisk]; inc(j); end;
 while(i <= ko[Fpoisk]) and (a[i, j] > 0) do begin
  inc(i);
  if (i > Ko[Fpoisk]) and (j < ko[Fpoisk]) then begin
   i := Na[Fpoisk];
   inc(j);
  end;
 end;
 if (i > ko[Fpoisk]) and (j < ko[Fpoisk]) then begin
  i := Na[Fpoisk];
  inc(j)
 end;
 if ((i > ko[Fpoisk]) and (j = ko[Fpoisk])) then
  if Fpoisk = 1 then begin
  i := ko[Fpoisk];
  Oprnxod := False;
  end
  else begin flr := 1;
  Fpoisk := 1;i := 4;j := 4; end;
  until flr = 0;
end;

var  flagv,m,p: byte;
//Рекурсивная проседура поиска варинта решения задачи Sudoku

Procedure poisk(i, j: byte);
var Sym: word;
begin
 OprSym(i, j, Sym);// определение суммы битов чисел, находящихся в клетках
 // строки колонки и квадрата
 inc(timer);
 repeat
  flagv := 0;
  if Sym = 511 then begin a[i, j] := 0; dec(N); exit end;
  repeat
   o := Random(9) + 1
  until (Sym and bit[o] = 0);
  a[i, j] := o; Sym := Sym + bit[o];
  if timer >= 200000 then begin flagv:=1; exit end; // неудачный вариант требующий много времени для создания игры
  inc(N);
  if N = 126 then begin  flagv := 1; exit;  end;
  k := i; l := j; inc(k);
  if Oprnxod(k, l) then
  poisk(k, l)
  else flagv := 1;
 until flagv = 1;
end;

Procedure Rkomp(variant1: byte);
var i, j, N1, Ns: byte;
begin
fillchar(c, sizeof(c), 0);
 c := a; // массиву c присваивается массив a
 N := 0;for i := 1 to 12 do for j := 1 to 12 do if a[i, j] > 0 then inc(N);
 if (N = 0) and (Form1.Button1.Visible = True) then exit;
 N1 := N;
 Ns := N;
 if N < 126 then
 begin
  repeat i := 1;
  N := Ns;j := 1;Fpoisk := 0; timer := 0;
  if Oprnxod(i, j) then Poisk(i, j);
  until timer < 200000;
 end;
 if N = 126 then Flagect := 1 else Flagect := 0;
 if (variant1 = 0) and (N = 126) then Form1.Label2.Caption := 'Нет ошибок';
 if (Flagect = 0) then Form1.Label2.Caption := 'Есть ошибки';
 if (variant1 = 0) or (N <> 126) then
 a := c; // обратное присваивание массива a
 Fillpole(0);
 N := N1;
end;
   // Генерация игры
var Ns, r, q, x, y: byte;

Procedure TForm1.Generation;
var i, j: byte;

FUNCTION fnmax(a, b: byte): byte;
begin
 if a > b then fnmax := a else fnmax := b;
end;

FUNCTION fnmin(a, b: byte): byte;
begin
 if a < b then fnmin := a else fnmin := b;
end;

var Masa: array[1..12, 1..12]of string[Nret];

Procedure Cravn(e, a: masschi; var flag: byte);
var i, j: byte;
    f: array[1..30] of byte;
begin
 fillchar(f, sizeof(f), 0);
 flag:=0;
 for j := 1 to 12 do for i := 1 to 12 do
 if (a[i, j] > 0) and (e[i, j] > 0) then begin
  if (a[i, j] <> e[i, j]) then inc(flag);
  Masa[i, j] := Masa[i, j] + inttostr(a[i, j]);
 end;
end;

var z, z1, p: array[1..Nret] of byte;
    lmax: byte;
// Поиск клетки с максимальным количеством вариантов с установкой в этой
// клетке фиксированного числа максимально встречающегося в различных вариантах
// то есть проводится увеличение массива фиксированных чисел на единицу с целью
// уменьшения вариантов решения задачи суджоку
Procedure Poiskb(var imax, jmax, ch: byte);
var i, j, m, o, r, q, k: byte;
    set1, setm: setofbyte;
    S :string;
begin
 fillchar(z, sizeof(z), 0);
 fillchar(z1, sizeof(z1), 0);
 fillchar(p, sizeof(p), 0);
 // находится клетка с максимальным количеством вариантов чисел
 lmax := 0;
 for i := 1 to 12 do for j := 1 to 12 do if Masa[i, j] <> '' then begin
  S := Masa[i, j];
  Set1 := [];
  for m := 1 to Nret do Set1 := set1 + [strtoint(S[m])];
  m:=0;
  for k := 1 to 9 do if k in set1 then inc(m);
  if lmax < m then begin
   lmax := m;
   imax := i;
   jmax := j;
   setm := set1
  end;
 end;
 S := masa[imax, jmax];
 for k := 1 to Nret do z[k] := Strtoint(copy(S, k, 1));
 o := lmax;
 setnal := [];
 // обработка информации в массиве цифр
 for k := 1 to o do begin
  m:=1;
  While m <= Nret do if (z[m] >0 ) and not( z[m] in setnal) then begin
   setnal := setnal + [z[m]];
   z1[k] := z[m];
   m:=Nret + 1;
  end else inc(m);
 end;
 for r := 1 to o do begin
  q := z1[r];
  p[r] := 0;
  for k := 1 to Nret do if (q = z[k]) then inc(p[r]);
 end;
 repeat Flo :=0;
 k := 0;for r := 1 to o do if (p[r] > 0) and (k < p[r]) then k := r;
 ch := z1[k]; // найдена цифра с максимальным количеством вхождения в массив
 e:=a;
 b[imax, jmax] := ch;
 a := b; i := 1;j := 1;N := Ns + 1; Fpoisk := 0; timer := 0;
 if Oprnxod(i, j) then poisk(i, j);
 if N < 126 then begin p[k] := 0;a := e; // если вариант оказался длительным для решения
 end;
 until N = 126;
 inc(Ns);
end;

//var timer1,timer2,timer3:dword;
// Корректировка начальных фиксированных цифр для обеспечения одного варианта задачи
Procedure resha;
var k, i, j, flag, ch: byte;
    o, flag1: byte;
begin
 flag1 := 0;
 i := 1;
 j := 1;Fpoisk := 0;
 timer := 0;
 if Oprnxod(i, j) then poisk(i, j); // находим базовый вариант с которым будет вестис сравнение
 if N < 126 then exit;
 e := a;
 // ищем количество решений массива рабочий массив сравниваем с
 N := Ns;
 repeat
 Fillchar(Masa, sizeof(Masa), #0); // обнуление строкового массива цифр для
 // каждой клетки при различных вариантах решения задачи
  // Набор Nret вариантов решения задачи и их сравнение
 for o := 1 to Nret do begin
  a := b;
  N := Ns;
  Fpoisk := 0;
  timer := 0;
  i := 1; j := 1;
  if Oprnxod(i, j) then
  poisk(i, j);
  if N < 126 then exit;
  Cravn(e, a, flag);
 end;
 if flag = 0 then inc(flag1);
 if flag > 0 then begin
  flag1 := 0;
  Poiskb(i, j, ch);
  a := b; k := 1; l := 1;N := Ns; Fpoisk := 0; timer := 0;
  if Oprnxod(k, l) then poisk(k, l);
  if N < 126 then exit;
  e := a; N := Ns;
 end;
 if flag1 = 2 * Nret then begin // после проверки еще раз проверяем вариант на наличие решения
 // если решения нет то поиск повторяется с самого начала
  i := 1; j := 1; Fpoisk := 0; N := Ns; timer := 0;
  a := b;
  if Oprnxod(i, j) then Poisk(i, j);
  if N < 126 then exit;
  end;
 until flag1 = 2 * Nret; // окончание цикла проверки на единственный вариант решения
   // разбросать часть цифр массива b из 1-го поля во второе в крайные квадраты
   //напротив первый квадрат не трогать
 a := b;
 fillchar(e, sizeof(e), 0);
end;

Procedure Genfiks;
var k, l, i, j, o, Nx: byte;
begin
 // начальная генерация фиксированных цифр
 Randomize;Flerror := 0;
 fillchar(a, sizeof(a), 0); // обнуление массива а
 N := 0;
 i := 1;
 j := 1; Fpoisk := 0; timer := 0;
 if Oprnxod(i, j) then poisk(i, j); // Генерация варианта игры с неизвестными свойствами
 // удаление из массива цифр до количества 27 или 33 в зависимости от заданной трудности
 case Radiogroup1.ItemIndex of
  0: Ns := 33;
  1..2: Ns := 27;
 end;
 Nx := 6;
 for i := 1 to 3 do for j := 1 to 3 do begin // для лучшей равномерности
  o := 0;
  repeat
  repeat
   l := Random(3) + 1 + (j - 1) * 3;
   k := Random(3) + 1 + (i - 1) * 3;
   until a[k, l] > 0;
   a[k, l] := 0;
   dec(N);
   inc(o)
  until (o = Nx) or (N = Ns);
 end;
 for i:=4 to 9 do begin
 Nx:=Random(3) + 1; o := 0;
 repeat
 repeat
 l := Random(3) + 10;
 until a[i, l] > 0;
 a[i, l] := 0; dec(N); inc(o);
 until(o = Nx) or (N = Ns);
 end;
 for j := 4 to 9 do begin
 Nx := Random(3) + 1;o := 0;
 repeat
 repeat
 k := Random(3) + 10;
 until a[k, j] > 0;
 a[k,j] := 0; dec(N); inc(o);
 until(o = Nx) or (N = Ns);
 end;
 Nx := Random(7) + 1; o := 0;
 repeat
 repeat
 k := random(3) + 10;
 l := random(3) + 10;
 until a[k, l] > 0;
 a[k,l] := 0; dec(N); inc(o);
 until(o = Nx) or (N = Ns);
 if N > Ns then
 repeat
 repeat
  l := Random(12) + 1;
  k := Random(12) + 1;
 until a[k, l] > 0;
 a[k, l] := 0;
 dec(N);
 until N = Ns;
 b := a;
end;

var N1, k, l: byte;
S: string;
begin
 Flo := 0;
 repeat
 N := 0;
 repeat
 Randomize;
 fillchar(a, 4 * sizeof(a), 0); // обнуление массивов
 Genfiks;
 Resha;
 N1 := N;
 N := 0;
 for i := 1 to 12 do for j := 1 to 12 do if b[i, j] > 0 then inc(N);
 Ns := N;
  // определение трудности задачи при прохождении проверки - N1=126
  // Trudn=1 - легкий вариант
  // Trudn=2 - нормальный вариант
  // Trudn=3 - труднвй вариант
 Trudn := 0;
 if N1 = 126 then begin
  N := Ns;
  // компьютор решает задачу как игрок
  reshasgamer;
  N := Ns;
  a := b;
 end;  // N1 = 126
 until N1 = 126; // если произошла ошибка при проверке (N1<126) то все повторяется с самого начала
 until Trudn = Radiogroup1.ItemIndex + 1; // делаются циклы до получения заданной трудности
 Npodsk := Trudn * 3;
 Form1.Led.Text := inttostr(Npodsk);
 N := Ns;
 Form1.Label2.Caption := '';
 fillchar(f, sizeof(f), 0);
 Nxod := 0;
 Fillpole(0);
end; // генерации задачи

// Ряд цифр от 0 до 9 справа от поля
Procedure Rickolonka;
const
 Sp:array[1..3] of string[5] = ('1 2 3','4 5 6','7 8 9');
var k, m: byte;
    S: string;
begin
 with Form1.Image1.Canvas do begin
  pen.Width := 2;
  Font.Color := clBlack;
  Brush.Color := clwhite;
  for k := 0 to 8 + sgn(Npodsk) do begin
   Rectangle(Xko, k * dy + 4, Xko + dx - 2,(k + 1) * dy - 2);
   S := inttostr(k + 1);
   if k < 9 then textout(Xko + 12, 8 + k * dy, S)
   else begin
    Font.Size := 6;
    for m:=1 to 3 do textout(Xko + 7, 5+(m - 1)*11 + k * dy, Sp[m]);
    Font.Size := 24;
   end;
  end;
 end;
end;

// Создание картинки поля, состоящего из 126 квадрата и вертикального ряда цифр
Procedure Tform1.pole;
var i: byte;
begin
 with Image1.Canvas do begin
  Brush.Color := clwhite;
  FillRect(Rect(0, 0, Image1.Width, Image1.Height));
  Brush.Color := clwhite;
  Font.Color := clBlack;
  pen.Color := clblack;
  pen.Width := 3;
  Rectangle(1, 1, xk - 0, yk - 0);
  for i := 1 to 3 do begin   //три вертикальные линии
   moveto(dx * 3 * i, 0);
   lineto(dx * 3 * i, yk1 - 2)
  end;
  for i := 1 to 3 do begin // три горизонтальные линии
   moveto(0, dy * 3 * i);
   lineto(xk1-2, dy * 3 * i)
  end;
  moveto(3 * dx, yk1 - 2);
  lineto(xk1 - 2, yk1 - 2);
  lineto(xk1 - 2, 3 * dy);
  pen.Width := 1;
  for i := 1 to 2 do begin
   moveto(dx * i, 0);
   lineto(dx * i, yk)
  end;
  for i := 1 to 2 do begin
   moveto(0, dy * i);
   lineto(xk, dy * i)
  end;
  for i := 10 to 11 do begin
   moveto(dx * i, 3 * dy);
   lineto(dx * i, yk1)
  end;
  for i := 10 to 11 do begin
   moveto(3 * dx, dy * i);
   lineto(xk1, dy * i)
  end;
  for i := 4 to 8 do begin
  moveto(i * dx, 0);
  lineto(i * dx, yk1)
  end;
  for i := 4 to 8 do begin
  moveto(0,i * dy);
  lineto(xk1, i * dy)
  end;
  Font.Style:=[fsbold];
  Font.Size := 24;
  pen.Width := 3;
  Rickolonka;
  brush.Color := Form1.Color;
  Floodfill(Xko - 3, 4, clblack, fsBorder);
  Brush.Color := clwhite;
 end;
end;

procedure TForm1.FormActivate(Sender: TObject);
var fl: byte;
begin
 Xko := Xk1 + 24; //Координата вертикального ряда цифр справа от поля
 chit(Fname, fl); // Считывание незаконченной игры
 if fl = 0 then pole; //если нет незаконченной игры
end;

Procedure DoNxod(k, l: byte);
var m:byte;
begin
 inc(Nxod);
 inc(N);
 m := (k - 1) * 12 + l;
 f[Nxod] := m;
end;

Procedure decNxod(i, j: byte);
var m :byte;
begin
 if Nxod = 0 then exit;
 m := (i - 1) * 12 + j;
 for k := 1 to Nxod do if m = f[k] then break;
 a[i, j] := 0;
 for m := k to 130 do f[m] := f[m+1];
 Dec(N);
 dec(Nxod);
 Flerror := 0;
 Fillchar(e, sizeof(e), 0);
 Fillpole(1);
end;

Procedure Probepka1(i, j: byte);
var m, k, l, ina, jna, fl, kof, naf: byte;
begin
  // проверяем горизонтальный ряд
 if (j < 4) or (i < 4) then begin kof := 0; naf := 0 end else
 if (i > 9) or (j > 9) then begin kof := 1;naf := 1 end else
 begin naf := 0; kof := 1 end;
 for fl := naf to kof do
 for m := Na[fl] to Ko[fl] do if (j <> m) and (a[i, j] = a[i, m]) then begin
  Flerror := 12 * (i - 1) + j;
  e[i, j] := a[i, j];
  e[i, m] := a[i, m];
  beep;break
 end;
 // проверяем вертикадьнвй ряд
 for fl := naf to kof do
 for m := Na[fl] to Ko[fl] do if (i <> m) and (a[i, j] = a[m, j]) then begin
  Flerror := 12 * (i - 1) + j;
  e[i, j] := a[i, j];
  e[m, j] := a[m, j];
  beep;break
 end;
  // проверяем большие квадраты
 ina := ((i - 1) div 3) * 3 + 1;
 jna := ((j - 1) div 3) * 3 + 1;
 for k := ina to ina + 2 do for l := jna to jna + 2 do
 if (i <> k) and (j <> l) and (a[i, j] = a[k, l]) then begin
  Flerror := 12 * (i - 1) + j;
  e[i, j] := a[i, j];
  e[k, l] :=a [k, l];
  beep;
  exit
 end;
end;

Procedure scan;
var i, j, m, Ns, k :Byte;
begin
 for i := 1 to 12 do for j := 1 to 12 do
 if ((i < 10) and (j < 10))
 or ((i > 3) and (j > 9))
 or ((j > 3) and (i > 9)) then begin
 if a[i, j] = 0 then begin
  setnal := Oprsetnal(i, j); setnal := Oprdset(i, j,setnal);
  for k := 1 to 9 do if [k] = setnal then begin a[i, j] := k; doNxod(i, j);  end;
 end;
 if (d[i,j] > 0) and (a[i, j] = 0) then begin
 a[i,j] := d[i,j]; d[i,j] := 0;
 doNxod(i, j);
 end;
 end;
end;

var flagf:byte;x1,y1:integer;
 // Обработка кликов мыши на поле и на колонке справа от поля
 // проседура по решению судоку
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i, j, ina, jna, m, k, l :byte;
    S: string;
begin
 with Image1.Canvas do begin
   // если клик по полю
  if (x < Xk1) then begin
   Rij(x, y, i, j);
   if ((i > 9) and (j < 4)) or ((j > 9) and (i < 4)) then exit;
   if (b[i, j] > 0) then exit;
   if (Flerror > 0) then if (Flerror <> (i - 1) * 12 + j) then exit
   else begin
    Flerror := 0; a[i, j] := 0;
    dec(N);
    dec(Nxod);
    fillchar(e, sizeof(e), 0);
    Fillpole(1);
   end;
   Form1.Label2.Caption := '';
   Xf := x;
   Yf := y;
   setnal := oprsetnal(i, j);
   setnal := Oprdset(i, j, setnal);
   if (FlagS = 1) and (Npodsk > 0) then begin
    if (a[i, j] > 0) then exit;
    if ((a[i, j] = 0) or (d[i, j] > 0)) and (Npodsk > 0) then begin
     dec(Npodsk);
     Form1.Led.Text := inttostr(Npodsk);
     scan;
     FlagS := 0;
     Fillpole(1);
     exit
    end;
   end else
   if (pixels[xf + 3, Yf + 30] = clwhite)
   or (pixels[xf + 3, Yf + 30] = clfuchsia) then begin
    //гасим предыдущий желтый квадрат если он не был погашен
    if (Fpred > 0) and (pixels[Xpred + 3, Ypred + 40] = clyellow) then begin
     Brush.Color := clwhite;
     xvk := xpred;
     yvk := ypred;
     Fpred := 0;
     Flagell := 0;
     Fillrect(Rect(xvk + Xi[1, j], yvk + Yj[1, i], xvk + dx - Xi[2, j], yvk + dy - Yj[2,i]));
    end;
    if a[i, j] > 0 then begin //Если в квадрате находится число то гасим его
     decNxod(i, j);
     Fillpole(1);
     flagell := 0;
     exit
    end;
    Brush.Color := clyellow;
    xvk := x;
    yvk := y;
    Fillrect(Rect(xvk + Xi[1, j], yvk + Yj[1, i], xvk + dx - Xi[2, j], yvk + dy - Yj[2,i]));
    Xpred := Xvk;
    Ypred := yvk;
    Fpred := i;
    Flagell := 1;
    if flagod = 0 then Fillchi(Xvk,yvk);
   end else begin // желтый переделываем в белый
    Brush.Color := clwhite;
    xvk := xpred;
    yvk := ypred;
    Fpred := 0;
    flagell := 0;
    Fillrect(Rect(xvk + Xi[1, j], yvk + Yj[1, i], xvk + dx - Xi[2, j], yvk + dy - Yj[2,i]));
   end;
  end {конец обработки нажатия на поле}
  else if (x > Xko) and (x < Xko + dx) and (y > 3) and (y < dy * 10 - 2) then
  if (Npodsk>0) and (y>dy*9) then begin //челчок по мелким цифрам
   FlagS := 1 - FlagS;
   if FlagS = 0 then begin
    dec(Npodsk); Led.Text:=inttostr(Npodsk);
   end;
   Fillpole(1);
  end else if (flagell=1) then begin //щелчок по колонке справа
   Flerror := 0;
   fillchar(e, sizeof(e), 0);
   Rij(xvk, yvk, i, j); // xvk, yvk - координаты выделенного квадрата на поле
   setnal:=Oprsetnal(i, j);
   setnal:=Oprdset(i, j, setnal);
   Nom := y div dy + 1;
   if a[i, j] > 0 then decNxod(i, j);
   a[i, j] := nom;
   doNxod(i, j);
   Probepka1(i, j);
   Fillpole(1);
  end;
 end;
end;
  // Распечатка задачи на листе (для тех кому удобнее решать на бумаге)
  // Проседура взята с исходника размещенного на сайте
  { http://www.delphisources.ru }
  // создание и отображеие стандартного окна печати
Procedure TForm1.Print;
var
 x1, x2, y1, y2: integer;
 Koefmasht: byte;
 PointsX, PointsY: double;
 PrintDlg: TPrintDialog;
begin
 PrintDlg := TPrintDialog.Create(Owner);
 if PrintDlg.Execute then begin
   // новый документ
   Koefmasht := 70;
   Printer.BeginDoc;
   Printer.Canvas.Refresh; // обновление инф-ии на холсте принтера
   // инф-я о разрешении принтера (70 - коэф-т масштабирования)
   repeat
   PointsX := GetDeviceCaps(Printer.Canvas.Handle,LOGPIXELSX)/Koefmasht;
   PointsY := GetDeviceCaps(Printer.Canvas.Handle,LOGPIXELSY)/Koefmasht;
   // рассчет размеров изображения
   x1 := round((Printer.PageWidth-Image1.Picture.Bitmap.Width*PointsX)/2);
   y1 := round((Printer.PageHeight-Image1.Picture.Bitmap.Height*PointsY)/2);
   if (x1 < 0) then Koefmasht := Round(Koefmasht * 1.1);
   if x1>300 then Koefmasht := Round(Koefmasht / 1.05);
   until (x1 > 0) and (x1 <= 300);
   x2 := round(x1+Image1.Picture.Bitmap.Width*PointsX);
   y2 := round(y1+Image1.Picture.Bitmap.Height*PointsY);
   // вывод изображения на печать
   Printer.Canvas.CopyRect(Rect(x1,y1,x2,y2),Image1.Picture.Bitmap.Canvas,
    Rect(0,0,Image1.Picture.Bitmap.Width,Image1.Picture.Bitmap.Height));
   Printer.EndDoc;
  end;
 // уничтожение созданного окна печати
 PrintDlg.Free;
end;

procedure TForm1.PrinterToolsClick(Sender: TObject);
 begin
  FlagS := 1; // печатание поля с кандидатами
  Fillpole(0);
  Print;
  FlagS := 0;
  Fillpole(0);
end;

procedure TForm1.LoadClick(Sender: TObject);
var flag:byte;
begin
 with OpenDialog1 do begin
  FnameR := '';
  Filter := 'Файлы судоку *.fsd|*.fsd';
  if Execute then begin
   FnameR := OpenDialog1.FileName;
   chit(FnameR, flag);
  end;
 end;
end;

// Фиксация окончания создание новой игры вручную
procedure TForm1.Button1Click(Sender: TObject);
begin
 Rkomp(0);
 Ns := N; b := a;
 reshasgamer;
 a := b;
 N := Ns;
 Radiogroup1.ItemIndex := Trudn - 1;
 Npodsk := Trudn * 3;
 Form1.Led.Text := inttostr(Npodsk);
 Radiogroup2.ItemIndex := 1 - Flagect;
 RadioGroup2Click(Sender);
 Flerror := 0;
 FlagS:=0;
end;

procedure TForm1.SaveRClick(Sender: TObject);
begin
 with SaveDialog1 do begin
  Filter := 'Файлы судоку *.fsd|*.fsd';
  if SaveDialog1.Execute then begin
   SaveDialog1.FileName := ChangeFileExt(FileName,'.fsd');
   FnameR := SaveDialog1.FileName;
   write1(FNameR);
  end;
 end;
end;

//проверка наличия варианта решения игры игроком
procedure TForm1.probepkaClick(Sender: TObject);
begin
 if Radiogroup2.ItemIndex = 1 then b := a;
 Rkomp(0);
 if Radiogroup2.ItemIndex = 1 then fillchar(b, sizeof(b), 0);
end;

var Nit: byte;  // Решение задачи компьютером (калькулятор)
procedure TForm1.ReshKClick(Sender: TObject);
begin
 if Radiogroup2.ItemIndex = 0 then a := b else b := a;
 Rkomp(1);
 if Radiogroup2.ItemIndex = 1 then begin
  if flagresh = 0 then begin
   flagresh := 1;Nit := 0
  end;
  inc(Nit);
  a := b;
  if Nit = 7 then begin
   flagresh := 0; // при проверке количества решений на 7 попытке снова выдается поле для продолжения создания игры
   if Radiogroup2.ItemIndex = 1 then fillchar(b, sizeof(b), 0);
   Fillpole(0);
  end;
 end;
end;

procedure TForm1.HelpCClick(Sender: TObject);
begin
 with Label1 do begin
  Visible := Flagp;
  if Flagp then begin
   Form1.Autosize := False;
   Form1.Width := 1248;
  end else begin
   Form1.Width := 785;
   Form1.Autosize := True
  end;
  Flagp := not Flagp;
  Caption := Ps;
 end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 if (N > 0) and (N < 126) then write1(Fname);
 Close;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
var i, j: byte;
begin
 N := 0;
 for i := 1 to 12 do for j := 1 to 12 do if a[i, j] > 0 then inc(N);
 FlagS := Radiogroup2.ItemIndex;
 if FlagS = 1 then begin
  button1.Visible := True;
  Newgame.Enabled := False;
  Fillpole(0);
 end else begin
  button1.Visible := False;
  Newgame.Enabled := True;
  b := a; FlagS := 0;
  Fillpole(0);
 end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if (N > 0) and (N < 126) then write1(Fname);
end;
         // Секретная процедура
procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
 // крутить на себя легонько
 if N > 0 then begin
  FlagS := 1 - FlagS;
  Fillpole(0);
 end
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
var k, i, j: byte;
begin
 k := f[Nxod];
 i := (k - 1) div 12 + 1;
 j := (k - 1) mod 12 + 1;
 decNxod(i, j);
end;

procedure TForm1.NewgameClick(Sender: TObject);
begin
 case Radiogroup2.Itemindex of
  0: begin
   Fpred := 0;
   Button1.Visible:=false;
   flagresh := 0;
   Generation
  end;
  1: begin
   N := 0;
   Fillchar(a, Sizeof(a), 0);
   Fillchar(b, Sizeof(b), 0);
   fillchar(f, sizeof(f), 0);
   FlagS:=1;
   Fillpole(0);
  end;
 end;
end;

procedure TForm1.LedChange(Sender: TObject);
var Ch:byte;S:string;
begin
 S := Led.Text;
 if S = '' then begin
  S := '0';
  Npodsk := 0;
  Led.Text := S
 end;
 if (S[1] in['0'..'9']) then begin
 Ch := strtoint(Led.Text);
 if Ch > Npodsk then
 Led.Text := inttostr(Npodsk);
 end;
end;

end.

