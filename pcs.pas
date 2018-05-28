//Copyright 2016-2018 Johannes Kreutz.
//Alle Rechte vorbehalten.
unit PCS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, USMBShare, HTTPSend, fpjson, jsonparser, LCLType, ComCtrls,
  Grids, UGetMacAdress, UGetIPAdress, StrUtils, UClientMachine, UChangePassword,
  UResetStudentPassword, ssl_openssl, resolve, UPingThread, lclintf,
  URequestThread;

type

  { Twindow }

  Twindow = class(TForm)
    actionLabel: TLabel;
    onlineInfos: TMenuItem;
    sHelpMenu: TMenuItem;
    noNetworkHead: TLabel;
    noNetworkSub: TLabel;
    noNetworkInfo: TLabel;
    mainScroll: TScrollBox;
    reloadTimer: TTimer;
    updateTimer: TTimer;
    unlockWS: TMenuItem;
    stopWS: TMenuItem;
    unlockInet: TMenuItem;
    startWS: TMenuItem;
    updateWSList: TMenuItem;
    updateListButton: TButton;
    inetLockAll: TButton;
    D2L1: TLabel;
    D2L2: TLabel;
    D2L3: TLabel;
    D3L1: TLabel;
    D3L2: TLabel;
    D3L3: TLabel;
    D1logout: TButton;
    D2logout: TButton;
    D3logout: TButton;
    D1open: TButton;
    D2open: TButton;
    D3open: TButton;
    drive2Box: TGroupBox;
    drive3Box: TGroupBox;
    fadingArrow: TImage;
    drive1Box: TGroupBox;
    D1L1: TLabel;
    D1L2: TLabel;
    D1L3: TLabel;
    D1STAT: TLabel;
    D1USER: TLabel;
    D1PATH: TLabel;
    D2STAT: TLabel;
    D2USER: TLabel;
    D2PATH: TLabel;
    D3STAT: TLabel;
    D3USER: TLabel;
    D3PATH: TLabel;
    machineLockAll: TButton;
    machineWOLAll: TButton;
    machineLockBox: TGroupBox;
    machineControlBox: TGroupBox;
    inetUnlockAll: TButton;
    inetLockBox: TGroupBox;
    machineUnlockAll: TButton;
    machineShutdownAll: TButton;
    MainPageCtrl: TPageControl;
    sAccountMenu: TMenuItem;
    resetAccount: TMenuItem;
    driveSheet: TTabSheet;
    allMachines: TTabSheet;
    machineGrid: TStringGrid;
    lookTimer: TTimer;
    vncSheet: TTabSheet;
    workstationMenu: TMenuItem;
    lockInet: TMenuItem;
    lockWS: TMenuItem;
    usersBox: TGroupBox;
    newsBox: TGroupBox;
    loginBox: TGroupBox;
    infoLabel: TLabel;
    infoLabel2: TLabel;
    mainMenu: TMainMenu;
    driveMenu: TMenuItem;
    accountMenu: TMenuItem;
    openDrive1: TMenuItem;
    changePassword: TMenuItem;
    openDrive2: TMenuItem;
    openDrive3: TMenuItem;
    news: TMemo;
    search: TEdit;
    arrowTimer: TTimer;
    usernames: TListBox;
    versionLabel: TLabel;
    loginButton: TButton;
    clearButton: TButton;
    passwd: TEdit;
    uname: TEdit;
    headline: TLabel;
    logo: TImage;
    procedure arrowTimerTimer(Sender: TObject);
    procedure changePasswordClick(Sender: TObject);
    procedure lockInetClick(Sender: TObject);
    procedure lockWSClick(Sender: TObject);
    procedure onlineInfosClick(Sender: TObject);
    procedure reloadTimerTimer(Sender: TObject);
    procedure stopWSClick(Sender: TObject);
    procedure unlockInetClick(Sender: TObject);
    procedure startWSClick(Sender: TObject);
    procedure resetAccountClick(Sender: TObject);
    procedure unlockWSClick(Sender: TObject);
    procedure updateListButtonClick(Sender: TObject);
    procedure clearButtonClick(Sender: TObject);
    procedure D1logoutClick(Sender: TObject);
    procedure D1openClick(Sender: TObject);
    procedure D2logoutClick(Sender: TObject);
    procedure D2openClick(Sender: TObject);
    procedure D3logoutClick(Sender: TObject);
    procedure D3openClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure inetLockAllClick(Sender: TObject);
    procedure inetUnlockAllClick(Sender: TObject);
    procedure loginButtonClick(Sender: TObject);
    procedure lookTimerTimer(Sender: TObject);
    procedure machineGridButtonClick(Sender: TObject; aCol, aRow: Integer);
    procedure machineLockAllClick(Sender: TObject);
    procedure machineShutdownAllClick(Sender: TObject);
    procedure machineUnlockAllClick(Sender: TObject);
    procedure machineWOLAllClick(Sender: TObject);
    procedure searchChange(Sender: TObject);
    procedure loadUsers;
    procedure updateTimerTimer(Sender: TObject);
    procedure updateWSListClick(Sender: TObject);
    procedure usernamesSelectionChange(Sender: TObject; User: boolean);
  private
    arrowDirection: boolean;
    timerCounter: integer;
    //Netzwerkverbindung prüfen
    procedure checkNetworkConnection;
    procedure networkConnectionResult(result: boolean; return: string);
    procedure trueNetworkResult;
    procedure falseNetworkResult;
    //Konfigurationsdatei / Serverkonfiguration laden
    procedure parseConfigFile;
    procedure loadConfig;
    procedure loadConfigResponse(response: string);
    //Nutzerliste laden
    procedure loadUsersResponse(response: string);
    //Oberfläche sperren / entsperren
    procedure lockUI(mode: boolean);
    //Inputs sperren / entsperren
    procedure lockInputs(mode: boolean);
    //Login ausführen nach Klick auf Button
    procedure doLogin;
    procedure handleOne(status: string);
    procedure handleTwo(status: string);
    procedure handleThree(status: string);
    procedure controlShareUI(share: integer; state: boolean);
    procedure handleConnectResult(share, connect: integer);
    procedure doLogout(share: integer);
    procedure doFileLogin;
    //Hinweis-Textbox laden
    procedure loadTextBox(infotext: string);
    procedure mountGroupFolders(username, pw: string);
    procedure handleGroup(status: string);
    procedure loadClientMachines;
    procedure updateMachineStatus;
    procedure updateMachineGrid(status: string);
    //Legt fest, ob der Rechner ohne Serverzugriff verwendet werden darf
    procedure setAllowOffline(value: string);
    procedure setHelpURL(url: string);
    function sendRequest(url, params: string): string;
    function MemStreamToString(Strm: TMemoryStream): AnsiString;
    function ValidateIP(IP4: string): Boolean;
  public
    { public declarations }
  end;

