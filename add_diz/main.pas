unit main;
 { TODO : сделать вместо выхода создание GlobalDiz файла }
interface

uses
  Windows,  SysUtils, Forms,Messages,Functions,
  Classes,Inifiles, Controls, StdCtrls, Dialogs, XPMan;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    groups: TComboBox;
    RBGroup: TRadioButton;
    RBUser: TRadioButton;
    OpenFileD: TOpenDialog;
    XPManifest1: TXPManifest;
    SettingsBtn: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure RBUserClick(Sender: TObject);
    procedure RBGroupClick(Sender: TObject);
    procedure SettingsBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public

    { Public declarations }
  end;



var
  Form1: TForm1;
//  s:string;

implementation

uses Option, helpform;


{$R *.dfm}
{$R ICO.res}




procedure TForm1.Button2Click(Sender: TObject);
begin
application.Terminate;
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then application.Terminate;
if key=VK_RETURN then
 begin
 Button1.Click;
 end;
end;
{
add_diz.exe /GROUP=GROUPNAME|/USER=USERCOLUMNFILE [/DIZ=DESCRIPTION] FILENAME
}
procedure TForm1.Button1Click(Sender: TObject);
begin
if usergroup then
 begin
 if groups.Text <>'' then saveuserdiz (settings.GlobaldizFolder + groups.Text+'.diz',iset.FILENAME,edit1.Text,settings,iset);
 end else SaveDiz (groups.text,iset.FILENAME ,Edit1.Text,Settings,iset);
 application.Terminate;
end;

procedure TForm1.RBUserClick(Sender: TObject);
begin
usergroup:=true;;
GetUserColumns (groups,settings);
groups.DroppedDown :=true;
end;

procedure TForm1.RBGroupClick(Sender: TObject);
begin
usergroup:=false;
GetGroups (groups,Settings);
end;

procedure TForm1.SettingsBtnClick(Sender: TObject);
begin
Form2.Showmodal;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
If iset.OPTIONS then Form2.Showmodal;
If iset.HELP then Form3.Showmodal;
Form1.Top :=(screen.Height div 2)-(form1.Height div 2);
Form1.Left  :=(screen.Width div 2)-(form1.Width div 2);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Count:byte;
  ps:string;
begin
//messagebox (application.Handle,pchar(cmdline),'',0);
//messagebox (application.Handle,pchar(paramstr (1)+'|'+paramstr (2)+'|'+paramstr (3)+'|'+paramstr (4)),pchar(paramstr (2)),0);
if ParamCount<1 then halt;

iset.AUTODETECTFILENAME :=true;
iset.LIST :=false;
for count:=1 to Paramcount do
 begin
 ps:=paramstr(count);
 if (lowercase (paramstr (Count))='/o') then
  begin
  iset.OPTIONS :=true;
  exit;
  end;
 if (paramstr (Count)='/?') then
  begin
  iset.HELP :=true;
  exit;
  end;
 if (lowercase (paramstr (Count))='/c') or (lowercase (paramstr (Count))='/clear') then
  begin
  iset.CLEAR :=true;
  continue;
  end;
 if (lowercase (paramstr (Count))='/g') or (lowercase (paramstr (Count))='/gui') then
  begin
  iset.GUI :=true;
  continue;
  end;
 if (copy (lowercase (paramstr (Count)),1,5)='/delete') or (lowercase (paramstr (Count))='/d') then
  begin
  iset.DELETE:=true;
  continue;
  end;
 if (copy (lowercase (paramstr (Count)),1,6)='/group') then
  begin
  iset.USER:=false;
  iset.GROUP:=copy (paramstr (count),8,length (paramstr(count))-7);
  continue;
  end;
 if (copy (lowercase (paramstr (Count)),1,5)='/user') then
  begin
  iset.USER:=true;
  iset.USERFILE :=settings.GlobaldizFolder + copy (paramstr (count),7,length (paramstr(count))-6);
  if extractfileext(iset.USERFILE)='' then iset.USERFILE :=iset.USERFILE +'.diz';
  continue;
  end;
 if (copy (lowercase (paramstr (Count)),1,4)='/diz') then
  begin
  iset.DIZ :=copy (paramstr (count),6,length (paramstr(count))-5);
  if iset.DIZ ='?' then iset.DIZ := InputBox ('Description request','Enter decription:','');
  continue;
  end;
 if (copy (lowercase (paramstr (Count)),1,5)='/list') then
  begin
  iset.FILENAME :=copy (paramstr (count),7,length (paramstr(count))-6);
  iset.LIST :=true;
  iset.AUTODETECTFILENAME :=false;
  continue;
  end;
 if (copy (lowercase (paramstr (Count)),1,5)='/file') then
  begin
  iset.FILENAME :=copy (paramstr (count),7,length (paramstr(count))-6);
  iset.AUTODETECTFILENAME :=false;
  iset.LIST :=false;
  continue;
  end;
 if (paramstr (Count)[1]<>'/') and (paramstr (Count)[1]<>'-') and (iset.AUTODETECTFILENAME) then
  begin
  iset.FILENAME :=paramstr (count);
  continue;
  end;
//if parameter not implemented:
  iset.HELPONERROR  :='Plugin help: unknown command-line pearameter "'+paramstr(count)+'"';
  iset.HELP :=true;
  exit;
 end;
if iset.CLEAR then
 begin
 ClearDiz (settings);
 Reread_need;
 Halt;
 end;
if iset.GUI then
 begin
 if iset.FILENAME ='' then
  begin
  while iset.FILENAME ='' do      {»—ѕ–ј¬»“№}
   begin
   OpenFileD.Execute;
   if (OpenFileD.FileName ='') or (not fileexists (OpenFileD.FileName)) then Halt else 
   iset.FILENAME :=OpenFileD.FileName;
   end;
  end;
 if IsTcListFile (iset.FILENAME ) or (iset.LIST) then Form1.label1.Caption :='Set description for list of files' else Form1.label1.Caption :='Set description for '+iset.FILENAME;
 form1.Caption :=iset.FILENAME;
 GetGroups (Form1.Groups,settings);
 exit;
 end;
if iset.DELETE then
 begin
 if iset.USER then
  begin
  DelDiz (ISET.USERFILE ,iset.FILENAME,iset);
  Reread_need;
  Halt;
  end else
  begin
  DelDiz (Settings.GlobalDizFileName,iset.FILENAME,iset);
  Reread_need;
  Halt;
  end;
 exit;
 end;
if iset.USER then
 begin
 SaveUserDiz (iset.USERFILE,iset.FILENAME,iset.DIZ,settings,iset);
 Reread_need;
 Halt;
 end else
 begin
 SaveDiz (iset.GROUP,iset.FILENAME,iset.DIZ,settings,iset);
 Reread_need;
 Halt;
 end;

end;

procedure TForm1.Button2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then application.Terminate;
end;

end.
