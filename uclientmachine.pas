unit UClientMachine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, HTTPSend, UVNCView, Forms, UClientStatusThread,
  ssl_openssl;

type
  TClientMachine = class
    private
      FOnShowStatus: TShowStatusEvent;
      room, name, ip, mac, hostMac, hostIp, serverURL, globalPw: string;
      inet, id, isLocked: integer;
      online: boolean;
      VNC: TVNCView;
      procedure doMachineRequest(param: string);
      procedure showStatus(status: string);
      function sendRequest(url, params: string): string;
      function MemStreamToString(Strm: TMemoryStream): AnsiString;
    public
      constructor create(croom, cname, cip, cmac, chostMac, chostIp, cserverURL, cglobalPw: string; cinet, cid: integer; cscroll: TScrollBox);
      function getName:string;
      procedure lock(mode: boolean);
      procedure lockInet(mode: boolean);
      procedure shutdown;
      procedure wake;
      procedure reposition;
      procedure updateStatus;
      property OnShowStatus: TShowStatusEvent read FOnShowStatus write FOnShowStatus;
  end;

implementation

constructor TClientMachine.create(croom, cname, cip, cmac, chostMac, chostIp, cserverURL, cglobalPw: string; cinet, cid: integer; cscroll: TScrollBox);
begin
  room:=croom;
  name:=cname;
  ip:=cip;
  mac:=cmac;
  inet:=cinet;
  hostMac:=chostMac;
  hostIp:=chostIp;
  serverURL:=cserverURL;
  globalPw:=cglobalPw;
  online:=false;
  isLocked:=2;
  id:=cid;
  VNC:=TVNCView.create(id, name, ip, room, cscroll);
end;

function TClientMachine.getName:string;
begin
  result:=name;
end;

procedure TClientMachine.lock(mode: boolean);
begin
  if (online) then begin
    if (mode) then begin
      doMachineRequest('lock');
    end
    else begin
      doMachineRequest('unlock');
    end;
  end;
end;

procedure TClientMachine.lockInet(mode: boolean);
begin
  if (mode = true) then begin
    sendRequest('https://'+serverURL+'/client.php', 'usage=internet&globalpw='+globalPW+'&machine='+hostMac+'&ip='+hostIp+'&task=single&lock=0&target='+mac);
  end
  else begin
    sendRequest('https://'+serverURL+'/client.php', 'usage=internet&globalpw='+globalPW+'&machine='+hostMac+'&ip='+hostIp+'&task=single&lock=1&target='+mac);
  end;
end;

procedure TClientMachine.shutdown;
begin
  if (online) then begin
    doMachineRequest('shutdown');
  end;
end;

procedure TClientMachine.wake;
begin
  sendRequest('https://'+serverURL+'/client.php', 'usage=wake&globalpw='+globalPW+'&machine='+hostMac+'&ip='+hostIp+'&targetMac='+mac+'&targetIp='+ip);
end;

procedure TClientMachine.reposition;
begin
  VNC.reposition;
end;

procedure TClientMachine.doMachineRequest(param: string);
begin
  if (online = true) then begin
    sendRequest('http://'+ip+':34567/'+room+'/'+name+'/'+param, '');
  end;
end;

procedure TClientMachine.updateStatus;
var
  thread: TClientStatusThread;
begin
  thread:=TClientStatusThread.create(ip);
  thread.OnShowStatus:=@ShowStatus;
  thread.resume;
end;

procedure TClientMachine.showStatus(status: string);
var
  response, inetVal: string;
begin
  response:=sendRequest('https://'+serverURL+'/client.php', 'usage=checkinet&globalpw='+globalPW+'&machine='+hostMac+'&ip='+hostIp+'&hwaddr='+mac);
  if (response = '1') then begin
    inetVal:='1';
  end
  else begin
    inetVal:='0';
  end;
  if (status = '0') then begin
    online:=false;
    isLocked:=2;
    VNC.setActive(false);
  end
  else if (status = '1') then begin
    online:=true;
    isLocked:=1;
    VNC.setActive(true);
  end
  else if (status = '2') then begin
    online:=true;
    isLocked:=0;
    VNC.setActive(true);
  end;
  if Assigned(FOnShowStatus) then
    begin
      FOnShowStatus(status+'&'+IntToStr(id)+'&'+inetVal);
    end;
end;

function TClientMachine.sendRequest(url, params: string): string;
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

function TClientMachine.MemStreamToString(Strm: TMemoryStream): AnsiString;
begin
   if Strm <> nil then begin
      Strm.Position := 0;
      SetString(Result, PChar(Strm.Memory), Strm.Size);
   end;
end;

end.