var
  window: Twindow;
  d1user, d2user, d3user, serverURL, SMBserverURL, globalPW, login,
  loginPending, loginFailed, wrongCredentials, networkFailed, mac,
  gfdata, ip, cleanServerURL, helpURL: string;
  userdata, fullUserdata, searchUserdata: TStrings;
  shares: array[0..2] of TSMBShare;
  groupfolders: array of TSMBShare;
  drives: array[0..2] of string;
  drivePaths: array[0..2] of string;
  gfcount, networkRetry, actualNetworkRetry: integer;
  groupFoldersMounted, showedGroupfolderWarning, allowOffline, isOnline: boolean;
  clientMachines: array of TClientMachine;
  pingthread: TPingThread;
  loadUsersThread, loadConfigThread: TRequestThread;

implementation

{$R *.lfm}

{ Twindow }


procedure Twindow.FormCreate(Sender: TObject);
var
   version, build: string;
begin
   version:='1.6.2';
   build:='1G194';
   groupFoldersMounted:=false;
   showedGroupfolderWarning:=false;
   allowOffline:=false;
   gfcount:=0;
   actualNetworkRetry:=1;
   networkRetry:=30;
   isOnline:=false;
   {$IFDEF WIN32}
   versionLabel.Caption:='PhilleConnect Win32 v'+version+' Build '+build+' by Johannes Kreutz';
   {$ENDIF}
   {$IFDEF WIN64}
   versionLabel.Caption:='PhilleConnect Win64 v'+version+' Build '+build+' by Johannes Kreutz';
   {$ENDIF}
   {$IFDEF LINUX}
   versionLabel.Caption:='PhilleConnect Linux v'+version+' Build '+build+' by Johannes Kreutz';
   infoLabel.left:=infoLabel.left-8;
   usernames.height:=usernames.height-8;
   usernames.top:=usernames.top+8;
   {$ENDIF}
   {$IFDEF DARWIN}
   versionLabel.Caption:='PhilleConnect macOS v'+version+' Build '+build+' by Johannes Kreutz';
   infoLabel.left:=infoLabel.left-2;
   {$ENDIF}
   {$IFNDEF WINDOWS}
   d1stat.left:=160;
   d1user.left:=160;
   d1path.left:=160;
   d2stat.left:=160;
   d2user.left:=160;
   d2path.left:=160;
   d3stat.left:=160;
   d3user.left:=160;
   d3path.left:=160;
   {$ENDIF}
   arrowDirection:=true;
   timerCounter:=0;
   parseConfigFile;
end;

procedure Twindow.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (key = 13) then begin
    if (window.activeControl = search) then begin
      if (searchUserdata.count = 1) then begin
        uname.text:=searchUserdata[0];
        passwd.setFocus;
      end;
    end
    else begin
      loginButtonClick(loginButton);
    end;
  end;
end;

procedure Twindow.FormResize(Sender: TObject);
var
  c: integer;
begin
  machineGrid.defaultColWidth:=(machineGrid.Width div 7);
  c:=0;
  while (c < length(clientMachines)) do begin
    clientMachines[c].reposition;
    c:=c+1;
  end;
end;

procedure Twindow.inetLockAllClick(Sender: TObject);
begin
  sendRequest('https://'+serverURL+'/client.php', 'usage=internet&globalpw='+globalPW+'&machine='+mac+'&ip='+ip+'&task=room&lock=0');
  updateMachineStatus;
end;

procedure Twindow.inetUnlockAllClick(Sender: TObject);
begin
  sendRequest('https://'+serverURL+'/client.php', 'usage=internet&globalpw='+globalPW+'&machine='+mac+'&ip='+ip+'&task=room&lock=1');
  updateMachineStatus;
end;

procedure Twindow.loginButtonClick(Sender: TObject);
begin
  doLogin;
end;

procedure Twindow.lookTimerTimer(Sender: TObject);
begin
  loadClientMachines;
  lookTimer.enabled:=false;
  updateTimer.enabled:=true;
end;

procedure Twindow.machineGridButtonClick(Sender: TObject; aCol, aRow: Integer);
var
  response: integer;
