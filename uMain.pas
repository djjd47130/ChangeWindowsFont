unit uMain;

(*

  Change Windows Default Font
  by Jerry Dodge

  Based on article: https://www.howtogeek.com/716407/how-to-change-the-default-system-font-on-windows-10/

  NOTES:
  - Application requires elevated privileges to be able to make changes
  - Windows must be restarted before changes take effect
  - Currently assumes Windows font is always Segoe UI
    - Needs to change to remember original font to restore later

*)

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.UITypes, System.Win.Registry,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmMain = class(TForm)
    pBottom: TPanel;
    btnApply: TBitBtn;
    btnReset: TBitBtn;
    pMain: TPanel;
    lstFonts: TListBox;
    pSample: TGroupBox;
    lblSample1: TLabel;
    lblSample2: TLabel;
    lblSample3: TLabel;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure lstFontsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FIsDefault: Boolean; //Not currently in use
    procedure LoadFonts;
    procedure LoadCurrentFont;
    procedure ApplyNewFont;
    procedure ResetFont;
    procedure SetSample;
    procedure SaveState;
    procedure LoadState;
    procedure PromptRestart(const Msg: String);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

const
  KEY_APP = 'Software\JD Software\Windows Fonts'; //Not currently in use
  KEY_FONTS = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts';
  KEY_FONT_SUB = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes';

  //TODO: Make it smart enough to know / remember default Windows font by its current version
  //  Should record prior state to reset later, rather than assuming default font
  DEF_FONT = 'Segoe UI';

