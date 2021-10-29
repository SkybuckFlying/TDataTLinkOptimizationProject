program TestProject;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitMainGUI in '..\Source files\UnitMainGUI.pas' {Form1},
  UnitTDataTLink in '..\Source files\UnitTDataTLink.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
