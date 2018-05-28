unit UVNCView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, ExtCtrls, Forms, Controls, Graphics, base64,
  UCreateImageThread, UControlMachineThread;

type
  TVNCView = class
    private
      id, row, col: integer;
      name, ip, room: string;
      scroll: TScrollBox;
      box: TGroupBox;
      viewport: TImage;
      control: TButton;
      timer: TTimer;
      text: TLabel;
      imageThread: TCreateImageThread;
      controlThread: TControlMachineThread;
      procedure updateImage(Sender: TObject);
      procedure openRemoteControl(Sender: TObject);
    public
      constructor create(cid: integer; cname, cip, croom: string; cscroll: TScrollBox);
      procedure setActive(mode: boolean);
      procedure reposition;
      procedure loadNewImage(data: string);
  end;

implementation

uses
  PCS;

constructor TVNCView.create(cid: integer; cname, cip, croom: string; cscroll: TScrollBox);
var
  c: integer;
begin
  id:=cid;
  name:=cname;
  room:=croom;
  scroll:=cscroll;
  ip:=cip;
  c:=0;
  col:=0;
  row:=1;
  while (c < id) do begin
    col:=col+1;
    if (col = 5) then begin
      col:=1;
      row:=row+1;
    end;
    c:=c+1;
  end;
  timer:=TTimer.create(Application);
  timer.enabled:=false;
  timer.interval:=5000;
  timer.onTimer:=@updateImage;
  box:=TGroupBox.create(Application);
  box.width:=((window.width - 65) div 4);
  box.height:=(round(0.8 * box.width) + 50);
  box.left:=(5 + ((box.width + 5) * (col - 1)));
  box.top:=(5 + ((box.height + 5) * (row - 1)));
  box.parent:=scroll;
  box.caption:=name;
  viewport:=TImage.create(Application);
  viewport.parent:=box;
  viewport.left:=0;
  viewport.top:=0;
  viewport.width:=box.width;
  viewport.height:=(box.height - 30);
  viewport.Stretch:=true;
  viewport.Proportional:=true;
  viewport.visible:=false;
  viewport.antialiasingMode:=amOn;
  control:=TButton.create(Application);
  control.parent:=box;
  control.width:=107;
  control.height:=25;
  control.top:=(box.height - 20 - control.height);
  control.left:=(box.width - 5 - control.width);
  control.caption:='Rechner steuern';
  control.onClick:=@openRemoteControl;
  text:=TLabel.create(Application);
  text.parent:=box;
  text.left:=10;
  text.top:=10;
  text.caption:='Rechner ausgeschaltet.';
  text.font.size:=15;
end;

procedure TVNCView.setActive(mode: boolean);
begin
  if (mode = true) then begin
    viewport.visible:=true;
    text.visible:=false;
    control.enabled:=true;
    timer.enabled:=true;
  end
  else begin
    viewport.visible:=false;
    text.visible:=true;
    control.enabled:=false;
    timer.enabled:=false;
  end;
end;

procedure TVNCView.reposition;
begin
  box.width:=((window.width - 65) div 4);
  box.height:=(round(0.8 * box.width) + 50);
  box.left:=(5 + ((box.width + 5) * (col - 1)));
  box.top:=(5 + ((box.height + 5) * (row - 1)));
  viewport.width:=box.width;
  viewport.height:=(box.height - 30);
  control.top:=(box.height - 20 - control.height);
  control.left:=(box.width - 5 - control.width);
end;

procedure TVNCView.updateImage(Sender: TObject);
begin
  if (window.MainPageCtrl.activePage = window.vncSheet) then begin
    imageThread:=TCreateImageThread.create(name, ip, room);
    imageThread.OnShowStatus:=@loadNewImage;
    imageThread.resume;
  end;
end;

procedure TVNCView.openRemoteControl(Sender: TObject);
begin
  controlThread:=TControlMachineThread.create(ip, room, name);
  controlThread.resume;
end;

procedure TVNCView.loadNewImage(data: string);
var
  Image: TJPEGImage;
  MStream: TStringStream;
begin
  MStream:=TStringStream.create('');
  MStream.WriteString(DecodeStringBase64(data));
  MStream.position:=0;
  Image:=TJPEGImage.create;
  Image.loadFromStream(MStream);
  viewport.picture.jpeg:=Image;
  Image.free;
  MStream.free;
end;

end.