begin
  if (aCol = 4) then begin
    if (machineGrid.rows[aRow][2] = 'Freigegeben') then begin
      clientMachines[(aRow-1)].lockInet(true);
    end
    else begin
      clientMachines[(aRow-1)].lockInet(false);
    end;
  end
  else if (aCol = 5) then begin
    if (machineGrid.rows[aRow][3] = 'Freigegeben') then begin
      clientMachines[(aRow-1)].lock(true);
    end
    else begin
      clientMachines[(aRow-1)].lock(false);
    end;
  end
  else if (aCol = 6) then begin
    if (machineGrid.rows[aRow][1] = 'Erreichbar') then begin
      response:=MessageBox(window.handle, 'Ausgewählten Schülerrechner herunterfahren. Sind sie sicher?', 'Schülerrechner herunterfahren', MB_YESNO);
      if (response = ID_YES) then begin
        clientMachines[(aRow-1)].shutdown;
      end;
    end
    else begin
      response:=MessageBox(window.handle, 'Ausgewählten Schülerrechner starten. Sind sie sicher?', 'Schülerrechner starten', MB_YESNO);
      if (response = ID_YES) then begin
        clientMachines[(aRow-1)].wake;
      end;
    end;
  end;
  updateMachineStatus;
end;

procedure Twindow.machineLockAllClick(Sender: TObject);
var
  c: integer;
begin
  c:=0;
  while (c < length(clientMachines)) do begin
    clientMachines[c].lock(true);
    c:=c+1;
  end;
  updateMachineStatus;
end;

procedure Twindow.machineShutdownAllClick(Sender: TObject);
var
  c, response: integer;
begin
  response:=MessageBox(window.handle, 'Alle Schülerrechner in diesem Raum herunterfahren. Sind sie sicher?', 'Schülerrechner herunterfahren', MB_YESNO);
  if (response = ID_YES) then begin
    c:=0;
    while (c < length(clientMachines)) do begin
      clientMachines[c].shutdown;
      c:=c+1;
    end;
  end;
end;

procedure Twindow.machineUnlockAllClick(Sender: TObject);
var
  c: integer;
begin
  c:=0;
  while (c < length(clientMachines)) do begin
    clientMachines[c].lock(false);
    c:=c+1;
  end;
  updateMachineStatus;
end;

procedure Twindow.machineWOLAllClick(Sender: TObject);
var
  c, response: integer;
begin
  response:=MessageBox(window.handle, 'Alle Schülerrechner in diesem Raum starten. Sind sie sicher?', 'Schülerrechner starten', MB_YESNO);
  if (response = ID_YES) then begin
    c:=0;
    while (c < length(clientMachines)) do begin
      clientMachines[c].wake;
      c:=c+1;
    end;
  end;
  showMessage('Achtung: Nach dem Starten dauert es einen Moment, bis die Rechner erreichbar sind. Nutzen Sie den Aktialisieren-Button, um nach Rechnern zu suchen.');
end;

procedure Twindow.clearButtonClick(Sender: TObject);
begin
  uname.text:='';
  passwd.text:='';
end;

procedure Twindow.D1logoutClick(Sender: TObject);
begin
  doLogout(0);
end;

procedure Twindow.D1openClick(Sender: TObject);
begin
  shares[0].open;
end;

procedure Twindow.D2logoutClick(Sender: TObject);
begin
  doLogout(1);
end;

procedure Twindow.D2openClick(Sender: TObject);
begin
  shares[1].open;
end;

procedure Twindow.D3logoutClick(Sender: TObject);
begin
  doLogout(2);
end;

procedure Twindow.D3openClick(Sender: TObject);
begin
  shares[2].open;
end;

procedure Twindow.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  c: integer;
begin
  if (drive1Box.enabled = false) and (drive2Box.enabled = false) and (drive3Box.enabled = false) and not(groupFoldersMounted) then begin
    CanClose:=true;
  end
  else begin
    if (messageBox(window.handle, 'Es sind noch (Gruppen)Laufwerke verbunden. Möchtest du sie trennen?', 'PhilleConnect schließen', MB_YESNO) = ID_YES) then begin
      if (drive3Box.enabled = true) then begin
        doLogout(2);
      end;
      if (drive2Box.enabled = true) then begin
        doLogout(1);
      end;
      if (drive1Box.enabled = true) then begin
        doLogout(0);
      end;
      if (groupFoldersMounted) then begin
        c:=0;
        while (c < length(groupfolders)) do begin
          groupfolders[c].disconnect;
          groupfolders[c].free;
          c:=c+1;
        end;
      end;
      CanClose:=true;
    end
    else begin
      CanClose:=false;
    end;
  end;
end;

procedure Twindow.arrowTimerTimer(Sender: TObject);
begin
  if (arrowDirection = false) then begin
    fadingArrow.left:=fadingArrow.left-1;
  end
  else begin
    fadingArrow.left:=fadingArrow.left+1;
  end;
  if (timerCounter < 10) then begin
    arrowTimer.interval:=arrowTimer.interval-6;
  end
  else if (timerCounter >= 20) and (timerCounter < 30) then begin
    arrowTimer.interval:=arrowTimer.interval+6;
  end
  else if (timerCounter = 30) then begin
    arrowDirection:=not(arrowDirection);
    arrowTimer.interval:=arrowTimer.interval-6;
  end
  else if (timerCounter >= 30) and (timerCounter <= 40) then begin
    arrowTimer.interval:=arrowTimer.interval-6;
  end
  else if (timerCounter >= 50) and (timerCounter < 60) then begin
    arrowTimer.interval:=arrowTimer.interval+6;
  end
  else if (timerCounter = 60) then begin
    arrowDirection:=not(arrowDirection);
    timerCounter:=0;
  end;
  timerCounter:=timerCounter+1;
end;

procedure Twindow.changePasswordClick(Sender: TObject);
begin
  CPForm.showModal;
end;

procedure Twindow.lockInetClick(Sender: TObject);
begin
  inetLockAllClick(lockInet);
end;

