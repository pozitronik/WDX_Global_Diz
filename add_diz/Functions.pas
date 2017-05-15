unit functions;

interface
uses
messages,windows,inifiles,sysutils,StdCtrls,Classes,ShlObj;

type
  PluginSettings=record
   GlobaldizFolder:string;
   GlobalDizFileName:string;
   UserColumnsFileNames:array [1..10] of string;
   RefreshPanels:boolean;
   ConfirmReplace:boolean;
  end;

type
  internalSettings=record
   CLEAR:boolean; //Clear main file
   GUI:boolean; //show GUI
   USER:boolean; //WORK WITH USER COLUMN (if false work with groups)
   USERFILE:string; //User column filename
   GROUP:string; //group name
   DIZ:string; //file description
   FILENAME:string;//filename
   AUTODETECTFILENAME:BOOLEAN; //if "/file" parameter passed, then disable filename autodetect
   LIST:boolean;//if true, then listfile passed
   DELETE:boolean; //delete file from group
   OPTIONS:boolean;//show settings dialog
   HELP:Boolean;//Show Help
   HELPONERROR:string;//error in command-line;
  end;


Function GetSettingsFile:string;
Procedure GetSettings (Var Settings:PluginSettings);
procedure MCreateFile (filename:string);
Procedure GetGroups (var Groups:TCombobox; settings:PluginSettings);
Function IsTCListFile (filename:string):boolean;
procedure ClearDiz (settings:PluginSettings);
procedure DelDiz (FromFile,ForFile:string;var iset:InternalSettings);
Procedure SaveUserDiz (DizFile,forfile,newdiz:string;Settings:PluginSettings;iset:InternalSettings);
procedure SaveDiz (group,forfile,newdiz:string;Settings:PluginSettings;Iset:InternalSettings);
Procedure GetUserColumns (var UserColumns:TCombobox; Settings:PluginSettings);
Function AddContextMenu (ItemName,RunString:String):string;
function GiveFolder(caption: string;parent:hwnd): String;
Procedure Reread_need;

var
  Settings:PluginSettings;
  Usergroup:boolean=false;
  ISet:InternalSettings;
  FirstList:Boolean=true;
implementation

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

procedure MCreateFile (filename:string);
var
x:textfile;
begin
 try
 assignfile (x,filename);
 rewrite (x);
 closefile (x);
 except
 messagebox (0,pchar('Can`t create '+filename+'.'),'Error',mb_ok+mb_iconinformation);
 exit;
 end;
end;



Procedure GetSettings (Var Settings:PluginSettings);
var
Ini:Tinifile;
MaxUserColumns:integer;
t1:string;
Begin
t1:=includetrailingbackslash(extractfilepath(paramstr(0)))+'global_diz.ini';
if not fileexists (t1) then ini:=Tinifile.Create(GetSettingsFile) else ini:=TInifile.Create(t1);
Settings.GlobaldizFolder :=includetrailingbackslash(ini.ReadString('main','globaldizfolder',''));
if not DirectoryExists (Settings.GlobalDizFolder ) then Settings.GlobalDizFolder :='\';
if Settings.GlobaldizFolder='\' then Settings.GlobaldizFolder:=includetrailingbackslash(extractfilepath(paramstr(0)));
Settings.GlobalDizFileName :=Settings.GlobaldizFolder+'global.diz';
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
Settings.RefreshPanels :=ini.ReadBool('main','RefreshPanels',false);
Settings.ConfirmReplace :=ini.ReadBool('main','ConfirmReplace',false);
for MaxUserColumns:=1 to 10 do
 begin
 if ini.ReadString('UserColumns','Column'+inttostr(MaxUserColumns),'')<>'' then Settings.UserColumnsFileNames [MaxUserColumns]:=Settings.GlobaldizFolder+ini.ReadString('UserColumns','Column'+inttostr(MaxUserColumns),'');
 end;
ini.Destroy;
end;

