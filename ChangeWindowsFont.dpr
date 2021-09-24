program ChangeWindowsFont;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain} ,
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Change Windows Font';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

end.