procedure Twindow.lockWSClick(Sender: TObject);
begin
  machineLockAllClick(lockWS);
end;

procedure Twindow.onlineInfosClick(Sender: TObject);
begin
  openUrl(helpURL);
end;

procedure Twindow.reloadTimerTimer(Sender: TObject);
begin
  checkNetworkConnection;
end;

procedure Twindow.stopWSClick(Sender: TObject);
begin
  machineShutdownAllClick(stopWS);
end;

procedure Twindow.unlockInetClick(Sender: TObject);
begin
  inetUnlockAllClick(unlockInet);
end;

procedure Twindow.startWSClick(Sender: TObject);
begin
  machineWOLAllClick(startWS);
end;

procedure Twindow.resetAccountClick(Sender: TObject);
begin
  RSPForm.showModal;
end;

procedure Twindow.unlockWSClick(Sender: TObject);
begin
  machineUnlockAllClick(unlockWS);
end;

procedure Twindow.updateListButtonClick(Sender: TObject);
begin
  updateMachineStatus;
end;

procedure Twindow.loadUsers;
begin
  loadUsersThread:=TRequestThread.create('https://'+serverURL+'/client.php', 'usage=userlist&globalpw='+globalPW+'&machine='+mac+'&ip='+ip);
  loadUsersThread.OnShowStatus:=@loadUsersResponse;
  loadUsersThread.resume;
end;

procedure Twindow.loadUsersResponse(response: string);
var
  c: integer;
  jData: TJSONData;
begin
  if (response = '') then begin
     if (allowOffline) then begin
       halt;
     end
     else begin
       showMessage('Netzwerkfehler. Programm wird beendet.');
       halt;
     end;
   end
   else if (response = '!') then begin
     showMessage('Konfigurationsfehler. Programm wird beendet.');
     halt;
   end
   else begin
     userdata:=TStringList.create;
     fullUserdata:=TStringList.create;
     searchUserdata:=TStringList.create;
     jData:=GetJSON(response);
     c:=0;
     while (c < jData.count) do begin
       userdata.add(jData.FindPath(IntToStr(c)+'[2]').AsString);
       searchUserdata.add(jData.FindPath(IntToStr(c)+'[2]').AsString);
       fullUserdata.add(jData.FindPath(IntToStr(c)+'[0]').AsString+' '+jData.FindPath(IntToStr(c)+'[1]').AsString+' ('+jData.FindPath(IntToStr(c)+'[2]').AsString+')');
       usernames.items.add(jData.FindPath(IntToStr(c)+'[0]').AsString+' '+jData.FindPath(IntToStr(c)+'[1]').AsString+' ('+jData.FindPath(IntToStr(c)+'[2]').AsString+')');
       c:=c+1;
     end;
   end;
end;

procedure Twindow.updateTimerTimer(Sender: TObject);
begin
  updateMachineStatus;
end;

procedure Twindow.updateWSListClick(Sender: TObject);
begin
  updateMachineStatus;
end;

procedure Twindow.usernamesSelectionChange(Sender: TObject; User: boolean);
var
   counter: integer;
begin
   counter:=0;
   while (counter < searchUserdata.count) do begin
      if counter = (usernames.ItemIndex) then begin
         uname.Text:=searchUserdata[counter];
         break;
      end;
      counter:=counter+1;
   end;
   passwd.setFocus;
end;

procedure Twindow.searchChange(Sender: TObject);
var
   counter: NativeInt;
   rpl: string;
begin
   usernames.items.clear();
   searchUserdata.clear();
   counter:=0;
   while (counter < userdata.count) do begin
      rpl:=StringReplace(LowerCase(fullUserdata[counter]), LowerCase(search.text), '', [rfReplaceAll]);
      if not(LowerCase(fullUserdata[counter]) = rpl) or (search.Text = '') then begin
         usernames.items.add(fullUserdata[counter]);
         searchUserdata.add(userdata[counter]);
      end;
      counter:=counter+1;
   end;
end;

procedure Twindow.checkNetworkConnection;
var
  noPort: TStringList;
  cache: string;
begin
  if (pos(':', serverURL) > 0) then begin
    noPort:=TStringList.create;
    noPort.delimiter:=':';
    noPort.strictDelimiter:=true;
    noPort.delimitedText:=serverURL;
    cache:=noPort[0];
  end
  else begin
    cache:=serverURL;
  end;
  cleanServerURL:=cache;
  pingthread:=TPingThread.create(cache);
  pingthread.OnShowStatus:=@networkConnectionResult;
  pingthread.resume;
end;

procedure Twindow.networkConnectionResult(result: boolean; return: string);
var
  host: THostResolver;
begin
  if (result) then begin
    if (ValidateIP(cleanServerURL)) then begin
      if (cleanServerURL = return) then begin
        trueNetworkResult;
      end
      else begin
        noNetworkInfo.caption:='PING-Ergebnis: Wrong reply. Versuch: '+IntToStr(actualNetworkRetry);
        falseNetworkResult;
      end;
    end
    else begin
      host:=THostResolver.create(nil);
      host.clearData();
      if (host.NameLookup(cleanServerURL)) then begin
        if (host.AddressAsString = return) then begin
          trueNetworkResult;
        end
        else begin
          noNetworkInfo.caption:='PING-Ergebnis: Wrong reply. Versuch: '+IntToStr(actualNetworkRetry);
          falseNetworkResult;
        end;
      end
      else begin
        noNetworkInfo.caption:='PING-Ergebnis: DNS failed. Versuch: '+IntToStr(actualNetworkRetry);
        falseNetworkResult;
      end;
    end;
  end
  else begin
    noNetworkInfo.caption:='PING-Ergebnis: Host is down. Versuch: '+IntToStr(actualNetworkRetry);
    falseNetworkResult;
  end;
