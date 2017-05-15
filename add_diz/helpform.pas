unit helpform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Functions, StdCtrls;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Option;

{$R *.dfm}

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if iset.HELP then application.Terminate else Form3.Close;
end;

procedure TForm3.FormCreate(Sender: TObject);
var
t1:string;
begin
if iset.HELPONERROR <>'' then form3.Caption:=iset.HELPONERROR;
t1:=includetrailingbackslash(extractfilepath(paramstr(0)))+'global_diz.ini';
if not fileexists (t1) then t1:=GetSettingsFile else IniFilename:=t1;
Label1.Caption :='Plugin settings file: '+t1;
Label2.Caption :='Data files stored in '+settings.GlobaldizFolder +' folder';
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
Form3.Close;
end;

procedure TForm3.Button1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key=VK_ESCAPE then Form3.Close;
end;

end.
