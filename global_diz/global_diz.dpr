library global_diz;


uses
  Sysutils,
  inifiles,
  Windows,
  contplug;

type
  PluginSettings=record
   GlobalDizFolder:string;
   GlobaldizFileName:string;
   UserColumnsFileNames:array [1..10] of string;
  end;

{$E wdx}
{$R *.res}

var
 Settings:PluginSettings;
 Inifilename:string;
{
procedure ContentGetDetectString(DetectString:pchar;maxlen:integer); stdcall;
Begin
end;                  }


procedure MCreateFile (filename:string);
var
x:textfile;
begin
assignfile (x,filename);
rewrite (x);
closefile (x);
end;


Procedure GetSettings;
 Function GetSettingsFile:string;
 var
 dwKeySize: DWORD;
 Key: HKEY;
 dwType: DWORD;
 begin
 if RegOpenKeyEx(hKey_Current_User,'Software\Legion\GlobalDiz', 0, KEY_READ, Key ) = ERROR_SUCCESS then
   try
   RegQueryValueEx( Key, 'IniFileName', nil, @dwType, nil, @dwKeySize );
   if (dwType in [REG_SZ, REG_EXPAND_SZ]) and (dwKeySize > 1) then
    begin
    SetLength( Result , dwKeySize-1);
    RegQueryValueEx( Key, 'IniFileName', nil, @dwType, PByte(PChar(Result)), @dwKeySize );
    result:=result;
    end;
   finally
    RegCloseKey( Key );
   end;
 end;
var
Ini:Tinifile;
MaxUserColumns:integer;
t1:string;
Begin
t1:=includetrailingbackslash(extractfilepath(IniFileName))+'global_diz.ini';
if not fileexists (t1) then ini:=Tinifile.Create(GetSettingsFile) else ini:=TInifile.Create(t1);
Settings.GlobaldizFolder :=includetrailingbackslash(ini.ReadString('main','globaldizfolder',''));
if not DirectoryExists (Settings.GlobalDizFolder ) then Settings.GlobalDizFolder :='\';
if Settings.GlobaldizFolder='\' then Settings.GlobaldizFolder:=includetrailingbackslash(extractfilepath(IniFileName));
Settings.GlobalDizFileName :=Settings.GlobaldizFolder+'global.diz';
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
for MaxUserColumns:=1 to 10 do
 begin
 if ini.ReadString('UserColumns','Column'+inttostr(MaxUserColumns),'')<>'' then Settings.UserColumnsFileNames [MaxUserColumns]:=Settings.GlobaldizFolder+ini.ReadString('UserColumns','Column'+inttostr(MaxUserColumns),'');
 end;
ini.Destroy;
end;

function ContentGetSupportedField(FieldIndex:integer;FieldName:pchar;Units:pchar;maxlen:integer):integer; stdcall;
Begin
 Case FieldIndex of
  0: Begin
     strlcopy (FieldName,'Global description',maxlen-1);
     result:=ft_string;
     End;
  1: Begin
     strlcopy (FieldName,'File group',maxlen-1);
     result:=ft_string;
     End;
     else
     if Settings.UserColumnsFileNames[Fieldindex-1]='' then result:=ft_nomorefields else
      begin
      strlcopy (FieldName,pchar(copy(Extractfilename(Settings.UserColumnsFileNames[Fieldindex-1]),1,pos('.',Extractfilename(Settings.UserColumnsFileNames[Fieldindex-1]))-1)),maxlen-1);
      result:=ft_string;
      end;
 end;
strcopy (units,'');
end;

function GetGlobalDizForFile (filename:shortstring):string;
var
diz:textfile;
s,t:string;
Begin
result:='';
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
assignfile (diz,settings.GlobaldizFileName);
reset (diz);
while not eof (diz) do
 begin
 readln (diz,s);
 t:=copy (s,1,pos ('=',s)-1);
 if lowercase(ExtractShortPathName(t))=lowercase(ExtractShortPathName(filename)) then
  begin
  result:=copy (s,pos ('=',s)+1,length(s));
  closefile (diz);
  exit;
  end;
 end;
closefile (diz);
end;

function GetGroupForFile (filename:shortstring):string;
var
s,s1:string;
diz:textfile;
Begin
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
assignfile (diz,settings.GlobaldizFileName);
result:='';
reset (diz);
s1:='';
while not eof (diz) do
 begin
 try
 readln (diz,s);
 except
 if s[1]=#13 then continue;
 end;
 if s='' then continue;
 if (s[1]='[') then s1:=s;
 if lowercase(s)='[none]' then s1:='';
 if lowercase(ExtractShortPathName(copy (s,1,pos ('=',s)-1)))=lowercase(ExtractShortPathName(filename)) then
  begin
  result:=copy (s1,2,length (s1)-2);
  closefile (diz);
  exit;
  end;
 end;
closefile (diz);
End;

function GetUserDizForFile (filename:shortstring; columnnum:byte):string;
var
diz:textfile;
s,t:string;
Begin
result:='';
if not fileexists (settings.UserColumnsFileNames [columnnum]) then MCreateFile (settings.UserColumnsFileNames [columnnum]);
assignfile (diz,settings.UserColumnsFileNames [columnnum]);
reset (diz);
while not eof (diz) do
 begin
 readln (diz,s);
 t:=copy (s,1,pos ('=',s)-1);
 if lowercase(ExtractShortPathName(t))=lowercase(ExtractShortPathName(filename)) then
  begin
  result:=copy (s,pos ('=',s)+1,length(s));
  closefile (diz);
  exit;
  end;
 end;
closefile (diz);
end;

function   ContentGetValue(FileName:pchar;FieldIndex,UnitIndex:integer;FieldValue:pbyte;maxlen,flags:integer):integer; stdcall;
Begin
//flags:=CONTENT_DELAYIFSLOW;
Case FieldIndex of
  0: Begin
     StrlCopy (pchar(FieldValue),pchar(GetGlobalDizForFile(strpas (FileName))),maxlen-1);
     result:=ft_string;
     end;
  1: Begin
     StrlCopy (pchar(FieldValue),pchar(GetGroupForFile(strpas (FileName))),maxlen-1);
     result:=ft_string;
     end;
     else
      begin
      StrlCopy (pchar(FieldValue),pchar(GetUserDizForFile(strpas (FileName),fieldindex-1)),maxlen-1);
      result:=ft_string;
      end;
  end;
//result:=ft_delayed;
end;
                                               {
procedure ContentSetDefaultParams(dps:pContentDefaultParamStruct); stdcall;
Begin
end;

function ContentGetDefaultSortOrder(FieldIndex:integer):integer; stdcall;
Begin
end;                                        }



exports
//       ContentGetDetectString,
       ContentGetSupportedField,
       ContentGetValue;
{       ContentSetDefaultParams,
       ContentGetDefaultSortOrder;}
var
x:pchar;


begin
GetMem (x,max_path);
GetModuleFilename (hInstance,x,max_path);
Inifilename:=x;
GetSettings;


//messagebox (0,'','',0);
end.