end;

procedure Twindow.trueNetworkResult;
begin
  reloadTimer.enabled:=false;
  lockUI(false);
  if not(isOnline) then begin
    loadConfig;
  end;
  isOnline:=true;
end;

procedure Twindow.falseNetworkResult;
begin
  reloadTimer.enabled:=true;
  lockUI(true);
  if (actualNetworkRetry >= networkRetry) then begin
    reloadTimer.enabled:=false;
    showMessage('Es konnte keine Netzwerkverbindung aufgebaut werden. Programm wird beendet.');
    halt;
  end;
  actualNetworkRetry:=actualNetworkRetry+1;
end;

procedure Twindow.parseConfigFile;
var
  config: TStringList;
  c: integer;
  value: TStringList;
  response, os: string;
  jData: TJSONData;
begin
  config:=TStringList.create;
  {$IFDEF WINDOWS}
    config.loadFromFile('C:\Program Files\PhilleConnect\pcconfig.jkm');
  {$ENDIF}
  {$IFDEF LINUX}
    config.loadFromFile('/etc/pcconfig.jkm');
  {$ENDIF}
  c:=0;
  while (c < config.count) do begin
    if (pos('#', config[c]) = 0) then begin
      value:=TStringList.create;
      value.clear;
      value.strictDelimiter:=true;
      value.delimiter:='=';
      value.delimitedText:=config[c];
      case value[0] of
        'server':
          serverURL:=value[1];
        'global':
          globalPW:=value[1];
        'allowOffline':
          setAllowOffline(value[1]);
        'badNetworkReconnect':
          networkRetry:=StrToInt(value[1]);
      end;
    end;
    c:=c+1;
  end;
  {$IFDEF WINDOWS}
    checkNetworkConnection;
  {$ENDIF}
  {$IFDEF LINUX}
    trueNetworkResult;
  {$ENDIF}
end;

procedure Twindow.loadConfig;
var
  os: string;
  MacAddr: TGetMacAdress;
  IPAddr: TGetIPAdress;
begin
  MacAddr:=TGetMacAdress.create;
  mac:=MacAddr.getMac;
  MacAddr.free;
  IPAddr:=TGetIPAdress.create;
  ip:=IPAddr.getIP;
  IPAddr.free;
  {$IFDEF WINDOWS}
    os:='win';
  {$ENDIF}
  {$IFDEF LINUX}
    os:='linux';
  {$ENDIF}
  loadConfigThread:=TRequestThread.create('https://'+serverURL+'/client.php', 'usage=config&globalpw='+globalPW+'&machine='+mac+'&ip='+ip+'&os='+os);
  loadConfigThread.OnShowStatus:=@loadConfigResponse;
  loadConfigThread.resume;
end;

procedure Twindow.loadConfigResponse(response: string);
var
  jData: TJSONData;
  c: integer;
begin
  if (response = '!') then begin
    showMessage('Konfigurationsfehler. Programm wird beendet.');
    halt;
  end
  else if (response = 'nomachine') then begin
    showMessage('Rechner nicht registriert. Programm wird beendet.');
    halt;
  end
  else if (response = 'noconfig') then begin
    showMessage('Rechner nicht fertig eingerichtet. Programm wird beendet.');
    halt;
  end
  else if (response <> '') then begin
    lockInputs(false);
    reloadTimer.enabled:=false;
    jData:=GetJSON(response);
    c:=0;
    while (c < jData.count) do begin
      case jData.FindPath(IntToStr(c)+'[0]').AsString of
        'smbserver':
          SMBServerURL:=Trim(jData.FindPath(IntToStr(c)+'[1]').AsString);
        'driveone':
          drives[0]:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'drivetwo':
          drives[1]:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'drivethree':
          drives[2]:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'pathone':
          drivePaths[0]:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'pathtwo':
          drivePaths[1]:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'paththree':
          drivePaths[2]:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'dologin':
          login:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'loginpending':
          loginPending:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'loginfailed':
          loginFailed:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'wrongcredentials':
          wrongCredentials:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'networkfailed':
          networkFailed:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'groupfolders':
          gfdata:=jData.FindPath(IntToStr(c)+'[1]').AsString;
        'infotext':
          loadTextBox(jData.FindPath(IntToStr(c)+'[1]').AsString);
        'helpurl':
          setHelpURL(jData.FindPath(IntToStr(c)+'[1]').AsString);
      end;
      c:=c+1;
    end;
    loadUsers;
    doFileLogin;
    lookTimer.enabled:=true;
  end
  else begin
    lockInputs(false);
    showMessage('Netzwerkfehler. Programm wird beendet.');
    halt;
  end;
end;

procedure Twindow.lockInputs(mode: boolean);
begin
  if (mode) then begin
    actionLabel.caption:='Netzwerkverbindung wird aufgebaut...';
    uname.enabled:=false;
    passwd.enabled:=false;
    clearButton.enabled:=false;
    loginButton.enabled:=false;
    search.enabled:=false;
    usernames.enabled:=false;
  end
  else begin
    actionLabel.caption:='Bitte melde dich mit deinen Zugangsdaten an.';
    uname.enabled:=true;
    passwd.enabled:=true;
    clearButton.enabled:=true;
    loginButton.enabled:=true;
    search.enabled:=true;
    usernames.enabled:=true;
    if (window.visible) then begin
      search.setFocus;
    end;
  end;
end;

