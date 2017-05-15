unit Option;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,inifiles,
  Dialogs, ComCtrls,Main, StdCtrls,Functions;

type
  TForm2 = class(TForm)
    Status: TStatusBar;
    GroupBox1: TGroupBox;
    Foldername: TEdit;
    Button1: TButton;
    RefCh: TCheckBox;
    ChCh: TCheckBox;
    GroupBox3: TGroupBox;
    groupbox: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    GroupBox4: TGroupBox;
    DIZT: TEdit;
    Button2: TButton;
    Button3: TButton;
    GroupBox5: TGroupBox;
    Edit2: TEdit;
    Add: TButton;
    procedure FormShow(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit2Change(Sender: TObject);
    procedure FoldernameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  GDI:byte=1; //1 - group,2  - user, 3 - gui
  IniFileName:string;
implementation

{$R *.dfm}



procedure TForm2.FormShow(Sender: TObject);
var
t1:string;
begin
t1:=includetrailingbackslash(extractfilepath(paramstr(0)))+'global_diz.ini';
if not fileexists (t1) then Inifilename:=GetSettingsFile else IniFilename:=t1;
Status.Panels[0].Text := 'IniFileName: '+Inifilename;
GetGroups (GroupBox,settings);
Foldername.Text:=Settings.GlobaldizFolder;
if Foldername.Text='\' then Foldername.Text:='';
RefCh.Checked :=Settings.RefreshPanels;
ChCh.Checked :=Settings.ConfirmReplace;
end;

procedure TForm2.RadioButton1Click(Sender: TObject);
begin
GDI:=1;
GetGroups (GroupBox,Settings);
end;

procedure TForm2.RadioButton2Click(Sender: TObject);
begin
GDI:=2;
GetUserColumns (GroupBox,Settings);
end;

procedure TForm2.RadioButton3Click(Sender: TObject);
begin
GDI:=3;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
if iset.OPTIONS then application.Terminate else Form2.Close;
end;

procedure TForm2.AddClick(Sender: TObject);
var
RunString:string;
begin
RunString:='"'+Application.ExeName+'" /FILE="%1" ';
case GDI of
 1: RunString:=RunString+'/GROUP="'+groupbox.Text+'"';
 2: RunString:=RunString+'/USER="'+Groupbox.Text+'"';
 3: RunString:=RunString+'/G';
end;
RunString:=RunString+' /DIZ="'+DIZT.Text+'"';
AddContextMenu (Edit2.Text,RunString);
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
FolderName.Text :=GiveFolder ('Select folder',Form2.Handle)
//Application.handle);
end;

procedure TForm2.Button2Click(Sender: TObject);
var
i:Tinifile;
begin
i:=TInifile.create (Inifilename);
i.WriteString('Main','GlobalDizFolder',excludetrailingbackslash (foldername.Text));
i.WriteBool('Main','RefreshPanels',RefCh.Checked);
i.WriteBool('Main','ConfirmReplace',ChCh.Checked);
i.Free;
Button3.Click;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Button3.Click;
end;

procedure TForm2.Edit2Change(Sender: TObject);
begin
if length (Edit2.Text)<1 then Add.Enabled :=false else add.Enabled :=true;
end;

procedure TForm2.FoldernameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then form2.Close;
end;

end.