function ExitWindows(RebootParam: Longword): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    tpResult := OpenProcessToken(GetCurrentProcess(),
      TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      TTokenHd);
    if tpResult then begin
      tpResult := LookupPrivilegeValue(nil,
                                       SE_SHUTDOWN_NAME,
                                       TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        WinApi.Windows.AdjustTokenPrivileges(TTokenHd,
                                      False,
                                      TTokenPvg,
                                      cbtpPrevious,
                                      rTTokenPvg,
                                      pcbtpPreviousRequired);
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  pMain.Align:= alClient;
  pSample.Align:= alClient;
  LoadFonts;
  LoadCurrentFont;

end;

procedure TfrmMain.FormResize(Sender: TObject);
var
  H: Integer;
begin
  //Resize sample labels to both evenly fit parent
  H:= (pSample.ClientHeight div 3) - (lblSample1.Margins.Top * 4);
  lblSample1.Height:= H;
  lblSample2.Height:= H;
  lblSample3.Height:= H;
end;

procedure TfrmMain.btnApplyClick(Sender: TObject);
begin
  ApplyNewFont;
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
begin
  ResetFont;
end;

procedure TfrmMain.PromptRestart(const Msg: String);
begin
  //Prompt the user given message and ask whether to restart Windows
  if MessageDlg(Msg+sLineBreak+sLineBreak+'Would you like to restart now?',
    mtConfirmation, [mbYes,mbNo], 0) = mrYes then
  begin
    ExitWindows(EWX_REBOOT or EWX_FORCE);
  end;
end;

procedure TfrmMain.LoadCurrentFont;
var
  R: TRegistry;
  V: String;
begin
  //Load the current font being used by Windows
  R:= TRegistry.Create(KEY_READ);
  try
    R.RootKey:= HKEY_LOCAL_MACHINE;

    if R.OpenKey(KEY_FONT_SUB, False) then begin
      try
        if R.ValueExists(DEF_FONT) then begin
          //A custom font is currently applied
          V:= R.ReadString(DEF_FONT);
          FIsDefault:= False;
        end else begin
          //No custom font is currently applied
          V:= DEF_FONT;
          FIsDefault:= True;
        end;
      finally
        R.CloseKey;
      end;
    end else begin
      MessageDlg('Unable to load current font settings!', mtError, [mbOK], 0);
    end;

    lstFonts.ItemIndex:= lstFonts.Items.IndexOf(V);
    if lstFonts.ItemIndex = -1 then
      lstFonts.ItemIndex:= 0;

  finally
    R.Free;
  end;
  SetSample;
end;

procedure TfrmMain.LoadFonts;
begin
  //Load the list of fonts into the list box control
  lstFonts.Items.Assign(Screen.Fonts);
  lstFonts.Sorted:= True;
end;

procedure TfrmMain.ApplyNewFont;
var
  R: TRegistry;
  procedure SetVal(N, V: String);
  begin
    R.WriteString(N, V);
  end;
begin
  //Apply currently selected font as Windows font
  R:= TRegistry.Create(KEY_WRITE);
  try
    R.RootKey:= HKEY_LOCAL_MACHINE;

    if R.OpenKey(KEY_FONTS, False) then begin
      try
        SetVal('Segoe UI (TrueType)', '');
        SetVal('Segoe UI Bold (TrueType)', '');
        SetVal('Segoe UI Bold Italic (TrueType)', '');
        SetVal('Segoe UI Italic (TrueType)', '');
        SetVal('Segoe UI Light (TrueType)', '');
        SetVal('Segoe UI Semibold (TrueType)', '');
        //SetVal('Segoe UI Symbol (TrueType)', ''); //Disabled to fix issue with invalid symbols
      finally
        R.CloseKey;
      end;
      PromptRestart('Font has been applied. You must restart Windows to take effect.');
    end else begin
      MessageDlg('Unable to save changes. Please run application with elevated privileges.', mtError, [mbOK], 0);
    end;

    if R.OpenKey(KEY_FONT_SUB, False) then begin
      try
        SetVal(DEF_FONT, lstFonts.Items[lstFonts.ItemIndex]);
      finally
        R.CloseKey;
      end;
    end else begin
      //TODO: Handle error

    end;

  finally
    R.Free;
  end;
end;

procedure TfrmMain.ResetFont;
var
  R: TRegistry;
  procedure SetVal(N, V: String);
  begin
    R.WriteString(N, V);
  end;
begin
  //Reset font back to saved state
  R:= TRegistry.Create(KEY_WRITE);
  try
    R.RootKey:= HKEY_LOCAL_MACHINE;

    if R.OpenKey(KEY_FONTS, False) then begin
      try
        SetVal('Segoe MDL2 Assets (TrueType)', 'segmdl2.ttf');
        SetVal('Segoe Print (TrueType)', 'segoepr.ttf');
        SetVal('Segoe Print Bold (TrueType)', 'segoeprb.ttf');
        SetVal('Segoe Script (TrueType)', 'segoesc.ttf');
        SetVal('Segoe Script Bold (TrueType)', 'segoescb.ttf');
        SetVal('Segoe UI (TrueType)', 'segoeui.ttf');
        SetVal('Segoe UI Black (TrueType)', 'seguibl.ttf');
        SetVal('Segoe UI Black Italic (TrueType)', 'seguibli.ttf');
        SetVal('Segoe UI Bold (TrueType)', 'segoeuib.ttf');
        SetVal('Segoe UI Bold Italic (TrueType)', 'segoeuiz.ttf');
        SetVal('Segoe UI Emoji (TrueType)', 'seguiemj.ttf');
        SetVal('Segoe UI Historic (TrueType)', 'seguihis.ttf');
        SetVal('Segoe UI Italic (TrueType)', 'segoeuii.ttf');
        SetVal('Segoe UI Light (TrueType)', 'segoeuil.ttf');
        SetVal('Segoe UI Light Italic (TrueType)', 'seguili.ttf');
        SetVal('Segoe UI Semibold (TrueType)', 'seguisb.ttf');
        SetVal('Segoe UI Semibold Italic (TrueType)', 'seguisbi.ttf');
        SetVal('Segoe UI Semilight (TrueType)', 'segoeuisl.ttf');
        SetVal('Segoe UI Semilight Italic (TrueType)', 'seguisli.ttf');
        SetVal('Segoe UI Symbol (TrueType)', 'seguisym.ttf');
      finally
        R.CloseKey;
      end;
      PromptRestart('Font has been reset. You must restart Windows to take effect.');
    end else begin
      MessageDlg('Unable to save changes. Please run application with elevated privileges.', mtError, [mbOK], 0);
    end;

    if R.OpenKey(KEY_FONT_SUB, False) then begin
      try
        R.DeleteValue(DEF_FONT);
      finally
        R.CloseKey;
      end;
    end else begin
      //TODO: Handle error

    end;

  finally
    R.Free;
  end;
end;

procedure TfrmMain.lstFontsClick(Sender: TObject);
begin
  //A font has been selected in the list box control
  SetSample;
end;

procedure TfrmMain.SetSample;
begin
  //Change font of sample labels to selected font to preview
  lblSample1.Font.Name:= lstFonts.Items[lstFonts.ItemIndex];
  lblSample2.Font.Name:= lstFonts.Items[lstFonts.ItemIndex];
  lblSample3.Font.Name:= lstFonts.Items[lstFonts.ItemIndex];
end;

procedure TfrmMain.LoadState;
var
  R: TRegistry;
begin
  //TODO: Load the state as saved in local app registry
  R:= TRegistry.Create(KEY_ALL_ACCESS);
  try
    R.RootKey:= HKEY_LOCAL_MACHINE;
    //Not yet in use

  finally
    R.Free;
  end;
  SetSample;
end;

procedure TfrmMain.SaveState;
var
  R: TRegistry;
begin
  //TODO: Save the current font in local app registry
  R:= TRegistry.Create(KEY_ALL_ACCESS);
  try
    R.RootKey:= HKEY_LOCAL_MACHINE;
    //Not yet in use

  finally
    R.Free;
  end;
end;

end.