procedure Twindow.lockUI(mode: boolean);
begin
  if (mode) then begin
    window.color:=clBlack;
    mainPageCtrl.visible:=false;
    versionLabel.visible:=false;
    infoLabel.visible:=false;
    infoLabel2.visible:=false;
    headline.font.color:=clWhite;
    noNetworkInfo.visible:=true;
    noNetworkHead.visible:=true;
    noNetworkSub.visible:=true;
    noNetworkHead.left:=(window.width div 2)-(noNetworkHead.width div 2);
    noNetworkHead.top:=(window.height div 2)-(noNetworkHead.height div 2)-30;
    noNetworkSub.left:=(window.width div 2)-(noNetworkSub.width div 2);
    noNetworkSub.top:=(window.height div 2)-(noNetworkSub.height div 2)+20;
  end
  else begin
    window.color:=clDefault;
    mainPageCtrl.visible:=true;
    versionLabel.visible:=true;
    infoLabel.visible:=true;
    infoLabel2.visible:=true;
    headline.font.color:=clDefault;
    noNetworkInfo.visible:=false;
    noNetworkHead.visible:=false;
    noNetworkSub.visible:=false;
    if (window.visible) then begin
      search.setFocus;
    end;
  end;
end;

procedure Twindow.doLogin;
begin
  if (uname.text = '') then begin
    showMessage('Bitte gib einen Nutzernamen ein.');
  end
  else if (passwd.text = '') then begin
    showMessage('Bitte gib ein Passwort ein.');
  end
  else begin
    actionLabel.caption:=loginPending;
    uname.readonly:=true;
    passwd.readonly:=true;
    loginButton.enabled:=false;
    clearButton.enabled:=false;
    if (drive1Box.enabled = false) then begin
      if (groupFoldersMounted = false) then begin
        mountGroupFolders(uname.text, passwd.text);
      end;
      {$IFDEF WINDOWS}
      shares[0]:=TSMBShare.create(uname.text, passwd.text, drives[0], 'driveone.this', uname.text);
      {$ENDIF}
      {$IFDEF LINUX}
      shares[0]:=TSMBShare.create(uname.text, passwd.text, drives[0]+uname.text, SMBServerURL, uname.text);
      {$ENDIF}
      actionLabel.caption:=loginPending;
      shares[0].connect;
      shares[0].onShowStatus:=@handleOne;
      passwd.text:='';
    end
    else if (drive2Box.enabled = false) then begin
      {$IFDEF WINDOWS}
      shares[1]:=TSMBShare.create(uname.text, passwd.text, drives[1], 'drivetwo.this', uname.text);
      {$ENDIF}
      {$IFDEF LINUX}
      shares[1]:=TSMBShare.create(uname.text, passwd.text, drives[1]+uname.text, SMBServerURL, uname.text);
      {$ENDIF}
      actionLabel.caption:=loginPending;
      shares[1].connect;
      shares[1].onShowStatus:=@handleTwo;
      passwd.text:='';
    end
    else if (drive3Box.enabled = false) then begin
      {$IFDEF WINDOWS}
      shares[2]:=TSMBShare.create(uname.text, passwd.text, drives[2], 'drivethree.this', uname.text);
      {$ENDIF}
      {$IFDEF LINUX}
      shares[2]:=TSMBShare.create(uname.text, passwd.text, drives[2]+uname.text, SMBServerURL, uname.text);
      {$ENDIF}
      actionLabel.caption:=loginPending;
      shares[2].connect;
      shares[2].onShowStatus:=@handleThree;
      passwd.text:='';
      loginButton.enabled:=false;
      fadingArrow.visible:=false;
    end
    else begin
      uname.readonly:=false;
      passwd.readonly:=false;
      loginButton.enabled:=true;
      clearButton.enabled:=true;
      passwd.text:='';
    end;
  end;
end;

procedure Twindow.handleOne(status: string);
begin
  handleConnectResult(0, StrToInt(status));
end;

procedure Twindow.handleTwo(status: string);
begin
  handleConnectResult(1, StrToInt(status));
end;

procedure Twindow.handleThree(status: string);
begin
  handleConnectResult(2, StrToInt(status));
end;

procedure Twindow.controlShareUI(share: integer; state: boolean);
begin
  if (state = true) then begin
    if (share = 0) then begin
      drive1Box.enabled:=true;
      openDrive1.enabled:=true;
      fadingArrow.visible:=false;
      arrowTimer.enabled:=false;
    end
    else if (share = 1) then begin
      drive2Box.enabled:=true;
      openDrive2.enabled:=true;
    end
    else if (share = 2) then begin
      drive3Box.enabled:=true;
      openDrive3.enabled:=true;
    end;
  end
  else begin
    if (share = 0) then begin
      drive1Box.enabled:=false;
      openDrive1.enabled:=false;
    end
    else if (share = 1) then begin
      drive2Box.enabled:=false;
      openDrive2.enabled:=false;
    end
    else if (share = 2) then begin
      drive3Box.enabled:=false;
      openDrive3.enabled:=false;
    end;
  end;
end;

