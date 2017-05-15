unit Option;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls,Main;

type
  TForm2 = class(TForm)
    Status: TStatusBar;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
var
t1:string;
begin
t1:=includetrailingbackslash(extractfilepath(paramstr(0)))+'global_diz.ini';
if not fileexists (t1) then Status.Panels[0].Text := 'IniFileName: '+Form1.GetSettingsFile else Status.Panels[0].Text := 'IniFileName: '+ t1;
end;

end.