Procedure GetGroups (var Groups:TCombobox; settings:PluginSettings);
var
diz:textfile;
s:string;
begin
Groups.Clear;
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
assignfile (diz,Settings.GlobaldizFileName);
reset (diz);
while not eof (diz) do
 begin
 readln (diz,s);
 if (length (s)<1) or (s[1]=#13) then continue;
 if (s[1]='[') and (s[length(s)]=']') then
  begin
  delete (s,1,1);
  delete (s,length(s),1);
  Groups.Items.Add (s);
  end;
 end;
closefile (diz);
end;

Procedure GetUserColumns (var UserColumns:TCombobox; Settings:PluginSettings);
var
i:byte;
Begin
UserColumns.Clear;
for i:=1 to 10 do
 begin
 if settings.UserColumnsFileNames [i]<>'' then UserColumns.Items.Add(copy (extractfilename(settings.UserColumnsFileNames [i]),1,pos('.',extractfilename(settings.UserColumnsFileNames [i]))-1)) else exit;
 end;
End;

Function IsTCListFile (filename:string):boolean;
begin
result:=false;
if (copy(lowercase(extractfilename (filename)),1,3)='cmd') and (extractfileext(filename)='.tmp') then result:=true;
end;


function GetGroupForFile (filename:shortstring;Settings:PluginSettings):string;
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
// if lowercase(s)='[none]' then s1:='';
 if lowercase(ExtractShortPathName(copy (s,1,pos ('=',s)-1)))=lowercase(ExtractShortPathName(filename)) then
  begin
  result:=copy (s1,2,length (s1)-2);
  closefile (diz);
  exit;
  end;
 end;
closefile (diz);
End;



procedure SaveDiz (group,forfile,newdiz:string;Settings:PluginSettings;Iset:InternalSettings);
var
AskChange,GroupChange:Boolean;
diz:Tinifile;
tmp:textfile;
s,t:string;
Begin
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
if group='' then
 begin
 group:=GetGroupForFile (ForFile,settings);
 if Group='' then group:='NONE';
 end;
diz:=Tinifile.Create(Settings.GlobaldizFileName);

if (iset.LIST) or IsTCListFile (forfile) then
 begin
 GroupChange:=False;
 AskChange:=True;
 assignfile (tmp,forfile);
 reset (tmp);
 while not eof (tmp) do
  begin
  readln (tmp,s);
  if s[length(s)]='\' then delete (s,length(s),1);
  t:=GetGroupForFile (s,settings);
//  if t=group then continue;
  if (t<>'') and (not GroupChange) then
   begin
   if not Settings.ConfirmReplace then GroupChange:=true;
   if (Settings.ConfirmReplace) and (AskChange) then
    begin
     AskChange:=False;
     case MessageBox (0,pchar('File '+s+' from listfile '+forfile+' already exists in '+t+' group. Do you want change group for all files to '+group+' group?'),pchar ('Change group '+t+' to '+group),MB_YESNO+MB_ICONQUESTION) of
     ID_YES: GroupChange:=TRUE;
     ID_NO:Continue;
    end;
   end;
  end;
  if (GroupChange) then diz.DeleteKey(t,s) else
   if (t<>'') and ( Settings.ConfirmReplace) then continue;
  diz.WriteString(group,s,newdiz);
  end;
 closefile (tmp);
 diz.Destroy;
 exit;
 end else
 begin
 s:=GetGroupForFile (forfile,settings);
// if s=group then exit;
 if s<>'' then
  begin
  if Settings.ConfirmReplace then
   begin
    case MessageBox (0,pchar('File '+forfile+' already exists in '+s+' group. Do you want change group to '+group+'?'),pchar ('Change group '+t+' to '+group),MB_YESNO+MB_ICONQUESTION) of
//     ID_YES:diz.DeleteKey(s,forfile);
     ID_NO:exit;
    end;
   end;
  diz.DeleteKey(s,forfile);
  diz.DeleteKey(s, extractshortpathname (forfile));//Для пущей уверенности
  end;
 diz.WriteString(group,forfile,newdiz);
 diz.Destroy;
 end;
End;

procedure DelDiz (FromFile,ForFile:string;var iset:InternalSettings);
var
diz,newdiz,tmp:textfile;
t,s:string;
temp1,temp2:string;
Begin
if not fileexists (FromFile) then MCreateFile (fromFile);

if ((iset.LIST) or IsTCListFile (forfile)) and (FirstList) then
 begin
 assignfile (tmp,forfile);
 reset (tmp);
 while not eof (tmp) do
  begin
  FirstList :=false;
  readln (tmp,s);
  if s[length(s)]='\' then delete (s,length(s),1);
  DelDiz (FromFile,s,iset);
  end;
 CloseFile (tmp);
 end else
 begin

assignfile (diz,FromFile);
assignfile (newdiz,FromFile+'~');
rewrite (newdiz);
reset (diz);
while not eof (diz) do
 begin
 readln (diz,s);
 t:=copy (s,1,pos ('=',s)-1);
 temp1:=lowercase(ExtractShortPathName (ForFile));
 temp2:=lowercase(ExtractShortPathName(t));
 if temp1=temp2 then
  begin

  end else
  begin
  writeln (newdiz,s);
  end;
 end;
closefile (diz);
closefile (newdiz);
deletefile (FromFile);
renamefile (FromFile+'~',FromFile);
 end;
end;

Procedure SaveUserDiz (DizFile,forfile,newdiz:string;Settings:PluginSettings;iset:InternalSettings);
var
ini:tinifile;
diz:textfile;
x:byte;
i:integer;
st:TstringList;
s:string;
 function UserColumnExists (ColumnFileName:string; var FreeColumn:byte):boolean;
 var
 i:byte;
 begin
 result:=false;
 for i:=1 to 10 do
  begin
  if settings.UserColumnsFileNames [i]='' then
   begin
   FreeColumn:=i;
   result:=false;
   exit;
   end;
  if settings.UserColumnsFileNames [i]=ColumnFileName then
   begin
   Result:=true;
   exit;
   end;
  end;
 end;

begin
if not fileexists (DizFile) then MCreateFile (DizFile);
DelDiz (DizFile,ForFile,iset);
if (iset.LIST) or IsTCListFile (forfile) then
 begin
 assignfile (diz,dizfile);
 append (diz);
 st :=TStringList.Create;
 st.LoadFromFile(forfile);
 for i:=0 to st.Count -1 do
  begin
  s:=st[i];
  if s[length(s)]='\' then delete (s,length(s),1);
  writeln (diz,s+'='+newdiz);
  end;
 st.Destroy;
 closefile (diz);
 exit;
 end;
assignfile (diz,dizfile);
append (diz);
writeln (diz,forfile+'='+newdiz);
closefile (diz);
if (not UserColumnExists (dizfile,x)) and (x<11) then
 begin
 ini:=tinifile.Create(getsettingsfile);
 ini.WriteString('UserColumns','Column'+inttostr(x),extractfilename(dizfile));
 ini.Destroy;
 end;
end;


procedure ClearDiz (settings:PluginSettings);
var
diz,newdiz:textfile;
s,t:string;
Begin
if not fileexists (settings.GlobalDizFileName) then MCreateFile (settings.GlobalDizFileName);
assignfile (diz,Settings.GlobaldizFileName);
assignfile (newdiz,Settings.GlobaldizFileName+'~');
rewrite (newdiz);
reset (diz);
while not eof (diz) do
 begin
 readln (diz,s);
 t:=copy (s,1,pos ('=',s)-1);
 if (not (fileexists (t) or DirectoryExists(t))) and (t<>'') then
  begin
{  writeln (diz);
  messagebox (application.Handle,pchar (t),'File dont exists',0);}
  //do nothing
  end else writeln (newdiz,s);
 end;
closefile (diz);
closefile (newdiz);
deletefile (Settings.GlobaldizFileName);
renamefile (Settings.GlobaldizFileName+'~',Settings.GlobaldizFileName);
End;


Function AddContextMenu (ItemName,RunString:String):string;
var
Key: HKEY;
begin
if RegCreateKeyEx (hKey_Classes_Root,'*\shell\ADD_DIZ\', 0,nil ,REG_OPTION_NON_VOLATILE	, KEY_ALL_ACCESS  ,nil,key,nil) = ERROR_SUCCESS then
  try
  RegSetValueEx  ( Key, '',0, REG_SZ	, @ItemName[1], length (ItemName));
  finally
   RegCloseKey( Key );
  end;
if RegCreateKeyEx (hKey_Classes_Root,'*\shell\ADD_DIZ\command\', 0,nil ,REG_OPTION_NON_VOLATILE	, KEY_ALL_ACCESS  ,nil,key,nil) = ERROR_SUCCESS then
  try
  RegSetValueEx  ( Key, '',0, REG_SZ	, @RunString[1], length (RunString));
  finally
   RegCloseKey( Key );
  end;
if RegCreateKeyEx (hKey_Classes_Root,'Folder\shell\ADD_DIZ\', 0,nil ,REG_OPTION_NON_VOLATILE	, KEY_ALL_ACCESS  ,nil,key,nil) = ERROR_SUCCESS then
  try
  RegSetValueEx  ( Key, '',0, REG_SZ	, @ItemName[1], length (ItemName));
  finally
   RegCloseKey( Key );
  end;
if RegCreateKeyEx (hKey_Classes_Root,'Folder\shell\ADD_DIZ\command\', 0,nil ,REG_OPTION_NON_VOLATILE	, KEY_ALL_ACCESS  ,nil,key,nil) = ERROR_SUCCESS then
  try
  RegSetValueEx  ( Key, '',0, REG_SZ	, @RunString[1], length (RunString));
  finally
   RegCloseKey( Key );
  end;
end;

function GiveFolder(caption: string;parent:hwnd): String;
var
  lpItemID : PItemIDList;
  BrowseInfo : TBrowseInfo;
  DisplayName : array[0..MAX_PATH] of char;
  TempPath : array[0..MAX_PATH] of char;
begin
  Result:='';
  DisplayName:='TWinAmp';
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := Parent;
  BrowseInfo.pszDisplayName := @DisplayName;
  BrowseInfo.lpszTitle := PChar(caption);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result:=TempPath;
    GlobalFreePtr(lpItemID);
  end;
end;

Procedure Reread_need;
function FindTCWindow: HWND;
 begin
  Result := FindWindow ('TTOTAL_CMD', nil);
 end;
 Procedure ReReadPanels;
 begin
  PostMessage(FindTCWindow, WM_USER+51, 540, 0);
 end;
begin
if settings.RefreshPanels then ReReadPanels;
End;

Begin

end.