procedure Twindow.handleConnectResult(share, connect: integer);
begin
  if (connect = 0) then begin
    actionLabel.font.color:=clBlack;
    actionLabel.caption:='Erfolgreich angemeldet.';
    controlShareUI(share, true);
    if (share = 0) then begin
      d1stat.caption:='Verbunden';
      d1user.caption:=uname.text;
      {$IFDEF WINDOWS}
        d1path.caption:=drivePaths[share];
      {$ENDIF}
      {$IFDEF LINUX}
        d1path.caption:=drivePaths[share]+uname.text;
      {$ENDIF}
    end
    else if (share = 1) then begin
      d2stat.caption:='Verbunden';
      d2user.caption:=uname.text;
      {$IFDEF WINDOWS}
        d2path.caption:=drivePaths[share];
      {$ENDIF}
      {$IFDEF LINUX}
        d2path.caption:=drivePaths[share]+uname.text;
      {$ENDIF}
    end
    else if (share = 2) then begin
      d3stat.caption:='Verbunden';
      d3user.caption:=uname.text;
      {$IFDEF WINDOWS}
        d3path.caption:=drivePaths[share];
      {$ENDIF}
      {$IFDEF LINUX}
        d3path.caption:=drivePaths[share]+uname.text;
      {$ENDIF}
    end;
    uname.readonly:=false;
    passwd.readonly:=false;
    loginButton.enabled:=true;
    clearButton.enabled:=true;
    uname.text:='';
    passwd.text:='';
  end
  else begin
    shares[share].free;
    uname.readonly:=false;
    passwd.readonly:=false;
    loginButton.enabled:=true;
    clearButton.enabled:=true;
    passwd.text:='';
    if (connect = 1) then begin
      showMessage(wrongCredentials);
    end
    else if (connect = 2) then begin
      showMessage(loginFailed);
    end
    else if (connect = 3) then begin
      showMessage(networkFailed);
    end
    else if (connect = 4) then begin
      showMessage('Es ist ein Systemfehler aufgetreten.');
    end;
    actionLabel.caption:=login;
  end;
end;

procedure Twindow.doLogout(share: integer);
var
  c: integer;
begin
  if (share = 0) then begin
    if (drive2Box.enabled) or (drive3Box.enabled) then begin
      showMessage('Die Gruppen-/Tauschlaufwerke sind mit dem ersten angemeldeten Nutzer verbunden. Um die Laufwerke weiterhin zu nutzen, musst du dich erneut als erster Nutzer (Laufwerk 1) anmelden.');
    end;
    shares[0].disconnect;
    d1stat.caption:='Nicht verbunden';
    d1user.caption:='';
    d1path.caption:='';
    drive1Box.enabled:=false;
    if (groupFoldersMounted) then begin
      c:=0;
      while (c < length(groupfolders)) do begin
        groupfolders[c].disconnect;
        groupfolders[c].free;
        c:=c+1;
      end;
      groupFoldersMounted:=false;
    end;
  end
  else if (share = 1) then begin
    shares[1].disconnect;
    d2stat.caption:='Nicht verbunden';
    d2user.caption:='';
    d2path.caption:='';
    drive2Box.enabled:=false;
  end
  else if (share = 2) then begin
    shares[2].disconnect;
    d3stat.caption:='Nicht verbunden';
    d3user.caption:='';
    d3path.caption:='';
    drive3Box.enabled:=false;
  end;
  if (drive1Box.enabled = false) and (drive2Box.enabled = false) and (drive3Box.enabled = false) then begin
    actionLabel.font.color:=clRed;
    actionLabel.caption:=login;
    fadingArrow.visible:=true;
    arrowTimer.enabled:=true;
  end;
end;

procedure Twindow.doFileLogin;
var
  loginFile: TStringList;
  loginFilePath: string;
begin
  {$IFDEF WINDOWS}
    loginFilePath:=getUserDir+'login.jkm';
  {$ENDIF}
  {$IFDEF LINUX}
    loginFilePath:='/tmp/login.jkm';
  {$ENDIF}
  if (fileExists(loginFilePath)) then begin
    loginFile:=TStringList.create;
    loginFile.loadFromFile(loginFilePath);
    if not(loginFile[0] = '') then begin
      uname.text:=XORDecode(mac, loginFile[0]);
      passwd.text:=XORDecode(mac, loginFile[1]);
      doLogin;
      mountGroupFolders(XORDecode(mac, loginFile[0]), XORDecode(mac, loginFile[1]));
      loginFile[0]:='';
      loginFile[1]:='';
      loginFile.saveToFile(loginFilePath);
    end;
  end;
end;

procedure Twindow.loadTextBox(infotext: string);
var
  content: TStringList;
begin
  content:=TStringList.create;
  content.delimiter:='%';
  content.strictDelimiter:=true;
  content.delimitedText:=infotext;
  news.lines:=content;
end;

procedure Twindow.mountGroupFolders(username, pw: string);
var
  jData: TJSONData;
  c: integer;
  longpath: TStringList;
