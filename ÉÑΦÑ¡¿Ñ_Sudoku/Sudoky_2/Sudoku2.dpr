program Sudoku2;

uses
  Forms,
  SudokyU in 'SudokyU.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