begin
  if not(gfdata = '') then begin
    jData:=GetJSON(StringReplace(gfdata, '\', '', [rfReplaceAll]));
    c:=0;
    while (c < jData.count) do begin
      setLength(groupfolders, (c+1));
      {$IFDEF WINDOWS}
      groupfolders[c]:=TSMBShare.create(username, pw, jData.FindPath(IntToStr(c)+'[0]').AsString, 'groupfolders.this', StringReplace(jData.FindPath(IntToStr(c)+'[1]').AsString, '/', '\', [rfReplaceAll]));
      {$ENDIF}
      {$IFDEF LINUX}
      longpath:=TStringList.create;
      longpath.delimiter:='/';
      longpath.delimitedText:=jData.FindPath(IntToStr(c)+'[1]').AsString;
      groupfolders[c]:=TSMBShare.create(username, pw, jData.FindPath(IntToStr(c)+'[0]').AsString+longpath[(longpath.count-1)], SMBServerURL, jData.FindPath(IntToStr(c)+'[1]').AsString);
      {$ENDIF}
      groupfolders[c].connect;
      groupfolders[c].onShowStatus:=@handleGroup;
      c:=c+1;
    end;
  end;
end;

procedure Twindow.handleGroup(status: string);
begin
  if (StrToInt(status) <> 0) and (StrToInt(status) <> 2) then begin
    if not(showedGroupfolderWarning) then begin
      showedGroupfolderWarning:=true;
      showMessage('Fehler beim Einbinden der Gruppen-/Tauschlaufwerke.');
    end;
  end
  else begin
    gfcount:=gfcount+1;
    groupFoldersMounted:=true;
  end;
end;

procedure Twindow.loadClientMachines;
var
  jData: TJSONData;
  c: integer;
  response, clientRoom, clientName, clientIp, clientMac, temp,
  clientInet: string;
  cache: TStringList;
begin
  window.update;
  response:=sendRequest('https://'+serverURL+'/client.php', 'usage=roomlist&globalpw='+globalPW+'&machine='+mac+'&ip='+ip);
  if not(response = '') and not(response = 'restricted') then begin
    jData:=GetJSON(response);
    c:=0;
    while (c < jData.count) do begin
      clientInet:=jData.findPath(IntToStr(c)+'[4]').AsString;
      setLength(clientMachines, (length(clientMachines)+1));
      clientRoom:=jData.findPath(IntToStr(c)+'[0]').AsString;
      clientName:=jData.findPath(IntToStr(c)+'[1]').AsString;
      clientIp:=jData.findPath(IntToStr(c)+'[2]').AsString;
      clientMac:=jData.findPath(IntToStr(c)+'[3]').AsString;
      clientMachines[(length(clientMachines)-1)]:=TClientMachine.create(clientRoom, clientName, clientIp, clientMac, mac, ip, serverURL, globalPw, StrToInt(clientInet), (c+1), mainScroll);
      clientMachines[(length(clientMachines)-1)].onShowStatus:=@updateMachineGrid;
      cache:=TStringList.create;
      cache.add(clientName+' (update...)');
      cache.add('Ausgeschaltet');
      if (clientInet = '1') then begin
        cache.add('Freigegeben');
      end
      else begin
        cache.add('Gesperrt');
      end;
      cache.add('Unbekannt');
      cache.add('Sperren / Freigeben');
      cache.add('Sperren / Freigeben');
      cache.add('Starten / Herunterfahren');
      machineGrid.rowCount:=machineGrid.rowCount+1;
      machineGrid.rows[(c+1)]:=cache;
      clientMachines[(length(clientMachines)-1)].updateStatus;
      c:=c+1;
    end;
  end;
end;

procedure Twindow.updateMachineStatus;
var
  c: integer;
begin
  c:=0;
  while (c < length(clientMachines)) do begin
    machineGrid.rows[(c+1)][0]:=clientMachines[c].getName+' (update...)';
    clientMachines[c].updateStatus;
    c:=c+1;
  end;
end;

procedure Twindow.updateMachineGrid(status: string);
var
  split: TStringList;
begin
  split:=TStringList.create;
  split.delimiter:='&';
  split.delimitedText:=status;
  machineGrid.rows[StrToInt(split[1])][0]:=clientMachines[(StrToInt(split[1])-1)].getName;
  if (split[0] = '0') then begin
    machineGrid.rows[StrToInt(split[1])][1]:='Ausgeschaltet';
    machineGrid.rows[StrToInt(split[1])][3]:='Unbekannt';
  end
  else if (split[0] = '1') then begin
    machineGrid.rows[StrToInt(split[1])][1]:='Erreichbar';
    machineGrid.rows[StrToInt(split[1])][3]:='Gesperrt';
  end
  else if (split[0] = '2') then begin
    machineGrid.rows[StrToInt(split[1])][1]:='Erreichbar';
    machineGrid.rows[StrToInt(split[1])][3]:='Freigegeben';
  end;
  if (split[2] = '1') then begin
    machineGrid.rows[StrToInt(split[1])][2]:='Freigegeben';
  end
  else begin
    machineGrid.rows[StrToInt(split[1])][2]:='Gesperrt';
  end;
end;

procedure Twindow.setAllowOffline(value: string);
begin
  if (value = '1') then begin
    allowOffline:=true;
  end
  else begin
    allowOffline:=false;
  end;
end;

procedure Twindow.setHelpURL(url: string);
begin
  if (url <> '') then begin
    helpURL:=url;
    sHelpMenu.visible:=true;
  end;
end;

function Twindow.sendRequest(url, params: string): string;
var
   Response: TMemoryStream;
begin
   Response := TMemoryStream.Create;
   try
      if HttpPostURL(url, params, Response) then
         result:=MemStreamToString(Response);
   finally
      Response.Free;
   end;
end;

function Twindow.MemStreamToString(Strm: TMemoryStream): AnsiString;
begin
   if Strm <> nil then begin
      Strm.Position := 0;
      SetString(Result, PChar(Strm.Memory), Strm.Size);
   end;
end;

function Twindow.ValidateIP(IP4: string): Boolean; // Coding by Dave Sonsalla
var
  Octet : String;
  Dots, I : Integer;
begin
  IP4 := IP4+'.'; //add a dot. We use a dot to trigger the Octet check, so need the last one
  Dots := 0;
  Octet := '0';
  for I := 1 to length(IP4) do begin
    if IP4[I] in ['0'..'9','.'] then begin
      if IP4[I] = '.' then begin //found a dot so inc dots and check octet value
        Inc(Dots);
        if (length(Octet) =1) Or (StrToInt(Octet) > 255) then Dots := 5; //Either there's no number or it's higher than 255 so push dots out of range
        Octet := '0'; // Reset to check the next octet
      end // End of IP4[I] is a dot
      else // Else IP4[I] is not a dot so
        Octet := Octet + IP4[I]; // Add the next character to the octet
    end // End of IP4[I] is not a dot
    else // Else IP4[I] Is not in CheckSet so
      Dots := 5; // Push dots out of range
  end;
  result := (Dots = 4) // The only way that Dots will equal 4 is if we passed all the tests
end;

end.
